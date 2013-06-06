Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab3FFQLk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:11:40 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:47566 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753344Ab3FFQLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:11:35 -0400
From: Johannes Schilling <of82ecuq@cip.cs.fau.de>
To: linux-kernel@vger.kernel.org
Cc: linux-kernel@i4.cs.fau.de, Al Cho <acho@novell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>,
        Kurt Kanzenbach <shifty91@gmail.com>, devel@driverdev.osuosl.org,
        Laura Lawniczak <laura.lawniczak@googlemail.com>,
        Johannes Schilling <of82ecuq@cip.cs.fau.de>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 1/6] keucr: remove some unneccesary typedefs
Date: Thu,  6 Jun 2013 18:10:45 +0200
Message-Id: <1370535050-7167-2-git-send-email-of82ecuq@cip.cs.fau.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370535050-7167-1-git-send-email-of82ecuq@cip.cs.fau.de>
References: <20130605094517.GS28112@mwanda>
 <1370535050-7167-1-git-send-email-of82ecuq@cip.cs.fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

resolves checkpatch.pl warning "do not add new typedefs" and renames allcaps
structures.

Signed-off-by: Laura Lawniczak <laura.lawniczak@googlemail.com>
Signed-off-by: Johannes Schilling <of82ecuq@cip.cs.fau.de>
---
 drivers/staging/keucr/init.c    |    2 +-
 drivers/staging/keucr/smil.h    |   28 ++++++----------------------
 drivers/staging/keucr/smilsub.c |    6 +++---
 drivers/staging/keucr/usb.c     |    4 ++--
 drivers/staging/keucr/usb.h     |   18 +++++++++---------
 5 files changed, 21 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/keucr/init.c b/drivers/staging/keucr/init.c
index cb50eb2..ce25405 100644
--- a/drivers/staging/keucr/init.c
+++ b/drivers/staging/keucr/init.c
@@ -89,7 +89,7 @@ int ENE_SMInit(struct us_data *us)
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
-	us->SM_Status = *(PSM_STATUS)&buf[0];
+	us->SM_Status = *(struct keucr_sm_status *)&buf[0];
 
 	us->SM_DeviceID = buf[1];
 	us->SM_CardID   = buf[2];
diff --git a/drivers/staging/keucr/smil.h b/drivers/staging/keucr/smil.h
index 24a636a..1538d7b 100644
--- a/drivers/staging/keucr/smil.h
+++ b/drivers/staging/keucr/smil.h
@@ -168,7 +168,7 @@ SmartMedia Model & Attribute
 /***************************************************************************
 Struct Definition
 ***************************************************************************/
-struct SSFDCTYPE {
+struct keucr_media_info {
 	BYTE Model;
 	BYTE Attribute;
 	BYTE MaxZones;
@@ -177,30 +177,14 @@ struct SSFDCTYPE {
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
-struct ADDRESS {
+struct keucr_media_address {
 	BYTE Zone;	/* Zone Number */
 	BYTE Sector;	/* Sector(512byte) Number on Block */
 	WORD PhyBlock;	/* Physical Block Number on Zone */
 	WORD LogBlock;	/* Logical Block Number of Zone */
 };
 
-typedef struct ADDRESS_T {
-	BYTE Zone;	/* Zone Number */
-	BYTE Sector;	/* Sector(512byte) Number on Block */
-	WORD PhyBlock;	/* Physical Block Number on Zone */
-	WORD LogBlock;	/* Logical Block Number of Zone */
-} *ADDRESS_T;
-
-struct CIS_AREA {
+struct keucr_media_area {
 	BYTE Sector;	/* Sector(512byte) Number on Block */
 	WORD PhyBlock;	/* Physical Block Number on Zone 0 */
 };
@@ -215,9 +199,9 @@ extern WORD	ReadBlock;
 extern WORD	WriteBlock;
 extern DWORD	MediaChange;
 
-extern struct SSFDCTYPE  Ssfdc;
-extern struct ADDRESS    Media;
-extern struct CIS_AREA   CisArea;
+extern struct keucr_media_info    Ssfdc;
+extern struct keucr_media_address Media;
+extern struct keucr_media_area    CisArea;
 
 /*
  * SMILMain.c
diff --git a/drivers/staging/keucr/smilsub.c b/drivers/staging/keucr/smilsub.c
index b10e8c2..815be93 100644
--- a/drivers/staging/keucr/smilsub.c
+++ b/drivers/staging/keucr/smilsub.c
@@ -33,9 +33,9 @@ void   _Set_D_ECCdata(BYTE, BYTE *);
 void   _Calc_D_ECCdata(BYTE *);
 
 
-struct SSFDCTYPE                Ssfdc;
-struct ADDRESS                  Media;
-struct CIS_AREA                 CisArea;
+struct keucr_media_info         Ssfdc;
+struct keucr_media_address      Media;
+struct keucr_media_area         CisArea;
 
 static BYTE                            EccBuf[6];
 extern PBYTE                    SMHostAddr;
diff --git a/drivers/staging/keucr/usb.c b/drivers/staging/keucr/usb.c
index 0608a5c..f18b1c2 100644
--- a/drivers/staging/keucr/usb.c
+++ b/drivers/staging/keucr/usb.c
@@ -65,7 +65,7 @@ static int eucr_resume(struct usb_interface *iface)
 
 	us->Power_IsResum = true;
 
-	us->SM_Status = *(PSM_STATUS)&tmp;
+	us->SM_Status = *(struct keucr_sm_status *)&tmp;
 
 	return 0;
 }
@@ -87,7 +87,7 @@ static int eucr_reset_resume(struct usb_interface *iface)
 
 	us->Power_IsResum = true;
 
-	us->SM_Status = *(PSM_STATUS)&tmp;
+	us->SM_Status = *(struct keucr_sm_status *)&tmp;
 
 	return 0;
 }
diff --git a/drivers/staging/keucr/usb.h b/drivers/staging/keucr/usb.h
index 2dc75b0..c724cf7 100644
--- a/drivers/staging/keucr/usb.h
+++ b/drivers/staging/keucr/usb.h
@@ -51,7 +51,7 @@ struct us_unusual_dev {
 #define FDIR_WRITE        0
 #define FDIR_READ         1
 
-typedef struct _SD_STATUS {
+struct keucr_sd_status {
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
+struct keucr_ms_status {
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
+struct keucr_sm_status {
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
+	struct keucr_sd_status   SD_Status;
+	struct keucr_ms_status   MS_Status;
+	struct keucr_sm_status   SM_Status;
 
 	/* ----- SD Control Data ---------------- */
 	/* SD_REGISTER SD_Regs; */
-- 
1.7.10.4

