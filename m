Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab3FYI5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 04:57:32 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:38318 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab3FYIzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 04:55:48 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 3/6] crypto: ux500/crypt: add missing __iomem qualifiers
Date: Tue, 25 Jun 2013 10:54:46 +0200
Message-Id: <1372150489-25594-4-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1372150489-25594-1-git-send-email-fabio.baltieri@linaro.org>
References: <1372150489-25594-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing __iomem to struct cryp_register pointers, this solve some
"incorrect type in initializer (different address spaces)" sparse
warnings.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/crypto/ux500/cryp/cryp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ux500/cryp/cryp.c b/drivers/crypto/ux500/cryp/cryp.c
index 3eafa90..43a0c8a 100644
--- a/drivers/crypto/ux500/cryp/cryp.c
+++ b/drivers/crypto/ux500/cryp/cryp.c
@@ -291,7 +291,7 @@ void cryp_save_device_context(struct cryp_device_data *device_data,
 			      int cryp_mode)
 {
 	enum cryp_algo_mode algomode;
-	struct cryp_register *src_reg = device_data->base;
+	struct cryp_register __iomem *src_reg = device_data->base;
 	struct cryp_config *config =
 		(struct cryp_config *)device_data->current_ctx;
 
@@ -349,7 +349,7 @@ void cryp_save_device_context(struct cryp_device_data *device_data,
 void cryp_restore_device_context(struct cryp_device_data *device_data,
 				 struct cryp_device_context *ctx)
 {
-	struct cryp_register *reg = device_data->base;
+	struct cryp_register __iomem *reg = device_data->base;
 	struct cryp_config *config =
 		(struct cryp_config *)device_data->current_ctx;
 
-- 
1.8.2

