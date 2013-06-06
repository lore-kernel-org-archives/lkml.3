Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab3FFQN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:13:56 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:47590 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753497Ab3FFQLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:11:38 -0400
From: Johannes Schilling <of82ecuq@cip.cs.fau.de>
To: linux-kernel@vger.kernel.org
Cc: linux-kernel@i4.cs.fau.de, Al Cho <acho@novell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>,
        Kurt Kanzenbach <shifty91@gmail.com>, devel@driverdev.osuosl.org,
        Laura Lawniczak <laura.lawniczak@googlemail.com>,
        Johannes Schilling <of82ecuq@cip.cs.fau.de>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 4/6] keucr: more readable and friendly error messages
Date: Thu,  6 Jun 2013 18:10:48 +0200
Message-Id: <1370535050-7167-5-git-send-email-of82ecuq@cip.cs.fau.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370535050-7167-1-git-send-email-of82ecuq@cip.cs.fau.de>
References: <20130605094517.GS28112@mwanda>
 <1370535050-7167-1-git-send-email-of82ecuq@cip.cs.fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laura Lawniczak <laura.lawniczak@googlemail.com>

Signed-off-by: Laura Lawniczak <laura.lawniczak@googlemail.com>
Signed-off-by: Johannes Schilling <of82ecuq@cip.cs.fau.de>
---
 drivers/staging/keucr/init.c    |   13 +++++++++----
 drivers/staging/keucr/smilsub.c |   21 ++++++++++++++-------
 2 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/keucr/init.c b/drivers/staging/keucr/init.c
index f51180e..08b6c3d 100644
--- a/drivers/staging/keucr/init.c
+++ b/drivers/staging/keucr/init.c
@@ -22,7 +22,7 @@ int ENE_InitMedia(struct us_data *us)
 	dev_info(&us->pusb_dev->dev, "--- Init Media ---\n");
 	result = ene_read_byte(us, REG_CARD_STATUS, &MiscReg03);
 	if (result != USB_STOR_XFER_GOOD) {
-		dev_err(&us->pusb_dev->dev, "Read register fail !!\n");
+		dev_err(&us->pusb_dev->dev, "Failed to read register\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 	dev_info(&us->pusb_dev->dev, "MiscReg03 = %x\n", MiscReg03);
@@ -71,7 +71,9 @@ int ENE_SMInit(struct us_data *us)
 
 	result = ENE_LoadBinCode(us, SM_INIT_PATTERN);
 	if (result != USB_STOR_XFER_GOOD) {
-		dev_info(&us->pusb_dev->dev, "Load SM Init Code Fail !!\n");
+		dev_info(&us->pusb_dev->dev,
+			 "Failed to load SmartMedia init code\n: result= %x\n",
+			 result);
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -84,7 +86,9 @@ int ENE_SMInit(struct us_data *us)
 
 	result = ENE_SendScsiCmd(us, FDIR_READ, &buf, 0);
 	if (result != USB_STOR_XFER_GOOD) {
-		dev_err(&us->pusb_dev->dev, "Execution SM Init Code Fail !! result = %x\n", result);
+		dev_err(&us->pusb_dev->dev,
+			"Failed to load SmartMedia init code: result = %x\n",
+			result);
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -102,7 +106,8 @@ int ENE_SMInit(struct us_data *us)
 		MediaChange = 1;
 		Check_D_MediaFmt(us);
 	} else {
-		dev_err(&us->pusb_dev->dev, "SM Card Not Ready --- %x\n", buf[0]);
+		dev_err(&us->pusb_dev->dev,
+			"SmartMedia Card Not Ready --- %x\n", buf[0]);
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
diff --git a/drivers/staging/keucr/smilsub.c b/drivers/staging/keucr/smilsub.c
index 4900cfb..346c570 100644
--- a/drivers/staging/keucr/smilsub.c
+++ b/drivers/staging/keucr/smilsub.c
@@ -214,7 +214,8 @@ int Ssfdc_D_ReadSect(struct us_data *us, BYTE *buf, BYTE *redundant)
 
 	result = ENE_LoadBinCode(us, SM_RW_PATTERN);
 	if (result != USB_STOR_XFER_GOOD) {
-		dev_err(&us->pusb_dev->dev, "Load SM RW Code Fail !!\n");
+		dev_err(&us->pusb_dev->dev,
+			"Failed to load SmartMedia read/write code\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -266,7 +267,8 @@ int Ssfdc_D_ReadBlock(struct us_data *us, WORD count, BYTE *buf,
 
 	result = ENE_LoadBinCode(us, SM_RW_PATTERN);
 	if (result != USB_STOR_XFER_GOOD) {
-		dev_err(&us->pusb_dev->dev, "Load SM RW Code Fail !!\n");
+		dev_err(&us->pusb_dev->dev,
+			"Failed to load SmartMedia read/write code\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -319,7 +321,8 @@ int Ssfdc_D_CopyBlock(struct us_data *us, WORD count, BYTE *buf,
 
 	result = ENE_LoadBinCode(us, SM_RW_PATTERN);
 	if (result != USB_STOR_XFER_GOOD) {
-		dev_err(&us->pusb_dev->dev, "Load SM RW Code Fail !!\n");
+		dev_err(&us->pusb_dev->dev,
+			"Failed to load SmartMedia read/write code\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -365,7 +368,8 @@ int Ssfdc_D_WriteSectForCopy(struct us_data *us, BYTE *buf, BYTE *redundant)
 
 	result = ENE_LoadBinCode(us, SM_RW_PATTERN);
 	if (result != USB_STOR_XFER_GOOD) {
-		dev_err(&us->pusb_dev->dev, "Load SM RW Code Fail !!\n");
+		dev_err(&us->pusb_dev->dev,
+			"Failed to load SmartMedia read/write code\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -403,7 +407,8 @@ int Ssfdc_D_EraseBlock(struct us_data *us)
 
 	result = ENE_LoadBinCode(us, SM_RW_PATTERN);
 	if (result != USB_STOR_XFER_GOOD) {
-		dev_err(&us->pusb_dev->dev, "Load SM RW Code Fail !!\n");
+		dev_err(&us->pusb_dev->dev,
+			"Failed to load SmartMedia read/write code\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -438,7 +443,8 @@ int Ssfdc_D_ReadRedtData(struct us_data *us, BYTE *redundant)
 
 	result = ENE_LoadBinCode(us, SM_RW_PATTERN);
 	if (result != USB_STOR_XFER_GOOD) {
-		dev_err(&us->pusb_dev->dev, "Load SM RW Code Fail !!\n");
+		dev_err(&us->pusb_dev->dev,
+			"Failed to load SmartMedia read/write code\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -477,7 +483,8 @@ int Ssfdc_D_WriteRedtData(struct us_data *us, BYTE *redundant)
 
 	result = ENE_LoadBinCode(us, SM_RW_PATTERN);
 	if (result != USB_STOR_XFER_GOOD) {
-		dev_err(&us->pusb_dev->dev, "Load SM RW Code Fail !!\n");
+		dev_err(&us->pusb_dev->dev,
+			"Failed to load SmartMedia read/write code\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
-- 
1.7.10.4

