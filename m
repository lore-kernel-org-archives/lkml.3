Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbaLGWZ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 17:25:59 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:34077 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbaLGWZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 17:25:58 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthew Casey <mdcasey@chabloom.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8192e: rtl8192e: rtl_cam.c:  Remove unused function
Date: Sun,  7 Dec 2014 23:28:37 +0100
Message-Id: <1417991317-19782-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function CAM_read_entry() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/rtl8192e/rtl8192e/rtl_cam.c |   29 ---------------------------
 drivers/staging/rtl8192e/rtl8192e/rtl_cam.h |    2 --
 2 files changed, 31 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_cam.c b/drivers/staging/rtl8192e/rtl8192e/rtl_cam.c
index 6c64e08..89ea70b 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_cam.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_cam.c
@@ -167,35 +167,6 @@ void setKey(struct net_device *dev, u8 EntryNo, u8 KeyIndex, u16 KeyType,
 	RT_TRACE(COMP_SEC, "=========>after set key, usconfig:%x\n", usConfig);
 }
 
-void CAM_read_entry(struct net_device *dev, u32 iIndex)
-{
-	u32 target_command = 0;
-	u32 target_content = 0;
-	u8 entry_i = 0;
-	u32 ulStatus;
-	s32 i = 100;
-
-	for (entry_i = 0; entry_i < CAM_CONTENT_COUNT; entry_i++) {
-		target_command = entry_i+CAM_CONTENT_COUNT*iIndex;
-		target_command = target_command | BIT31;
-
-		while ((i--) >= 0) {
-			ulStatus = read_nic_dword(dev, RWCAM);
-			if (ulStatus & BIT31)
-				continue;
-			else
-				break;
-		}
-		write_nic_dword(dev, RWCAM, target_command);
-		RT_TRACE(COMP_SEC, "CAM_read_entry(): WRITE A0: %x\n",
-			 target_command);
-		target_content = read_nic_dword(dev, RCAMO);
-		RT_TRACE(COMP_SEC, "CAM_read_entry(): WRITE A8: %x\n",
-			 target_content);
-	}
-	printk(KERN_INFO "\n");
-}
-
 void CamRestoreAllEntry(struct net_device *dev)
 {
 	u8 EntryId = 0;
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_cam.h b/drivers/staging/rtl8192e/rtl8192e/rtl_cam.h
index 7d075d3..3c4c0e6 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_cam.h
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_cam.h
@@ -41,6 +41,4 @@ void write_cam(struct net_device *dev, u8 addr, u32 data);
 
 void CamRestoreAllEntry(struct net_device *dev);
 
-void CAM_read_entry(struct net_device *dev, u32 iIndex);
-
 #endif
-- 
1.7.10.4

