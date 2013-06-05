Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab3FEJDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 05:03:23 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:33566 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753443Ab3FEJBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 05:01:08 -0400
From: Johannes Schilling <of82ecuq@cip.cs.fau.de>
To: linux-kernel@vger.kernel.org
Cc: linux-kernel@i4.cs.fau.de, Al Cho <acho@novell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>,
        Kurt Kanzenbach <shifty91@gmail.com>, devel@driverdev.osuosl.org,
        Johannes Schilling <of82ecuq@cip.cs.fau.de>,
        Laura Lawniczak <laura.lawniczak@googlemail.com>
Subject: [PATCH 5/6] keucr: fix some alignment- and whitespace-problems
Date: Wed,  5 Jun 2013 10:50:05 +0200
Message-Id: <1370422206-14961-6-git-send-email-of82ecuq@cip.cs.fau.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370422206-14961-1-git-send-email-of82ecuq@cip.cs.fau.de>
References: <1370422206-14961-1-git-send-email-of82ecuq@cip.cs.fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

resolves checkpatch errors and warnings regarding whitespace around
operators, line lengths and indentation.

Signed-off-by: Laura Lawniczak <laura.lawniczak@googlemail.com>
Signed-off-by: Johannes Schilling <of82ecuq@cip.cs.fau.de>
---
 drivers/staging/keucr/scsiglue.c |    5 +-
 drivers/staging/keucr/smilmain.c |  122 ++++++++++++++++++--------------------
 drivers/staging/keucr/usb.c      |    4 +-
 drivers/staging/keucr/usb.h      |   12 ++--
 4 files changed, 69 insertions(+), 74 deletions(-)

diff --git a/drivers/staging/keucr/scsiglue.c b/drivers/staging/keucr/scsiglue.c
index 7f0cf1a..1636066 100644
--- a/drivers/staging/keucr/scsiglue.c
+++ b/drivers/staging/keucr/scsiglue.c
@@ -322,8 +322,9 @@ static ssize_t store_max_sectors(struct device *dev,
 
 static DEVICE_ATTR(max_sectors, S_IRUGO | S_IWUSR, show_max_sectors,
 							store_max_sectors);
-static struct device_attribute *sysfs_device_attr_list[] =
-					{&dev_attr_max_sectors, NULL, };
+static struct device_attribute *sysfs_device_attr_list[] = {
+	&dev_attr_max_sectors, NULL,
+};
 
 /* this defines our host template, with which we'll allocate hosts */
 
diff --git a/drivers/staging/keucr/smilmain.c b/drivers/staging/keucr/smilmain.c
index dd73f88..2786808 100644
--- a/drivers/staging/keucr/smilmain.c
+++ b/drivers/staging/keucr/smilmain.c
@@ -302,7 +302,7 @@ int Media_D_ReadOneSect(struct us_data *us, WORD count, BYTE *buf)
 		return ERROR;
 
 #ifdef RDERR_REASSIGN
-	if (Ssfdc.Attribute &MWP) {
+	if (Ssfdc.Attribute & MWP) {
 		if (ErrCode == ERR_CorReadErr)
 			return SMSUCCESS;
 		return ERROR;
@@ -675,90 +675,84 @@ int Make_D_LogTable(struct us_data *us)
 
 	Media.Sector = 0;
 
-	{
-		/* pr_info("Make_D_LogTable --- MediaZone = 0x%x\n",
-							Media.Zone); */
-		for (Media.LogBlock = 0; Media.LogBlock < Ssfdc.MaxLogBlocks;
-							Media.LogBlock++)
-			Log2Phy[Media.Zone][Media.LogBlock] = NO_ASSIGN;
-
-		for (Media.PhyBlock = 0; Media.PhyBlock < (MAX_BLOCKNUM / 8);
-							Media.PhyBlock++)
-			Assign[Media.Zone][Media.PhyBlock] = 0x00;
-
-		for (Media.PhyBlock = 0; Media.PhyBlock < Ssfdc.MaxBlocks;
-							Media.PhyBlock++) {
-			if ((!Media.Zone) &&
-					(Media.PhyBlock <= CisArea.PhyBlock)) {
-				Set_D_Bit(Assign[Media.Zone], Media.PhyBlock);
-				continue;
-			}
+	/* pr_info("Make_D_LogTable --- MediaZone = 0x%x\n",
+						Media.Zone); */
+	for (Media.LogBlock = 0; Media.LogBlock < Ssfdc.MaxLogBlocks;
+						Media.LogBlock++)
+		Log2Phy[Media.Zone][Media.LogBlock] = NO_ASSIGN;
 
-			if (Ssfdc_D_ReadRedtData(us, Redundant)) {
-				Ssfdc_D_Reset(us);
-				return ERROR;
-			}
-
-			if (!Check_D_DataBlank(Redundant))
-				continue;
+	for (Media.PhyBlock = 0; Media.PhyBlock < (MAX_BLOCKNUM / 8);
+						Media.PhyBlock++)
+		Assign[Media.Zone][Media.PhyBlock] = 0x00;
 
+	for (Media.PhyBlock = 0; Media.PhyBlock < Ssfdc.MaxBlocks;
+						Media.PhyBlock++) {
+		if ((!Media.Zone) && (Media.PhyBlock <= CisArea.PhyBlock)) {
 			Set_D_Bit(Assign[Media.Zone], Media.PhyBlock);
+			continue;
+		}
 
-			if (Check_D_FailBlock(Redundant))
-				continue;
+		if (Ssfdc_D_ReadRedtData(us, Redundant)) {
+			Ssfdc_D_Reset(us);
+			return ERROR;
+		}
+
+		if (!Check_D_DataBlank(Redundant))
+			continue;
 
-			if (Load_D_LogBlockAddr(Redundant))
-				continue;
+		Set_D_Bit(Assign[Media.Zone], Media.PhyBlock);
 
-			if (Media.LogBlock >= Ssfdc.MaxLogBlocks)
-				continue;
+		if (Check_D_FailBlock(Redundant))
+			continue;
 
-			if (Log2Phy[Media.Zone][Media.LogBlock] == NO_ASSIGN) {
-				Log2Phy[Media.Zone][Media.LogBlock] =
-								Media.PhyBlock;
-				continue;
-			}
+		if (Load_D_LogBlockAddr(Redundant))
+			continue;
 
-			phyblock     = Media.PhyBlock;
-			logblock     = Media.LogBlock;
-			Media.Sector = (BYTE)(Ssfdc.MaxSectors - 1);
+		if (Media.LogBlock >= Ssfdc.MaxLogBlocks)
+			continue;
+
+		if (Log2Phy[Media.Zone][Media.LogBlock] == NO_ASSIGN) {
+			Log2Phy[Media.Zone][Media.LogBlock] = Media.PhyBlock;
+			continue;
+		}
+
+		phyblock     = Media.PhyBlock;
+		logblock     = Media.LogBlock;
+		Media.Sector = (BYTE)(Ssfdc.MaxSectors - 1);
+
+		if (Ssfdc_D_ReadRedtData(us, Redundant)) {
+			Ssfdc_D_Reset(us);
+			return ERROR;
+		}
+
+		if (!Load_D_LogBlockAddr(Redundant) &&
+				(Media.LogBlock == logblock)) {
+			Media.PhyBlock = Log2Phy[Media.Zone][logblock];
 
 			if (Ssfdc_D_ReadRedtData(us, Redundant)) {
 				Ssfdc_D_Reset(us);
 				return ERROR;
 			}
 
+			Media.PhyBlock = phyblock;
+
 			if (!Load_D_LogBlockAddr(Redundant)) {
-				if (Media.LogBlock == logblock) {
+				if (Media.LogBlock != logblock) {
 					Media.PhyBlock =
 						Log2Phy[Media.Zone][logblock];
-
-					if (Ssfdc_D_ReadRedtData(us,
-								Redundant)) {
-						Ssfdc_D_Reset(us);
-						return ERROR;
-					}
-
-					Media.PhyBlock = phyblock;
-
-					if (!Load_D_LogBlockAddr(Redundant)) {
-						if (Media.LogBlock != logblock) {
-							Media.PhyBlock = Log2Phy[Media.Zone][logblock];
-							Log2Phy[Media.Zone][logblock] = phyblock;
-						}
-					} else {
-						Media.PhyBlock = Log2Phy[Media.Zone][logblock];
-						Log2Phy[Media.Zone][logblock] = phyblock;
-					}
+					Log2Phy[Media.Zone][logblock] =
+								phyblock;
 				}
+			} else {
+				Media.PhyBlock = Log2Phy[Media.Zone][logblock];
+				Log2Phy[Media.Zone][logblock] = phyblock;
 			}
+		}
 
-			Media.Sector = 0;
-			Media.PhyBlock = phyblock;
-
-		} /* End for (Media.PhyBlock<Ssfdc.MaxBlocks) */
+		Media.Sector = 0;
+		Media.PhyBlock = phyblock;
 
-		AssignStart[Media.Zone] = 0;
+	AssignStart[Media.Zone] = 0;
 
 	} /* End for (Media.Zone<MAX_ZONENUM) */
 
diff --git a/drivers/staging/keucr/usb.c b/drivers/staging/keucr/usb.c
index 96d8868..911271e 100644
--- a/drivers/staging/keucr/usb.c
+++ b/drivers/staging/keucr/usb.c
@@ -150,7 +150,7 @@ void fill_inquiry_response(struct us_data *us, unsigned char *data,
 	usb_stor_set_xfer_buf(us, data, data_len, us->srb, TO_XFER_BUF);
 }
 
-static int usb_stor_control_thread(void * __us)
+static int usb_stor_control_thread(void *__us)
 {
 	struct us_data *us = (struct us_data *)__us;
 	struct Scsi_Host *host = us_to_host(us);
@@ -493,7 +493,7 @@ static void release_everything(struct us_data *us)
 	scsi_host_put(us_to_host(us));
 }
 
-static int usb_stor_scan_thread(void * __us)
+static int usb_stor_scan_thread(void *__us)
 {
 	struct us_data *us = (struct us_data *)__us;
 
diff --git a/drivers/staging/keucr/usb.h b/drivers/staging/keucr/usb.h
index e91475e..95c507a 100644
--- a/drivers/staging/keucr/usb.h
+++ b/drivers/staging/keucr/usb.h
@@ -19,8 +19,8 @@ struct scsi_cmnd;
  */
 
 struct us_unusual_dev {
-	const char* vendorName;
-	const char* productName;
+	const char *vendorName;
+	const char *productName;
 	__u8  useProtocol;
 	__u8  useTransport;
 	int (*initFunction)(struct us_data *);
@@ -108,9 +108,9 @@ struct _SM_STATUS {
 #define US_IOBUF_SIZE		64	/* Size of the DMA-mapped I/O buffer */
 #define US_SENSE_SIZE		18	/* Size of the autosense data buffer */
 
-typedef int (*trans_cmnd)(struct scsi_cmnd *, struct us_data*);
-typedef int (*trans_reset)(struct us_data*);
-typedef void (*proto_cmnd)(struct scsi_cmnd*, struct us_data*);
+typedef int (*trans_cmnd)(struct scsi_cmnd *, struct us_data *);
+typedef int (*trans_reset)(struct us_data *);
+typedef void (*proto_cmnd)(struct scsi_cmnd *, struct us_data *);
 typedef void (*extra_data_destructor)(void *);	/* extra data destructor */
 typedef void (*pm_hook)(struct us_data *, int);	/* power management hook */
 
@@ -215,7 +215,7 @@ struct us_data {
 	int		SrbStatus;
 
 	/* ------Power Managerment --------------- */
-	BOOLEAN         Power_IsResum;	
+	BOOLEAN         Power_IsResum;
 };
 
 /* Convert between us_data and the corresponding Scsi_Host */
-- 
1.7.10.4

