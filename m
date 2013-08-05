Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab3HEJ6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 05:58:48 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:40927 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab3HEJ6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 05:58:46 -0400
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, justinmattock@gmail.com,
        ikerpedrosam@gmail.com, mujeeb.adil@gmail.com, harsh1kumar@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] Staging: winbond: wb35reg: changed sleep function from msleep to usleep
Date: Mon,  5 Aug 2013 11:58:27 +0200
Message-Id: <1375696712-5276-2-git-send-email-ikerpedrosam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375696712-5276-1-git-send-email-ikerpedrosam@gmail.com>
References: <1375696712-5276-1-git-send-email-ikerpedrosam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed sleep function from msleep to usleep according to the documentation.

Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>
---
 drivers/staging/winbond/wb35reg.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/winbond/wb35reg.c b/drivers/staging/winbond/wb35reg.c
index 9be1b3b..34a2618 100644
--- a/drivers/staging/winbond/wb35reg.c
+++ b/drivers/staging/winbond/wb35reg.c
@@ -134,7 +134,7 @@ unsigned char Wb35Reg_WriteSync(struct hw_data *pHwData, u16 RegisterNo, u32 Reg
 
 	/* Wait until EP0VM stop */
 	while (reg->EP0vm_state != VM_STOP)
-		msleep(10);
+		usleep(10000);
 
 	/* Sync IoCallDriver */
 	reg->EP0vm_state = VM_RUNNING;
@@ -301,7 +301,7 @@ unsigned char Wb35Reg_ReadSync(struct hw_data *pHwData, u16 RegisterNo, u32 *pRe
 
 	/* Wait until EP0VM stop */
 	while (reg->EP0vm_state != VM_STOP)
-		msleep(10);
+		usleep(10000);
 
 	reg->EP0vm_state = VM_RUNNING;
 	ret = usb_control_msg(pHwData->udev,
@@ -501,9 +501,9 @@ void Wb35Reg_destroy(struct hw_data *pHwData)
 
 	/* Wait for Reg operation completed */
 	do {
-		msleep(10); /* Delay for waiting function enter */
+		usleep(10000); /* Delay for waiting function enter */
 	} while (reg->EP0vm_state != VM_STOP);
-	msleep(10);  /* Delay for waiting function enter */
+	usleep(10000);  /* Delay for waiting function enter */
 
 	/* Release all the data in RegQueue */
 	spin_lock_irq(&reg->EP0VM_spin_lock);
-- 
1.8.1.2

