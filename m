Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab3JZGQD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 02:16:03 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:54575 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab3JZGPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 02:15:36 -0400
From: Kevin McKinney <klmckinney1@gmail.com>
To: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, Kevin McKinney <klmckinney1@gmail.com>
Subject: [PATCH 10/11] Staging: bcm: Replace PVOID with void * in Adapter.h
Date: Sat, 26 Oct 2013 02:15:19 -0400
Message-Id: <1382768120-23380-10-git-send-email-klmckinney1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1382768120-23380-1-git-send-email-klmckinney1@gmail.com>
References: <1382768120-23380-1-git-send-email-klmckinney1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces "PVOID" with "void *"
in Adapter.h

Signed-off-by: Kevin McKinney <klmckinney1@gmail.com>
---
 drivers/staging/bcm/Adapter.h |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/bcm/Adapter.h b/drivers/staging/bcm/Adapter.h
index 2074c18..c5891dd 100644
--- a/drivers/staging/bcm/Adapter.h
+++ b/drivers/staging/bcm/Adapter.h
@@ -20,7 +20,7 @@ struct bcm_packettosend {
 } __packed;
 
 struct bcm_control_packet {
-	PVOID	ControlBuff;
+	void *ControlBuff;
 	unsigned int ControlBuffLen;
 	struct bcm_control_packet *next;
 } __packed;
@@ -208,9 +208,9 @@ struct bcm_targetdsx_buffer {
 	BOOLEAN		valid;
 };
 
-typedef int (*FP_FLASH_WRITE)(struct bcm_mini_adapter *, unsigned int, PVOID);
+typedef int (*FP_FLASH_WRITE)(struct bcm_mini_adapter *, unsigned int, void *);
 
-typedef int (*FP_FLASH_WRITE_STATUS)(struct bcm_mini_adapter *, unsigned int, PVOID);
+typedef int (*FP_FLASH_WRITE_STATUS)(struct bcm_mini_adapter *, unsigned int, void *);
 
 /*
  * Driver adapter data structure
@@ -308,22 +308,22 @@ struct bcm_mini_adapter {
 	/* Driver State for LED Blinking */
 	enum bcm_led_events	DriverState;
 	/* Interface Specific */
-	PVOID			pvInterfaceAdapter;
-	int (*bcm_file_download)(PVOID,
+	void *pvInterfaceAdapter;
+	int (*bcm_file_download)(void *,
 				struct file *,
 				unsigned int);
-	int (*bcm_file_readback_from_chip)(PVOID,
+	int (*bcm_file_readback_from_chip)(void *,
 					struct file *,
 					unsigned int);
-	int (*interface_rdm)(PVOID,
+	int (*interface_rdm)(void *,
 			unsigned int,
-			PVOID,
+			void *,
 			int);
-	int (*interface_wrm)(PVOID,
+	int (*interface_wrm)(void *,
 			unsigned int,
-			PVOID,
+			void *,
 			int);
-	int (*interface_transmit)(PVOID, PVOID , unsigned int);
+	int (*interface_transmit)(void *, void *, unsigned int);
 	BOOLEAN			IdleMode;
 	BOOLEAN			bDregRequestSentInIdleMode;
 	BOOLEAN			bTriedToWakeUpFromlowPowerMode;
-- 
1.7.9.5

