Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbbAAPRi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 10:17:38 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:61213 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbbAAPRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 10:17:37 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: amcc: crypto4xx_sa.c:  Remove unused function
Date: Thu,  1 Jan 2015 16:13:47 +0100
Message-Id: <1420125228-26679-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function get_dynamic_sa_offset_iv_field() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/crypto/amcc/crypto4xx_sa.c |   23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_sa.c b/drivers/crypto/amcc/crypto4xx_sa.c
index de8a7a4..69182e2 100644
--- a/drivers/crypto/amcc/crypto4xx_sa.c
+++ b/drivers/crypto/amcc/crypto4xx_sa.c
@@ -34,29 +34,6 @@
 #include "crypto4xx_sa.h"
 #include "crypto4xx_core.h"
 
-u32 get_dynamic_sa_offset_iv_field(struct crypto4xx_ctx *ctx)
-{
-	u32 offset;
-	union dynamic_sa_contents cts;
-
-	if (ctx->direction == DIR_INBOUND)
-		cts.w = ((struct dynamic_sa_ctl *)(ctx->sa_in))->sa_contents;
-	else
-		cts.w = ((struct dynamic_sa_ctl *)(ctx->sa_out))->sa_contents;
-	offset = cts.bf.key_size
-		+ cts.bf.inner_size
-		+ cts.bf.outer_size
-		+ cts.bf.spi
-		+ cts.bf.seq_num0
-		+ cts.bf.seq_num1
-		+ cts.bf.seq_num_mask0
-		+ cts.bf.seq_num_mask1
-		+ cts.bf.seq_num_mask2
-		+ cts.bf.seq_num_mask3;
-
-	return sizeof(struct dynamic_sa_ctl) + offset * 4;
-}
-
 u32 get_dynamic_sa_offset_state_ptr_field(struct crypto4xx_ctx *ctx)
 {
 	u32 offset;
-- 
1.7.10.4

