Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965177Ab3GCTB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:01:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10139 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965052Ab3GCTAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:33 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=puoM3l62MCMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=A4xw2BSuCQ0A:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=fBeKd2HRWbP4T1pgm1MA:9 a=MSl-tDqOz04A:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184058.225797361@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [081/141] USB: serial: fix Treo/Kyocera interrrupt-in urb context
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0081-USB-serial-fix-Treo-Kyocera-interrrupt-in-urb-contex.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

[ Upstream commit 5f8e2c07d75967ee49a5da1d21ddf5f50d48cda0 ]

The first and second interrupt-in urbs are swapped for some Treo/Kyocera
devices, but the urb context was never updated with the new port.

Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/serial/visor.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/visor.c b/drivers/usb/serial/visor.c
index 583a98a..4b53336 100644
--- a/drivers/usb/serial/visor.c
+++ b/drivers/usb/serial/visor.c
@@ -582,6 +582,7 @@ static int treo_attach(struct usb_serial *serial)
 		dest->bulk_in_buffer = src->bulk_in_buffer;		\
 		dest->bulk_in_size = src->bulk_in_size;			\
 		dest->interrupt_in_urb = src->interrupt_in_urb;		\
+		dest->interrupt_in_urb->context = dest;			\
 		dest->interrupt_in_endpointAddress = \
 					src->interrupt_in_endpointAddress;\
 		dest->interrupt_in_buffer = src->interrupt_in_buffer;	\
-- 
1.7.10.4


