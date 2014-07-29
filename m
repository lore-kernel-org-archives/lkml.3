Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbaG2AJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 20:09:55 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:52720 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbaG2AJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 20:09:54 -0400
From: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, klmckinney1@gmail.com, mail@beyermatthias.de,
        Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Subject: [PATCH] Staging: bcm: Bcmchar.c: remove else statement after return
Date: Mon, 28 Jul 2014 21:09:14 -0300
Message-Id: <1406592554-9519-1-git-send-email-mopsfelder@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes checkpatch.pl script happier by fixing all warnings
related to else statement after break or return.

Signed-off-by: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
---
 drivers/staging/bcm/Bcmchar.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index c1e01f7..5790627 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -561,10 +561,10 @@ static int bcm_char_ioctl_gpio_set_request(void __user *argp,
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL,
 				"GPIO_MODE_REGISTER read failed");
 		return Status;
-	} else {
-		Status = STATUS_SUCCESS;
 	}
 
+	Status = STATUS_SUCCESS;
+
 	/* Set the gpio mode register to output */
 	*(UINT *)ucResetValue |= (1<<uiBit);
 	Status = wrmaltWithLock(Adapter, GPIO_MODE_REGISTER,
@@ -669,10 +669,10 @@ static int bcm_char_ioctl_gpio_status_request(void __user *argp,
 		Status = bytes;
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
 				"RDM Failed\n");
-		return Status;
 	} else {
 		Status = STATUS_SUCCESS;
 	}
+
 	return Status;
 }
 
@@ -763,10 +763,10 @@ static int bcm_char_ioctl_gpio_multi_request(void __user *argp,
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
 					"RDM to GPIO_PIN_STATE_REGISTER Failed.");
 			return Status;
-		} else {
-			Status = STATUS_SUCCESS;
 		}
 
+		Status = STATUS_SUCCESS;
+
 		pgpio_multi_info[WIMAX_IDX].uiGPIOValue =
 			(*(UINT *)ucResetValue &
 			pgpio_multi_info[WIMAX_IDX].uiGPIOMask);
@@ -819,10 +819,10 @@ static int bcm_char_ioctl_gpio_mode_request(void __user *argp,
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
 			"Read of GPIO_MODE_REGISTER failed");
 		return Status;
-	} else {
-		Status = STATUS_SUCCESS;
 	}
 
+	Status = STATUS_SUCCESS;
+
 	/* Validating the request */
 	if (IsReqGpioIsLedInNVM(Adapter, pgpio_multi_mode[WIMAX_IDX].uiGPIOMask)
 			== false) {
@@ -1076,11 +1076,11 @@ static int bcm_char_ioctl_buffer_download_stop(void __user *argp,
 		up(&Adapter->fw_download_sema);
 		up(&Adapter->NVMRdmWrmLock);
 		return Status;
-	} else {
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
-				DBG_LVL_ALL, "Firm Download Over...\n");
 	}
 
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+			DBG_LVL_ALL, "Firm Download Over...\n");
+
 	mdelay(10);
 
 	/* Wait for MailBox Interrupt */
@@ -2649,4 +2649,3 @@ void unregister_control_device_interface(struct bcm_mini_adapter *Adapter)
 		unregister_chrdev(Adapter->major, DEV_NAME);
 	}
 }
-
-- 
1.7.10.4

