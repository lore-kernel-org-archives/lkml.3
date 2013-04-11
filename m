Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935365Ab3DKUsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:48:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20734 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935264Ab3DKUsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:48:43 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=q8MOP1LxnboA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=MT8x-vCKrSAA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=MSl-tDqOz04A:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202558.012605174@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 072/171 ] USB: io_ti: fix get_icount for two port adapters
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0072-USB-io_ti-fix-get_icount-for-two-port-adapters.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

[ Upstream commit 5492bf3d5655b4954164f69c02955a7fca267611 ]

Add missing get_icount field to two-port driver.

The two-port driver was not updated when switching to the new icount
interface in commit 0bca1b913aff ("tty: Convert the USB drivers to the
new icount interface").

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/serial/io_ti.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
index ccf297d..a943c06 100644
--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -2766,6 +2766,7 @@ static struct usb_serial_driver edgeport_2port_device = {
 	.set_termios		= edge_set_termios,
 	.tiocmget		= edge_tiocmget,
 	.tiocmset		= edge_tiocmset,
+	.get_icount		= edge_get_icount,
 	.write			= edge_write,
 	.write_room		= edge_write_room,
 	.chars_in_buffer	= edge_chars_in_buffer,
-- 
1.7.10.4


