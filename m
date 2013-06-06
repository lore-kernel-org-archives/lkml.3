Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab3FFQLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:11:55 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:47590 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753280Ab3FFQLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:11:40 -0400
From: Johannes Schilling <of82ecuq@cip.cs.fau.de>
To: linux-kernel@vger.kernel.org
Cc: linux-kernel@i4.cs.fau.de, Al Cho <acho@novell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>,
        Kurt Kanzenbach <shifty91@gmail.com>, devel@driverdev.osuosl.org,
        Laura Lawniczak <laura.lawniczak@googlemail.com>,
        Johannes Schilling <of82ecuq@cip.cs.fau.de>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 6/6] keucr: fix some alignment- and whitespace-problems
Date: Thu,  6 Jun 2013 18:10:50 +0200
Message-Id: <1370535050-7167-7-git-send-email-of82ecuq@cip.cs.fau.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370535050-7167-1-git-send-email-of82ecuq@cip.cs.fau.de>
References: <20130605094517.GS28112@mwanda>
 <1370535050-7167-1-git-send-email-of82ecuq@cip.cs.fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

resolves checkpatch errors and warnings regarding whitespace around
operators, line lengths and indentation.

Signed-off-by: Laura Lawniczak <laura.lawniczak@googlemail.com>
Signed-off-by: Johannes Schilling <of82ecuq@cip.cs.fau.de>
---
 drivers/staging/keucr/init.c      |   24 +++++---
 drivers/staging/keucr/scsiglue.c  |    5 +-
 drivers/staging/keucr/smilmain.c  |  122 ++++++++++++++++++-------------------
 drivers/staging/keucr/transport.c |   31 ++++++----
 drivers/staging/keucr/usb.c       |   10 +--
 drivers/staging/keucr/usb.h       |   12 ++--
 6 files changed, 106 insertions(+), 98 deletions(-)

diff --git a/drivers/staging/keucr/init.c b/drivers/staging/keucr/init.c
index 53478e1..f5d41e0 100644
--- a/drivers/staging/keucr/init.c
+++ b/drivers/staging/keucr/init.c
@@ -98,11 +98,16 @@ int ENE_SMInit(struct us_data *us)
 	us->SM_CardID   = buf[2];
 
 	if (us->SM_Status.Insert && us->SM_Status.Ready) {
-		dev_info(&us->pusb_dev->dev, "Insert     = %x\n", us->SM_Status.Insert);
-		dev_info(&us->pusb_dev->dev, "Ready      = %x\n", us->SM_Status.Ready);
-		dev_info(&us->pusb_dev->dev, "WtP        = %x\n", us->SM_Status.WtP);
-		dev_info(&us->pusb_dev->dev, "DeviceID   = %x\n", us->SM_DeviceID);
-		dev_info(&us->pusb_dev->dev, "CardID     = %x\n", us->SM_CardID);
+		dev_info(&us->pusb_dev->dev, "Insert     = %x\n",
+					     us->SM_Status.Insert);
+		dev_info(&us->pusb_dev->dev, "Ready      = %x\n",
+					     us->SM_Status.Ready);
+		dev_info(&us->pusb_dev->dev, "WtP        = %x\n",
+					     us->SM_Status.WtP);
+		dev_info(&us->pusb_dev->dev, "DeviceID   = %x\n",
+					     us->SM_DeviceID);
+		dev_info(&us->pusb_dev->dev, "CardID     = %x\n",
+					     us->SM_CardID);
 		MediaChange = 1;
 		Check_D_MediaFmt(us);
 	} else {
@@ -174,7 +179,8 @@ int ENE_SendScsiCmd(struct us_data *us, BYTE fDir, void *buf, int use_sg)
 	result = usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe,
 					    bcb, US_BULK_CB_WRAP_LEN, NULL);
 	if (result != USB_STOR_XFER_GOOD) {
-		dev_err(&us->pusb_dev->dev, "send cmd to out endpoint fail ---\n");
+		dev_err(&us->pusb_dev->dev,
+				"send cmd to out endpoint fail ---\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -203,14 +209,16 @@ int ENE_SendScsiCmd(struct us_data *us, BYTE fDir, void *buf, int use_sg)
 						US_BULK_CS_WRAP_LEN, &cswlen);
 
 	if (result == USB_STOR_XFER_SHORT && cswlen == 0) {
-		dev_warn(&us->pusb_dev->dev, "Received 0-length CSW; retrying...\n");
+		dev_warn(&us->pusb_dev->dev,
+				"Received 0-length CSW; retrying...\n");
 		result = usb_stor_bulk_transfer_buf(us, us->recv_bulk_pipe,
 					bcs, US_BULK_CS_WRAP_LEN, &cswlen);
 	}
 
 	if (result == USB_STOR_XFER_STALLED) {
 		/* get the status again */
-		dev_warn(&us->pusb_dev->dev, "Attempting to get CSW (2nd try)...\n");
+		dev_warn(&us->pusb_dev->dev,
+				"Attempting to get CSW (2nd try)...\n");
 		result = usb_stor_bulk_transfer_buf(us, us->recv_bulk_pipe,
 						bcs, US_BULK_CS_WRAP_LEN, NULL);
 	}
diff --git a/drivers/staging/keucr/scsiglue.c b/drivers/staging/keucr/scsiglue.c
index 54a89ff..afb00d8 100644
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
 
diff --git a/drivers/staging/keucr/transport.c b/drivers/staging/keucr/transport.c
index b3c25d0..1f9ea58 100644
--- a/drivers/staging/keucr/transport.c
+++ b/drivers/staging/keucr/transport.c
@@ -93,33 +93,38 @@ static void usb_stor_print_cmd(struct us_data *us, struct scsi_cmnd *srb)
 
 	switch (cmd) {
 	case TEST_UNIT_READY:
-		/* dev_dbg(
-			   &us->pusb_dev->dev, "scsi cmd %X --- SCSIOP_TEST_UNIT_READY\n", cmd); */
+		/* dev_dbg(&us->pusb_dev->dev,
+			"scsi cmd %X --- SCSIOP_TEST_UNIT_READY\n", cmd); */
 		break;
 	case INQUIRY:
-		dev_dbg(&us->pusb_dev->dev, "scsi cmd %X --- SCSIOP_INQUIRY\n", cmd);
+		dev_dbg(&us->pusb_dev->dev,
+				"scsi cmd %X --- SCSIOP_INQUIRY\n", cmd);
 		break;
 	case MODE_SENSE:
-		dev_dbg(&us->pusb_dev->dev, "scsi cmd %X --- SCSIOP_MODE_SENSE\n", cmd);
+		dev_dbg(&us->pusb_dev->dev,
+				"scsi cmd %X --- SCSIOP_MODE_SENSE\n", cmd);
 		break;
 	case START_STOP:
-		dev_dbg(&us->pusb_dev->dev, "scsi cmd %X --- SCSIOP_START_STOP\n", cmd);
+		dev_dbg(&us->pusb_dev->dev,
+				"scsi cmd %X --- SCSIOP_START_STOP\n", cmd);
 		break;
 	case READ_CAPACITY:
-		dev_dbg(&us->pusb_dev->dev, "scsi cmd %X --- SCSIOP_READ_CAPACITY\n", cmd);
+		dev_dbg(&us->pusb_dev->dev,
+				"scsi cmd %X --- SCSIOP_READ_CAPACITY\n", cmd);
 		break;
 	case READ_10:
-		/*  dev_dbg(
-			    &us->pusb_dev->dev, "scsi cmd %X --- SCSIOP_READ,bn = %X, blen = %X\n"
-			    cmd, bn, blen); */
+		/*  dev_dbg(&us->pusb_dev->dev,
+			"scsi cmd %X --- SCSIOP_READ,bn = %X, blen = %X\n"
+			cmd, bn, blen); */
 		break;
 	case WRITE_10:
-		/* dev_dbg(
-			   &us->pusb_dev->dev, "scsi cmd %X --- SCSIOP_WRITE,
-			   bn = %X, blen = %X\n" , cmd, bn, blen); */
+		/* dev_dbg(&us->pusb_dev->dev,
+			"scsi cmd %X --- SCSIOP_WRITE, bn = %X, blen = %X\n",
+			cmd, bn, blen); */
 		break;
 	case ALLOW_MEDIUM_REMOVAL:
-		dev_dbg(&us->pusb_dev->dev, "scsi cmd %X --- SCSIOP_ALLOW_MEDIUM_REMOVAL\n", cmd);
+		dev_dbg(&us->pusb_dev->dev,
+			"scsi cmd %X --- SCSIOP_ALLOW_MEDIUM_REMOVAL\n", cmd);
 		break;
 	default:
 		dev_dbg(&us->pusb_dev->dev, "scsi cmd %X --- Other cmd\n", cmd);
diff --git a/drivers/staging/keucr/usb.c b/drivers/staging/keucr/usb.c
index f18b1c2..ddd2e73 100644
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
 
@@ -604,9 +604,9 @@ static int eucr_probe(struct usb_interface *intf,
 	if (!(MiscReg03 & 0x02)) {
 		result = -ENODEV;
 		quiesce_and_remove_host(us);
-		pr_info("keucr: The driver only supports SM/MS card.\
-			To use SD card, \
-			please build driver/usb/storage/ums-eneub6250.ko\n");
+		pr_info("keucr: The driver only supports SM/MS card. "
+			"To use SD card, "
+			"please build driver/usb/storage/ums-eneub6250.ko\n");
 		goto BadDevice;
 	}
 
diff --git a/drivers/staging/keucr/usb.h b/drivers/staging/keucr/usb.h
index c724cf7..d665af1 100644
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
@@ -108,9 +108,9 @@ struct keucr_sm_status {
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

