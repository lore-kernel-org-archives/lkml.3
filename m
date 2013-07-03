Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965119Ab3GCTEd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:04:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20493 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965035Ab3GCTAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:31 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=JdFq6cdtCNoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=PZaG5pIGVV4A:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=fBeKd2HRWbP4T1pgm1MA:9 a=MSl-tDqOz04A:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=JBq7bYU5GVcnqM0l:21 a=h-9ivHNQ42tq8kII:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184059.080058264@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [085/141] USB: mos7720: fix hardware flow control
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0085-USB-mos7720-fix-hardware-flow-control.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

[ Upstream commit a26f009a070e840fadacb91013b2391ba7ab6cc2 ]

The register access to enable hardware flow control depends on the
device port number and not the port minor number.

Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/serial/mos7720.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index 98fd1eb..b691404 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -1695,7 +1695,7 @@ static void change_port_settings(struct tty_struct *tty,
 		mos7720_port->shadowMCR |= (UART_MCR_XONANY);
 		/* To set hardware flow control to the specified *
 		 * serial port, in SP1/2_CONTROL_REG             */
-		if (port->number)
+		if (port_number)
 			write_mos_reg(serial, dummy, SP_CONTROL_REG, 0x01);
 		else
 			write_mos_reg(serial, dummy, SP_CONTROL_REG, 0x02);
-- 
1.7.10.4


