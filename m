Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab3FNO4z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 10:56:55 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:43216 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750933Ab3FNO4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 10:56:54 -0400
From: Bernd Bassimir <bassimir.kernel@gmx.de>
To: devel@linuxdriverproject.org
Cc: gregkh@linuxfoundation.org, yamanetoshi@gmail.com, devendra.aaru@gmail.com,
        jslaby@suse.cz, nico.doerr@hawo.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        linux-kernel@i4.informatik.uni-erlangen.de,
        Bernd Bassimir <bassimir.kernel@gmx.de>
Subject: [PATCH 2/2] serqt_usb2: lines over 80 characters fixed
Date: Fri, 14 Jun 2013 16:55:58 +0200
Message-Id: <1371221758-31589-2-git-send-email-bassimir.kernel@gmx.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1371221758-31589-1-git-send-email-bassimir.kernel@gmx.de>
References: <1371221758-31589-1-git-send-email-bassimir.kernel@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed name of one variable, so that all lines are now below 80
characters.

Signed-off-by: Bernd Bassimir <bassimir.kernel@gmx.de>
Signed-off-by: Nico Doerr <nico.doerr@hawo.net>
---
 drivers/staging/serqt_usb2/serqt_usb2.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
index 0c87c6f..39de5e0 100644
--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -513,14 +513,14 @@ static int qt_set_device(struct usb_serial *serial,
 	return result;
 }
 
-static int qt_open_channel(struct usb_serial *serial, __u16 uart_number,
+static int qt_open_channel(struct usb_serial *serial, __u16 uart_num,
 			   struct qt_open_channel_data *pdevice_data)
 {
 	int result;
 
 	result = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
 				 QT_OPEN_CLOSE_CHANNEL,
-				 USBD_TRANSFER_DIRECTION_IN, 1, uart_number,
+				 USBD_TRANSFER_DIRECTION_IN, 1, uart_num,
 				 pdevice_data,
 				 sizeof(struct qt_open_channel_data), 300);
 
@@ -528,13 +528,13 @@ static int qt_open_channel(struct usb_serial *serial, __u16 uart_number,
 
 }
 
-static int qt_close_channel(struct usb_serial *serial, __u16 uart_number)
+static int qt_close_channel(struct usb_serial *serial, __u16 uart_num)
 {
 	int result;
 
 	result = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
 				 QT_OPEN_CLOSE_CHANNEL,
-				 USBD_TRANSFER_DIRECTION_OUT, 0, uart_number,
+				 USBD_TRANSFER_DIRECTION_OUT, 0, uart_num,
 				 NULL, 0, 300);
 
 	return result;
@@ -546,7 +546,7 @@ static int qt_close_channel(struct usb_serial *serial, __u16 uart_number)
 *	issuse a GET_REGISTER vendor-spcific request on the default control pipe
 *	If successful, fills in the  p_value with the register value asked for
 ****************************************************************************/
-static int box_get_register(struct usb_serial *serial, unsigned short uart_number,
+static int box_get_register(struct usb_serial *serial, unsigned short uart_num,
 			  unsigned short register_num, __u8 *p_value)
 {
 	int result;
@@ -557,7 +557,7 @@ static int box_get_register(struct usb_serial *serial, unsigned short uart_numbe
 	result =
 	    usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
 			    QT_GET_SET_REGISTER, 0xC0, register_num,
-			    uart_number, (void *)p_value, sizeof(*p_value), 300);
+			    uart_num, (void *)p_value, sizeof(*p_value), 300);
 
 	return result;
 }
@@ -567,7 +567,7 @@ static int box_get_register(struct usb_serial *serial, unsigned short uart_numbe
 *	issuse a GET_REGISTER vendor-spcific request on the default control pipe
 *	If successful, fills in the  p_value with the register value asked for
 ****************************************************************************/
-static int box_set_register(struct usb_serial *serial, unsigned short uart_number,
+static int box_set_register(struct usb_serial *serial, unsigned short uart_num,
 			  unsigned short register_num, unsigned short value)
 {
 	int result;
@@ -580,12 +580,12 @@ static int box_set_register(struct usb_serial *serial, unsigned short uart_numbe
 /*
 	result = usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
 				 QT_GET_SET_REGISTER, 0xC0, register_num,
-				 uart_number, NULL, 0, 300);
+				 uart_num, NULL, 0, 300);
 */
 
 	result =
 	    usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
-			    QT_GET_SET_REGISTER, 0x40, reg_and_byte, uart_number,
+			    QT_GET_SET_REGISTER, 0x40, reg_and_byte, uart_num,
 			    NULL, 0, 300);
 
 	return result;
@@ -596,13 +596,13 @@ static int box_set_register(struct usb_serial *serial, unsigned short uart_numbe
  * issues a SET_UART vendor-specific request on the default control pipe
  * If successful sets baud rate divisor and LCR value
  */
-static int qt_setuart(struct usb_serial *serial, unsigned short uart_number,
+static int qt_setuart(struct usb_serial *serial, unsigned short uart_num,
 		      unsigned short default_divisor, unsigned char default_lcr)
 {
 	int result;
 	unsigned short uart_num_and_lcr;
 
-	uart_num_and_lcr = (default_lcr << 8) + uart_number;
+	uart_num_and_lcr = (default_lcr << 8) + uart_num;
 
 	result =
 	    usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
-- 
1.7.10.4

