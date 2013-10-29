Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319Ab3J2Whu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 18:37:50 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41042 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249Ab3J2Whs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 18:37:48 -0400
From: Joel Fernandes <joelf@ti.com>
To: <linux-crypto@vger.kernel.org>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Joel Fernandes <joelf@ti.com>
Subject: [PATCH] crypto: omap-aes: Fix CTR mode counter length
Date: Tue, 29 Oct 2013 17:37:38 -0500
Message-ID: <1383086258-22186-1-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NIST vectors for CTR mode in testmgr.h assume the entire IV as the counter. To
get correct results that match the output of these vectors, we need to set the
counter length correctly.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/crypto/omap-aes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index ce791c2..19055a1 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -275,7 +275,7 @@ static int omap_aes_write_ctrl(struct omap_aes_dev *dd)
 	if (dd->flags & FLAGS_CBC)
 		val |= AES_REG_CTRL_CBC;
 	if (dd->flags & FLAGS_CTR) {
-		val |= AES_REG_CTRL_CTR | AES_REG_CTRL_CTR_WIDTH_32;
+		val |= AES_REG_CTRL_CTR | AES_REG_CTRL_CTR_WIDTH_128;
 		mask = AES_REG_CTRL_CTR | AES_REG_CTRL_CTR_WIDTH_MASK;
 	}
 	if (dd->flags & FLAGS_ENCRYPT)
-- 
1.8.1.2

