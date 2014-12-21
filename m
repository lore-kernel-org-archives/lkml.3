Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbaLUR4D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 12:56:03 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41533 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbaLUR4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 12:56:01 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: pci: solo6x10: solo6x10-enc.c:  Remove unused function
Date: Sun, 21 Dec 2014 18:58:47 +0100
Message-Id: <1419184727-11224-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function solo_s_jpeg_qp() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/media/pci/solo6x10/solo6x10-enc.c |   35 -----------------------------
 drivers/media/pci/solo6x10/solo6x10.h     |    2 --
 2 files changed, 37 deletions(-)

diff --git a/drivers/media/pci/solo6x10/solo6x10-enc.c b/drivers/media/pci/solo6x10/solo6x10-enc.c
index d19c0ae..6b589b8 100644
--- a/drivers/media/pci/solo6x10/solo6x10-enc.c
+++ b/drivers/media/pci/solo6x10/solo6x10-enc.c
@@ -175,41 +175,6 @@ out:
 	return 0;
 }
 
-/**
- * Set channel Quality Profile (0-3).
- */
-void solo_s_jpeg_qp(struct solo_dev *solo_dev, unsigned int ch,
-		    unsigned int qp)
-{
-	unsigned long flags;
-	unsigned int idx, reg;
-
-	if ((ch > 31) || (qp > 3))
-		return;
-
-	if (solo_dev->type == SOLO_DEV_6010)
-		return;
-
-	if (ch < 16) {
-		idx = 0;
-		reg = SOLO_VE_JPEG_QP_CH_L;
-	} else {
-		ch -= 16;
-		idx = 1;
-		reg = SOLO_VE_JPEG_QP_CH_H;
-	}
-	ch *= 2;
-
-	spin_lock_irqsave(&solo_dev->jpeg_qp_lock, flags);
-
-	solo_dev->jpeg_qp[idx] &= ~(3 << ch);
-	solo_dev->jpeg_qp[idx] |= (qp & 3) << ch;
-
-	solo_reg_write(solo_dev, reg, solo_dev->jpeg_qp[idx]);
-
-	spin_unlock_irqrestore(&solo_dev->jpeg_qp_lock, flags);
-}
-
 int solo_g_jpeg_qp(struct solo_dev *solo_dev, unsigned int ch)
 {
 	int idx;
diff --git a/drivers/media/pci/solo6x10/solo6x10.h b/drivers/media/pci/solo6x10/solo6x10.h
index 72017b7..ad5afc6 100644
--- a/drivers/media/pci/solo6x10/solo6x10.h
+++ b/drivers/media/pci/solo6x10/solo6x10.h
@@ -399,8 +399,6 @@ int solo_eeprom_write(struct solo_dev *solo_dev, int loc,
 		      __be16 data);
 
 /* JPEG Qp functions */
-void solo_s_jpeg_qp(struct solo_dev *solo_dev, unsigned int ch,
-		    unsigned int qp);
 int solo_g_jpeg_qp(struct solo_dev *solo_dev, unsigned int ch);
 
 #define CHK_FLAGS(v, flags) (((v) & (flags)) == (flags))
-- 
1.7.10.4

