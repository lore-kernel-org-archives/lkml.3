Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952Ab3FKUJ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:09:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42017 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756773Ab3FKUEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:04:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 73/79] USB: ftdi_sio: clean up get_modem_status
Date: Tue, 11 Jun 2013 13:03:39 -0700
Message-Id: <20130611195325.627582765@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195312.352656079@linuxfoundation.org>
References: <20130611195312.352656079@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit c4133648bbce9e6b425a74cc890c8e4df51acaa9 upstream.

Use usb-serial port rather than tty as argument to get_modem_status.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -932,7 +932,7 @@ static int  ftdi_ioctl(struct tty_struct
 			unsigned int cmd, unsigned long arg);
 static void ftdi_break_ctl(struct tty_struct *tty, int break_state);
 static int ftdi_chars_in_buffer(struct tty_struct *tty);
-static int ftdi_get_modem_status(struct tty_struct *tty,
+static int ftdi_get_modem_status(struct usb_serial_port *port,
 						unsigned char status[2]);
 
 static unsigned short int ftdi_232am_baud_base_to_divisor(int baud, int base);
@@ -2104,7 +2104,7 @@ static int ftdi_chars_in_buffer(struct t
 		goto out;
 
 	/* Check if hardware buffer is empty. */
-	ret = ftdi_get_modem_status(tty, buf);
+	ret = ftdi_get_modem_status(port, buf);
 	if (ret == 2) {
 		if (!(buf[1] & FTDI_RS_TEMT))
 			chars = 1;
@@ -2304,10 +2304,9 @@ no_c_cflag_changes:
  * Returns the number of status bytes retrieved (device dependant), or
  * negative error code.
  */
-static int ftdi_get_modem_status(struct tty_struct *tty,
+static int ftdi_get_modem_status(struct usb_serial_port *port,
 						unsigned char status[2])
 {
-	struct usb_serial_port *port = tty->driver_data;
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
 	unsigned char *buf;
 	int len;
@@ -2372,7 +2371,7 @@ static int ftdi_tiocmget(struct tty_stru
 	unsigned char buf[2];
 	int ret;
 
-	ret = ftdi_get_modem_status(tty, buf);
+	ret = ftdi_get_modem_status(port, buf);
 	if (ret < 0)
 		return ret;
 


