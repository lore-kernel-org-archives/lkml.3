Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965112Ab3GCTAq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:00:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3164 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965057Ab3GCTAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:34 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=IAxdgN5yM8kA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=xyuchOrSIs0A:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=fBeKd2HRWbP4T1pgm1MA:9 a=MSl-tDqOz04A:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=zeWgoeaF2nIPFwiG:21 a=_tRNutLjv7VW7lz4:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184058.023909474@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [080/141] USB: whiteheat: fix broken port configuration
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0080-USB-whiteheat-fix-broken-port-configuration.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

[ Upstream commit 9eecf22d2b375b9064a20421c6c307b760b03d46 ]

When configuring the port (e.g. set_termios) the port minor number
rather than the port number was used in the request (and they only
coincide for minor number 0).

Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/serial/whiteheat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/serial/whiteheat.c b/drivers/usb/serial/whiteheat.c
index bd36321..e8d650b 100644
--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -720,7 +720,7 @@ static void firm_setup_port(struct tty_struct *tty)
 	struct whiteheat_port_settings port_settings;
 	unsigned int cflag = tty->termios->c_cflag;
 
-	port_settings.port = port->number + 1;
+	port_settings.port = port->number - port->serial->minor + 1;
 
 	/* get the byte size */
 	switch (cflag & CSIZE) {
-- 
1.7.10.4


