Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489Ab3HBLiP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 07:38:15 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:43120 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab3HBLiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 07:38:13 -0400
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: gregkh@linuxfoundation.org
Cc: pavel@ucw.cz, harsh1kumar@gmail.com, ikerpedrosam@gmail.com,
        justinmattock@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: winbond: wb35reg: fixed some line over 80 characters
Date: Fri,  2 Aug 2013 13:37:56 +0200
Message-Id: <1375443476-4519-1-git-send-email-ikerpedrosam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed some coding style issues

Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>
---
 drivers/staging/winbond/wb35reg.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/winbond/wb35reg.c b/drivers/staging/winbond/wb35reg.c
index 9be1b3b..35d3beb 100644
--- a/drivers/staging/winbond/wb35reg.c
+++ b/drivers/staging/winbond/wb35reg.c
@@ -14,7 +14,8 @@ extern void phy_calibration_winbond(struct hw_data *phw_data, u32 frequency);
  * Flag : AUTO_INCREMENT - RegisterNo will auto increment 4
  *	  NO_INCREMENT - Function will write data into the same register
  */
-unsigned char Wb35Reg_BurstWrite(struct hw_data *pHwData, u16 RegisterNo, u32 *pRegisterData, u8 NumberOfData, u8 Flag)
+unsigned char Wb35Reg_BurstWrite(struct hw_data *pHwData, u16 RegisterNo,
+				 u32 *pRegisterData, u8 NumberOfData, u8 Flag)
 {
 	struct wb35_reg		*reg = &pHwData->reg;
 	struct urb		*urb = NULL;
@@ -72,7 +73,7 @@ unsigned char Wb35Reg_BurstWrite(struct hw_data *pHwData, u16 RegisterNo, u32 *p
 	return true;
 }
 
-void Wb35Reg_Update(struct hw_data *pHwData,  u16 RegisterNo,  u32 RegisterValue)
+void Wb35Reg_Update(struct hw_data *pHwData, u16 RegisterNo, u32 RegisterValue)
 {
 	struct wb35_reg *reg = &pHwData->reg;
 	switch (RegisterNo) {
@@ -118,7 +119,8 @@ void Wb35Reg_Update(struct hw_data *pHwData,  u16 RegisterNo,  u32 RegisterValue
  * true  : read command process successfully
  * false : register not support
  */
-unsigned char Wb35Reg_WriteSync(struct hw_data *pHwData, u16 RegisterNo, u32 RegisterValue)
+unsigned char Wb35Reg_WriteSync(struct hw_data *pHwData, u16 RegisterNo,
+				u32 RegisterValue)
 {
 	struct wb35_reg *reg = &pHwData->reg;
 	int ret = -1;
@@ -139,9 +141,10 @@ unsigned char Wb35Reg_WriteSync(struct hw_data *pHwData, u16 RegisterNo, u32 Reg
 	/* Sync IoCallDriver */
 	reg->EP0vm_state = VM_RUNNING;
 	ret = usb_control_msg(pHwData->udev,
-			       usb_sndctrlpipe(pHwData->udev, 0),
-			       0x03, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
-			       0x0, RegisterNo, &RegisterValue, 4, HZ * 100);
+			      usb_sndctrlpipe(pHwData->udev, 0),
+			      0x03,
+			      USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
+			      0x0, RegisterNo, &RegisterValue, 4, HZ * 100);
 	reg->EP0vm_state = VM_STOP;
 	reg->SyncIoPause = 0;
 
@@ -159,7 +162,8 @@ unsigned char Wb35Reg_WriteSync(struct hw_data *pHwData, u16 RegisterNo, u32 Reg
  * true  : read command process successfully
  * false : register not support
  */
-unsigned char Wb35Reg_Write(struct hw_data *pHwData, u16 RegisterNo, u32 RegisterValue)
+unsigned char Wb35Reg_Write(struct hw_data *pHwData, u16 RegisterNo,
+			    u32 RegisterValue)
 {
 	struct wb35_reg		*reg = &pHwData->reg;
 	struct usb_ctrlrequest	*dr;
@@ -286,7 +290,8 @@ unsigned char Wb35Reg_WriteWithCallbackValue(struct hw_data *pHwData,
  * pRegisterValue : It must be a resident buffer due to
  *		    asynchronous read register.
  */
-unsigned char Wb35Reg_ReadSync(struct hw_data *pHwData, u16 RegisterNo, u32 *pRegisterValue)
+unsigned char Wb35Reg_ReadSync(struct hw_data *pHwData, u16 RegisterNo,
+			       u32 *pRegisterValue)
 {
 	struct wb35_reg *reg = &pHwData->reg;
 	u32		*pltmp = pRegisterValue;
@@ -305,9 +310,10 @@ unsigned char Wb35Reg_ReadSync(struct hw_data *pHwData, u16 RegisterNo, u32 *pRe
 
 	reg->EP0vm_state = VM_RUNNING;
 	ret = usb_control_msg(pHwData->udev,
-			       usb_rcvctrlpipe(pHwData->udev, 0),
-			       0x01, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
-			       0x0, RegisterNo, pltmp, 4, HZ * 100);
+			      usb_rcvctrlpipe(pHwData->udev, 0),
+			      0x01,
+			      USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
+			      0x0, RegisterNo, pltmp, 4, HZ * 100);
 
 	*pRegisterValue = cpu_to_le32(*pltmp);
 
@@ -332,7 +338,8 @@ unsigned char Wb35Reg_ReadSync(struct hw_data *pHwData, u16 RegisterNo, u32 *pRe
  * pRegisterValue : It must be a resident buffer due to
  *		    asynchronous read register.
  */
-unsigned char Wb35Reg_Read(struct hw_data *pHwData, u16 RegisterNo, u32 *pRegisterValue)
+unsigned char Wb35Reg_Read(struct hw_data *pHwData, u16 RegisterNo,
+			   u32 *pRegisterValue)
 {
 	struct wb35_reg		*reg = &pHwData->reg;
 	struct usb_ctrlrequest	*dr;
-- 
1.8.1.2

