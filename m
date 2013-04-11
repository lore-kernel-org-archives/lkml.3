Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422706Ab3DKVKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:10:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4377 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935660Ab3DKUtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:09 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=ba0SvGPxCoUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=6qwVGEYTz94A:10 a=pGLkceISAAAA:8 a=gu6fZOg2AAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=ayC55rCoAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=MSl-tDqOz04A:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=GC8p-B92FUEA:10 a=NWVoK91CQyQA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202605.468338392@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:27:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 117/171 ] USB: serial: fix hang when opening port
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0117-USB-serial-fix-hang-when-opening-port.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Ming Lei <tom.leiming@gmail.com>

[ Upstream commit eba0e3c3a0ba7b96f01cbe997680f6a4401a0bfc ]

Johan's 'fix use-after-free in TIOCMIWAIT' patchset[1] introduces
one bug which can cause kernel hang when opening port.

This patch initialized the 'port->delta_msr_wait' waitqueue head
to fix the bug which is introduced in 3.9-rc4.

[1], http://marc.info/?l=linux-usb&m=136368139627876&w=2

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Acked-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/serial/usb-serial.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index da1e728..5f38894 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -889,6 +889,7 @@ static int usb_serial_probe(struct usb_interface *interface,
 		port->port.ops = &serial_port_ops;
 		port->serial = serial;
 		spin_lock_init(&port->lock);
+		init_waitqueue_head(&port->delta_msr_wait);
 		/* Keep this for private driver use for the moment but
 		   should probably go away */
 		INIT_WORK(&port->work, usb_serial_port_work);
-- 
1.7.10.4


