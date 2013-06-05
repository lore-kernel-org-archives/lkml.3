Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab3FEJBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 05:01:33 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:33570 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752801Ab3FEJBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 05:01:11 -0400
From: Johannes Schilling <of82ecuq@cip.cs.fau.de>
To: linux-kernel@vger.kernel.org
Cc: linux-kernel@i4.cs.fau.de, Al Cho <acho@novell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>,
        Kurt Kanzenbach <shifty91@gmail.com>, devel@driverdev.osuosl.org,
        Johannes Schilling <of82ecuq@cip.cs.fau.de>,
        Laura Lawniczak <laura.lawniczak@googlemail.com>
Subject: [PATCH 2/6] keucr: fix some camelCase warnings
Date: Wed,  5 Jun 2013 10:50:02 +0200
Message-Id: <1370422206-14961-3-git-send-email-of82ecuq@cip.cs.fau.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370422206-14961-1-git-send-email-of82ecuq@cip.cs.fau.de>
References: <1370422206-14961-1-git-send-email-of82ecuq@cip.cs.fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

resolves checkpatch warning "Avoid CamelCase"

Signed-off-by: Laura Lawniczak <laura.lawniczak@googlemail.com>
Signed-off-by: Johannes Schilling <of82ecuq@cip.cs.fau.de>
---
 drivers/staging/keucr/init.c |    8 ++++----
 drivers/staging/keucr/init.h |    8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/keucr/init.c b/drivers/staging/keucr/init.c
index 3d8d8a9..a0fdffd 100644
--- a/drivers/staging/keucr/init.c
+++ b/drivers/staging/keucr/init.c
@@ -100,8 +100,8 @@ int ENE_SMInit(struct us_data *us)
 		printk(KERN_INFO "WtP        = %x\n", us->SM_Status.WtP);
 		printk(KERN_INFO "DeviceID   = %x\n", us->SM_DeviceID);
 		printk(KERN_INFO "CardID     = %x\n", us->SM_CardID);
-		MediaChange = 1;
-		Check_D_MediaFmt(us);
+		media_change = 1;
+		check_d_media_fmt(us);
 	} else {
 		printk(KERN_ERR "SM Card Not Ready --- %x\n", buf[0]);
 		return USB_STOR_TRANSPORT_ERROR;
@@ -131,11 +131,11 @@ int ENE_LoadBinCode(struct us_data *us, BYTE flag)
 	/* For SS */
 	case SM_INIT_PATTERN:
 		printk(KERN_INFO "SM_INIT_PATTERN\n");
-		memcpy(buf, SM_Init, 0x800);
+		memcpy(buf, sm_init, 0x800);
 		break;
 	case SM_RW_PATTERN:
 		printk(KERN_INFO "SM_RW_PATTERN\n");
-		memcpy(buf, SM_Rdwr, 0x800);
+		memcpy(buf, sm_rdwr, 0x800);
 		break;
 	}
 
diff --git a/drivers/staging/keucr/init.h b/drivers/staging/keucr/init.h
index c8b2cd6..64a7ab8 100644
--- a/drivers/staging/keucr/init.h
+++ b/drivers/staging/keucr/init.h
@@ -1,11 +1,11 @@
 #include "common.h"
 
-extern DWORD MediaChange;
-extern int Check_D_MediaFmt(struct us_data *);
+extern DWORD media_change;
+extern int check_d_media_fmt(struct us_data *);
 
 
 
-static BYTE SM_Init[] = {
+static BYTE sm_init[] = {
 0x7B, 0x09, 0x7C, 0xF0, 0x7D, 0x10, 0x7E, 0xE9,
 0x7F, 0xCC, 0x12, 0x2F, 0x71, 0x90, 0xE9, 0xCC,
 0xE0, 0xB4, 0x07, 0x12, 0x90, 0xFF, 0x09, 0xE0,
@@ -263,7 +263,7 @@ static BYTE SM_Init[] = {
 0x58, 0x44, 0x2D, 0x49, 0x6E, 0x69, 0x74, 0x20,
 0x20, 0x20, 0x20, 0x31, 0x30, 0x30, 0x30, 0x31 };
 
-static BYTE SM_Rdwr[] = {
+static BYTE sm_rdwr[] = {
 0x7B, 0x0C, 0x7C, 0xF0, 0x7D, 0x10, 0x7E, 0xE9,
 0x7F, 0xCC, 0x12, 0x2F, 0x71, 0x90, 0xE9, 0xC3,
 0xE0, 0xB4, 0x73, 0x04, 0x74, 0x40, 0x80, 0x09,
-- 
1.7.10.4

