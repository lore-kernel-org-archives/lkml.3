Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbbAMRmu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 12:42:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36370 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbbAMRms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 12:42:48 -0500
From: Colin King <colin.king@canonical.com>
To: Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/usb/serial/mos7840.c: remove unused code
Date: Tue, 13 Jan 2015 17:41:45 +0000
Message-Id: <1421170905-13233-1-git-send-email-colin.king@canonical.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is old, unused code that is #defined out by the
use of NOTMOS7840 - this is not defined anywhere.  If
NOTMOS7840 is defined then the code will break on null
pointer dereferences on mos7840_port.  So the code is
currently unused, and broken anyway, so why not just
remove it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/usb/serial/mos7840.c | 29 -----------------------------
 1 file changed, 29 deletions(-)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 220b4be..ba718ea 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -1309,35 +1309,6 @@ static int mos7840_write(struct tty_struct *tty, struct usb_serial_port *port,
 	const unsigned char *current_position = data;
 	unsigned char *data1;
 
-#ifdef NOTMOS7840
-	Data = 0x00;
-	status = mos7840_get_uart_reg(port, LINE_CONTROL_REGISTER, &Data);
-	mos7840_port->shadowLCR = Data;
-	dev_dbg(&port->dev, "%s: LINE_CONTROL_REGISTER is %x\n", __func__, Data);
-	dev_dbg(&port->dev, "%s: mos7840_port->shadowLCR is %x\n", __func__, mos7840_port->shadowLCR);
-
-	/* Data = 0x03; */
-	/* status = mos7840_set_uart_reg(port,LINE_CONTROL_REGISTER,Data); */
-	/* mos7840_port->shadowLCR=Data;//Need to add later */
-
-	Data |= SERIAL_LCR_DLAB;	/* data latch enable in LCR 0x80 */
-	status = mos7840_set_uart_reg(port, LINE_CONTROL_REGISTER, Data);
-
-	/* Data = 0x0c; */
-	/* status = mos7840_set_uart_reg(port,DIVISOR_LATCH_LSB,Data); */
-	Data = 0x00;
-	status = mos7840_get_uart_reg(port, DIVISOR_LATCH_LSB, &Data);
-	dev_dbg(&port->dev, "%s: DLL value is %x\n", __func__, Data);
-
-	Data = 0x0;
-	status = mos7840_get_uart_reg(port, DIVISOR_LATCH_MSB, &Data);
-	dev_dbg(&port->dev, "%s: DLM value is %x\n", __func__, Data);
-
-	Data = Data & ~SERIAL_LCR_DLAB;
-	dev_dbg(&port->dev, "%s: mos7840_port->shadowLCR is %x\n", __func__, mos7840_port->shadowLCR);
-	status = mos7840_set_uart_reg(port, LINE_CONTROL_REGISTER, Data);
-#endif
-
 	if (mos7840_port_paranoia_check(port, __func__))
 		return -1;
 
-- 
2.1.4

