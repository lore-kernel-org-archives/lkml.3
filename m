Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979Ab3IJPos (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 11:44:48 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:39253 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab3IJPor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 11:44:47 -0400
From: Aldo Iljazi <neonsync1@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Aldo Iljazi <neonsync1@gmail.com>
Subject: [PATCH] Staging: bcm: nvm: fixed space prohibition
Date: Tue, 10 Sep 2013 18:44:39 +0300
Message-Id: <1378827879-4597-1-git-send-email-neonsync1@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed space prohibition before semicolon, particularly:

nvm.c:106: WARNING: space prohibited before semicolon
nvm.c:1098: WARNING: space prohibited before semicolon
nvm.c:1279: WARNING: space prohibited before semicolon
nvm.c:2834: WARNING: space prohibited before semicolon
nvm.c:3361: WARNING: space prohibited before semicolon
nvm.c:4453: WARNING: space prohibited before semicolon

Signed-off-by: Aldo Iljazi <neonsync1@gmail.com>
---
 drivers/staging/bcm/nvm.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/bcm/nvm.c b/drivers/staging/bcm/nvm.c
index 91a5715..1f5b62b 100644
--- a/drivers/staging/bcm/nvm.c
+++ b/drivers/staging/bcm/nvm.c
@@ -103,7 +103,7 @@ static UCHAR ReadEEPROMStatusRegister(struct bcm_mini_adapter *Adapter)
 		}
 		if (!(dwRetries%RETRIES_PER_DELAY))
 			udelay(1000);
-		uiStatus = 0 ;
+		uiStatus = 0;
 	}
 	return uiData;
 } /* ReadEEPROMStatusRegister */
@@ -1095,7 +1095,7 @@ static int BeceemFlashBulkWrite(struct bcm_mini_adapter *Adapter,
 				goto BeceemFlashBulkWrite_EXIT;
 			}
 			uiTemp = uiTemp - 1;
-			index = index + 1 ;
+			index = index + 1;
 		}
 	}
 	Adapter->SelectedChip = RESET_CHIP_SELECT;
@@ -1276,7 +1276,7 @@ static int BeceemFlashBulkWriteStatus(struct bcm_mini_adapter *Adapter,
 				goto BeceemFlashBulkWriteStatus_EXIT;
 			}
 			uiTemp = uiTemp - 1;
-			index = index + 1 ;
+			index = index + 1;
 		}
 	}
 
@@ -2831,7 +2831,7 @@ int BcmGetSectionValEndOffset(struct bcm_mini_adapter *Adapter, enum bcm_flash2x
 		SectEndOffset = INVALID_OFFSET;
 	}
 
-	return SectEndOffset ;
+	return SectEndOffset;
 }
 
 /*
@@ -3358,7 +3358,7 @@ int BcmSetActiveSection(struct bcm_mini_adapter *Adapter, enum bcm_flash2x_secti
 	/* struct bcm_dsd_header sDSD = {0};
 	 * struct bcm_iso_header sISO = {0};
 	 */
-	int HighestPriDSD = 0 ;
+	int HighestPriDSD = 0;
 	int HighestPriISO = 0;
 
 	Status = IsSectionWritable(Adapter, eFlash2xSectVal);
@@ -4450,7 +4450,7 @@ int WriteToFlashWithoutSectorErase(struct bcm_mini_adapter *Adapter,
 		BcmDoChipSelect(Adapter, uiOffset);
 		uiPartOffset = (uiOffset & (FLASH_PART_SIZE - 1)) + GetFlashBaseAddr(Adapter);
 
-		for (i = 0 ; i < uiNumBytes; i += Adapter->ulFlashWriteSize) {
+		for (i = 0; i < uiNumBytes; i += Adapter->ulFlashWriteSize) {
 			if (Adapter->ulFlashWriteSize == BYTE_WRITE_SUPPORT)
 				Status = flashByteWrite(Adapter, uiPartOffset, pcBuff);
 			else
-- 
1.7.10.4

