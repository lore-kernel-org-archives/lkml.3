Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbbA2BPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:15:18 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:59737 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbbA2BPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:15:12 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Marek Belisko <marek.belisko@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Joe Perches <joe@perches.com>,
        Tapasweni Pathak <tapaswenipathak@gmail.com>,
        Gulsah Kose <gulsah.1004@gmail.com>,
        Tina Johnson <tinajohnson.1234@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: ft1000: ft1000-usb: ft1000_download: Removed variables that is never used
Date: Wed, 28 Jan 2015 23:44:34 +0100
Message-Id: <1422485074-10640-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |   45 +++++++++-----------
 1 file changed, 19 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index e8126325..06b21d9 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -113,21 +113,20 @@ static int check_usb_db(struct ft1000_usb *ft1000dev)
 {
 	int loopcnt;
 	u16 temp;
-	int status;
 
 	loopcnt = 0;
 
 	while (loopcnt < 10) {
-		status = ft1000_read_register(ft1000dev, &temp,
+		ft1000_read_register(ft1000dev, &temp,
 					      FT1000_REG_DOORBELL);
 		pr_debug("read FT1000_REG_DOORBELL value is %x\n", temp);
 		if (temp & 0x0080) {
 			pr_debug("Got checkusb doorbell\n");
-			status = ft1000_write_register(ft1000dev, 0x0080,
+			ft1000_write_register(ft1000dev, 0x0080,
 						       FT1000_REG_DOORBELL);
-			status = ft1000_write_register(ft1000dev, 0x0100,
+			ft1000_write_register(ft1000dev, 0x0100,
 						       FT1000_REG_DOORBELL);
-			status = ft1000_write_register(ft1000dev,  0x8000,
+			ft1000_write_register(ft1000dev,  0x8000,
 						       FT1000_REG_DOORBELL);
 			break;
 		}
@@ -138,7 +137,7 @@ static int check_usb_db(struct ft1000_usb *ft1000dev)
 
 	loopcnt = 0;
 	while (loopcnt < 20) {
-		status = ft1000_read_register(ft1000dev, &temp,
+		ft1000_read_register(ft1000dev, &temp,
 					      FT1000_REG_DOORBELL);
 		pr_debug("Doorbell = 0x%x\n", temp);
 		if (temp & 0x8000) {
@@ -202,18 +201,17 @@ static void put_handshake(struct ft1000_usb *ft1000dev, u16 handshake_value)
 {
 	u32 tempx;
 	u16 tempword;
-	int status;
 
 	tempx = (u32)handshake_value;
 	tempx = ntohl(tempx);
 
 	tempword = (u16)(tempx & 0xffff);
-	status = ft1000_write_dpram16(ft1000dev, DWNLD_MAG1_HANDSHAKE_LOC,
+	ft1000_write_dpram16(ft1000dev, DWNLD_MAG1_HANDSHAKE_LOC,
 				      tempword, 0);
 	tempword = (u16)(tempx >> 16);
-	status = ft1000_write_dpram16(ft1000dev, DWNLD_MAG1_HANDSHAKE_LOC,
+	ft1000_write_dpram16(ft1000dev, DWNLD_MAG1_HANDSHAKE_LOC,
 				      tempword, 1);
-	status = ft1000_write_register(ft1000dev, FT1000_DB_DNLD_TX,
+	ft1000_write_register(ft1000dev, FT1000_DB_DNLD_TX,
 				       FT1000_REG_DOORBELL);
 }
 
@@ -222,20 +220,19 @@ static u16 get_handshake_usb(struct ft1000_usb *ft1000dev, u16 expected_value)
 	u16 handshake;
 	int loopcnt;
 	u16 temp;
-	int status = 0;
 
 	loopcnt = 0;
 	handshake = 0;
 
 	while (loopcnt < 100) {
 		if (ft1000dev->usbboot == 2) {
-			status = ft1000_read_dpram32(ft1000dev, 0,
+			ft1000_read_dpram32(ft1000dev, 0,
 						     (u8 *)&(ft1000dev->tempbuf[0]), 64);
 			for (temp = 0; temp < 16; temp++) {
 				pr_debug("tempbuf %d = 0x%x\n",
 					 temp, ft1000dev->tempbuf[temp]);
 			}
-			status = ft1000_read_dpram16(ft1000dev,
+			ft1000_read_dpram16(ft1000dev,
 						     DWNLD_MAG1_HANDSHAKE_LOC,
 						     (u8 *)&handshake, 1);
 			pr_debug("handshake from read_dpram16 = 0x%x\n",
@@ -248,7 +245,7 @@ static u16 get_handshake_usb(struct ft1000_usb *ft1000dev, u16 expected_value)
 					ft1000dev->tempbuf[6];
 			}
 		} else {
-			status = ft1000_read_dpram16(ft1000dev,
+			ft1000_read_dpram16(ft1000dev,
 						     DWNLD_MAG1_HANDSHAKE_LOC,
 						     (u8 *)&handshake, 1);
 		}
@@ -275,17 +272,16 @@ static void put_handshake_usb(struct ft1000_usb *ft1000dev, u16 handshake_value)
 static u16 get_request_type(struct ft1000_usb *ft1000dev)
 {
 	u16 request_type;
-	int status;
 	u16 tempword;
 	u32 tempx;
 
 	if (ft1000dev->bootmode == 1) {
-		status = fix_ft1000_read_dpram32(ft1000dev,
+		fix_ft1000_read_dpram32(ft1000dev,
 						 DWNLD_MAG1_TYPE_LOC, (u8 *)&tempx);
 		tempx = ntohl(tempx);
 	} else {
 		tempx = 0;
-		status = ft1000_read_dpram16(ft1000dev,
+		ft1000_read_dpram16(ft1000dev,
 					     DWNLD_MAG1_TYPE_LOC, (u8 *)&tempword, 1);
 		tempx |= (tempword << 16);
 		tempx = ntohl(tempx);
@@ -298,12 +294,11 @@ static u16 get_request_type(struct ft1000_usb *ft1000dev)
 static u16 get_request_type_usb(struct ft1000_usb *ft1000dev)
 {
 	u16 request_type;
-	int status;
 	u16 tempword;
 	u32 tempx;
 
 	if (ft1000dev->bootmode == 1) {
-		status = fix_ft1000_read_dpram32(ft1000dev,
+		fix_ft1000_read_dpram32(ft1000dev,
 						 DWNLD_MAG1_TYPE_LOC, (u8 *)&tempx);
 		tempx = ntohl(tempx);
 	} else {
@@ -312,7 +307,7 @@ static u16 get_request_type_usb(struct ft1000_usb *ft1000dev)
 			tempword = ft1000dev->tempbuf[3];
 		} else {
 			tempx = 0;
-			status = ft1000_read_dpram16(ft1000dev,
+			ft1000_read_dpram16(ft1000dev,
 						     DWNLD_MAG1_TYPE_LOC,
 						     (u8 *)&tempword, 1);
 		}
@@ -328,17 +323,16 @@ static long get_request_value(struct ft1000_usb *ft1000dev)
 {
 	u32 value;
 	u16 tempword;
-	int status;
 
 	if (ft1000dev->bootmode == 1) {
-		status = fix_ft1000_read_dpram32(ft1000dev,
+		fix_ft1000_read_dpram32(ft1000dev,
 						 DWNLD_MAG1_SIZE_LOC, (u8 *)&value);
 		value = ntohl(value);
 	} else	{
-		status = ft1000_read_dpram16(ft1000dev,
+		ft1000_read_dpram16(ft1000dev,
 					     DWNLD_MAG1_SIZE_LOC, (u8 *)&tempword, 0);
 		value = tempword;
-		status = ft1000_read_dpram16(ft1000dev,
+		ft1000_read_dpram16(ft1000dev,
 					     DWNLD_MAG1_SIZE_LOC, (u8 *)&tempword, 1);
 		value |= (tempword << 16);
 		value = ntohl(value);
@@ -352,10 +346,9 @@ static long get_request_value(struct ft1000_usb *ft1000dev)
 static void put_request_value(struct ft1000_usb *ft1000dev, long lvalue)
 {
 	u32    tempx;
-	int    status;
 
 	tempx = ntohl(lvalue);
-	status = fix_ft1000_write_dpram32(ft1000dev, DWNLD_MAG1_SIZE_LOC,
+	fix_ft1000_write_dpram32(ft1000dev, DWNLD_MAG1_SIZE_LOC,
 					  (u8 *)&tempx);
 }
 
-- 
1.7.10.4

