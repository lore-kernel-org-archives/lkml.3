Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab3CJMsh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 08:48:37 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:55451 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab3CJMsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 08:48:36 -0400
From: Mihnea Dobrescu-Balaur <mihneadb@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, klmckinney1@gmail.com,
        linux-kernel@vger.kernel.org,
        Mihnea Dobrescu-Balaur <mihneadb@gmail.com>
Subject: [PATCH] bcm: don't cast kzalloc() return value
Date: Sun, 10 Mar 2013 14:48:27 +0200
Message-Id: <1362919707-20784-1-git-send-email-mihneadb@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mihnea Dobrescu-Balaur <mihneadb@gmail.com>
---
 drivers/staging/bcm/nvm.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/bcm/nvm.c b/drivers/staging/bcm/nvm.c
index e6152f4..bea1330 100644
--- a/drivers/staging/bcm/nvm.c
+++ b/drivers/staging/bcm/nvm.c
@@ -2228,20 +2228,20 @@ int BcmAllocFlashCSStructure(struct bcm_mini_adapter *psAdapter)
 		BCM_DEBUG_PRINT(psAdapter, DBG_TYPE_PRINTK, 0, 0, "Adapter structure point is NULL");
 		return -EINVAL;
 	}
-	psAdapter->psFlashCSInfo = (struct bcm_flash_cs_info *)kzalloc(sizeof(struct bcm_flash_cs_info), GFP_KERNEL);
+	psAdapter->psFlashCSInfo = kzalloc(sizeof(struct bcm_flash_cs_info), GFP_KERNEL);
 	if (psAdapter->psFlashCSInfo == NULL) {
 		BCM_DEBUG_PRINT(psAdapter, DBG_TYPE_PRINTK, 0, 0, "Can't Allocate memory for Flash 1.x");
 		return -ENOMEM;
 	}
 
-	psAdapter->psFlash2xCSInfo = (struct bcm_flash2x_cs_info *)kzalloc(sizeof(struct bcm_flash2x_cs_info), GFP_KERNEL);
+	psAdapter->psFlash2xCSInfo = kzalloc(sizeof(struct bcm_flash2x_cs_info), GFP_KERNEL);
 	if (!psAdapter->psFlash2xCSInfo) {
 		BCM_DEBUG_PRINT(psAdapter, DBG_TYPE_PRINTK, 0, 0, "Can't Allocate memory for Flash 2.x");
 		kfree(psAdapter->psFlashCSInfo);
 		return -ENOMEM;
 	}
 
-	psAdapter->psFlash2xVendorInfo = (struct bcm_flash2x_vendor_info *)kzalloc(sizeof(struct bcm_flash2x_vendor_info), GFP_KERNEL);
+	psAdapter->psFlash2xVendorInfo = kzalloc(sizeof(struct bcm_flash2x_vendor_info), GFP_KERNEL);
 	if (!psAdapter->psFlash2xVendorInfo) {
 		BCM_DEBUG_PRINT(psAdapter, DBG_TYPE_PRINTK, 0, 0, "Can't Allocate Vendor Info Memory for Flash 2.x");
 		kfree(psAdapter->psFlashCSInfo);
@@ -4074,7 +4074,7 @@ int BcmCopySection(struct bcm_mini_adapter *Adapter,
 	else
 		BuffSize = numOfBytes;
 
-	pBuff = (PCHAR)kzalloc(BuffSize, GFP_KERNEL);
+	pBuff = kzalloc(BuffSize, GFP_KERNEL);
 	if (!pBuff) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Memory allocation failed.. ");
 		return -ENOMEM;
@@ -4154,7 +4154,7 @@ int SaveHeaderIfPresent(struct bcm_mini_adapter *Adapter, PUCHAR pBuff, unsigned
 	}
 	/* If Header is present overwrite passed buffer with this */
 	if (bHasHeader && (Adapter->bHeaderChangeAllowed == FALSE)) {
-		pTempBuff = (PUCHAR)kzalloc(HeaderSizeToProtect, GFP_KERNEL);
+		pTempBuff = kzalloc(HeaderSizeToProtect, GFP_KERNEL);
 		if (!pTempBuff) {
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Memory allocation failed");
 			return -ENOMEM;
@@ -4563,7 +4563,7 @@ static int CorruptDSDSig(struct bcm_mini_adapter *Adapter, enum bcm_flash2x_sect
 		}
 	}
 
-	pBuff = (PUCHAR)kzalloc(MAX_RW_SIZE, GFP_KERNEL);
+	pBuff = kzalloc(MAX_RW_SIZE, GFP_KERNEL);
 	if (!pBuff) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Can't allocate memorey");
 		return -ENOMEM;
@@ -4622,7 +4622,7 @@ static int CorruptISOSig(struct bcm_mini_adapter *Adapter, enum bcm_flash2x_sect
 		return SECTOR_IS_NOT_WRITABLE;
 	}
 
-	pBuff = (PUCHAR)kzalloc(MAX_RW_SIZE, GFP_KERNEL);
+	pBuff = kzalloc(MAX_RW_SIZE, GFP_KERNEL);
 	if (!pBuff) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Can't allocate memorey");
 		return -ENOMEM;
-- 
1.7.10.4

