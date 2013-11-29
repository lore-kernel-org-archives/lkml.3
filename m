Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299Ab3K2RA2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 12:00:28 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:63368 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200Ab3K2RA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 12:00:26 -0500
From: Michal Nazarewicz <mpn@google.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Peter Huewe <peterhuewe@gmx.de>
Cc: Dan Morav <dmorav@nuvoton.com>, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH] char: tpm: nuvoton: remove unused variable
Date: Fri, 29 Nov 2013 18:00:18 +0100
Message-Id: <1385744418-9516-1-git-send-email-mpn@google.com>
X-Mailer: git-send-email 1.8.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

“wait” wait queue is defined but never used in the function, thus
it can be removed.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/char/tpm/tpm_i2c_nuvoton.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_i2c_nuvoton.c
index 6276fea..4f5ac25 100644
--- a/drivers/char/tpm/tpm_i2c_nuvoton.c
+++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
@@ -178,7 +178,6 @@ static int i2c_nuvoton_wait_for_stat(struct tpm_chip *chip, u8 mask, u8 value,
 {
 	if (chip->vendor.irq && queue) {
 		s32 rc;
-		DEFINE_WAIT(wait);
 		struct priv_data *priv = chip->vendor.priv;
 		unsigned int cur_intrs = priv->intrs;
 
-- 
1.8.4.1

