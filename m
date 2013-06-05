Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab3FEJBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 05:01:32 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:33569 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752941Ab3FEJBL (ORCPT
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
Subject: [PATCH 1/6] keucr: remove some unneccesary typedefs
Date: Wed,  5 Jun 2013 10:50:01 +0200
Message-Id: <1370422206-14961-2-git-send-email-of82ecuq@cip.cs.fau.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370422206-14961-1-git-send-email-of82ecuq@cip.cs.fau.de>
References: <1370422206-14961-1-git-send-email-of82ecuq@cip.cs.fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

resolves checkpatch.pl warning "do not add new typedefs"

Signed-off-by: Laura Lawniczak <laura.lawniczak@googlemail.com>
Signed-off-by: Johannes Schilling <of82ecuq@cip.cs.fau.de>
---
 drivers/staging/keucr/init.c |    2 +-
 drivers/staging/keucr/smil.h |   16 ----------------
 drivers/staging/keucr/usb.c  |    4 ++--
 drivers/staging/keucr/usb.h  |   18 +++++++++---------
 4 files changed, 12 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/keucr/init.c b/drivers/staging/keucr/init.c
index cb50eb2..3d8d8a9 100644
--- a/drivers/staging/keucr/init.c
+++ b/drivers/staging/keucr/init.c
@@ -89,7 +89,7 @@ int ENE_SMInit(struct us_data *us)
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
-	us->SM_Status = *(PSM_STATUS)&buf[0];
+	us->SM_Status = *(struct _SM_STATUS *)&buf[0];
 
 	us->SM_DeviceID = buf[1];
 	us->SM_CardID   = buf[2];
diff --git a/drivers/staging/keucr/smil.h b/drivers/staging/keucr/smil.h
index 24a636a..a8a9512 100644
--- a/drivers/staging/keucr/smil.h
+++ b/drivers/staging/keucr/smil.h
@@ -177,15 +177,6 @@ struct SSFDCTYPE {
 	WORD MaxLogBlocks;
 };
 
-typedef struct SSFDCTYPE_T {
-	BYTE Model;
-	BYTE Attribute;
-	BYTE MaxZones;
-	BYTE MaxSectors;
-	WORD MaxBlocks;
-	WORD MaxLogBlocks;
-} *SSFDCTYPE_T;
-
 struct ADDRESS {
 	BYTE Zone;	/* Zone Number */
 	BYTE Sector;	/* Sector(512byte) Number on Block */
@@ -193,13 +184,6 @@ struct ADDRESS {
 	WORD LogBlock;	/* Logical Block Number of Zone */
 };
 
-typedef struct ADDRESS_T {
-	BYTE Zone;	/* Zone Number */
-	BYTE Sector;	/* Sector(512byte) Number on Block */
-	WORD PhyBlock;	/* Physical Block Number on Zone */
-	WORD LogBlock;	/* Logical Block Number of Zone */
-} *ADDRESS_T;
-
 struct CIS_AREA {
 	BYTE Sector;	/* Sector(512byte) Number on Block */
 	WORD PhyBlock;	/* Physical Block Number on Zone 0 */
diff --git a/drivers/staging/keucr/usb.c b/drivers/staging/keucr/usb.c
index 0608a5c..96d8868 100644
--- a/drivers/staging/keucr/usb.c
+++ b/drivers/staging/keucr/usb.c
@@ -65,7 +65,7 @@ static int eucr_resume(struct usb_interface *iface)
 
 	us->Power_IsResum = true;
 
-	us->SM_Status = *(PSM_STATUS)&tmp;
+	us->SM_Status = *(struct _SM_STATUS *)&tmp;
 
 	return 0;
 }
@@ -87,7 +87,7 @@ static int eucr_reset_resume(struct usb_interface *iface)
 
 	us->Power_IsResum = true;
 
-	us->SM_Status = *(PSM_STATUS)&tmp;
+	us->SM_Status = *(struct _SM_STATUS *)&tmp;
 
 	return 0;
 }
diff --git a/drivers/staging/keucr/usb.h b/drivers/staging/keucr/usb.h
index 2dc75b0..e91475e 100644
--- a/drivers/staging/keucr/usb.h
+++ b/drivers/staging/keucr/usb.h
@@ -51,7 +51,7 @@ struct us_unusual_dev {
 #define FDIR_WRITE        0
 #define FDIR_READ         1
 
-typedef struct _SD_STATUS {
+struct _SD_STATUS {
 	BYTE    Insert:1;
 	BYTE    Ready:1;
 	BYTE    MediaChange:1;
@@ -60,9 +60,9 @@ typedef struct _SD_STATUS {
 	BYTE    HiSpeed:1;
 	BYTE    WtP:1;
 	BYTE    Reserved:1;
-} SD_STATUS, *PSD_STATUS;
+};
 
-typedef struct _MS_STATUS {
+struct _MS_STATUS {
 	BYTE    Insert:1;
 	BYTE    Ready:1;
 	BYTE    MediaChange:1;
@@ -71,16 +71,16 @@ typedef struct _MS_STATUS {
 	BYTE    Reserved1:1;
 	BYTE    WtP:1;
 	BYTE    Reserved2:1;
-} MS_STATUS, *PMS_STATUS;
+};
 
-typedef struct _SM_STATUS {
+struct _SM_STATUS {
 	BYTE    Insert:1;
 	BYTE    Ready:1;
 	BYTE    MediaChange:1;
 	BYTE    Reserved:3;
 	BYTE    WtP:1;
 	BYTE    IsMS:1;
-} SM_STATUS, *PSM_STATUS;
+};
 
 /* SD Block Length */
 #define SD_BLOCK_LEN		9	/* 2^9 = 512 Bytes,
@@ -178,9 +178,9 @@ struct us_data {
 	pm_hook			suspend_resume_hook;
 #endif
 	/* for 6250 code */
-	SD_STATUS   SD_Status;
-	MS_STATUS   MS_Status;
-	SM_STATUS   SM_Status;
+	struct _SD_STATUS   SD_Status;
+	struct _MS_STATUS   MS_Status;
+	struct _SM_STATUS   SM_Status;
 
 	/* ----- SD Control Data ---------------- */
 	/* SD_REGISTER SD_Regs; */
-- 
1.7.10.4

