Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663Ab3IKE6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:58:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239Ab3IKE46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:56:58 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=txPb92pUGpoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=h0mE9ULvYyMA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=dUGKdvpuBZeXxOn56pwA:9 a=MSl-tDqOz04A:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042927.109375839@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [210/251] USB: keyspan: fix null-deref at disconnect and release
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0210-USB-keyspan-fix-null-deref-at-disconnect-and-release.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

[ Upstream commit ff8a43c10f1440f07a5faca0c1556921259f7f76 ]

Make sure to fail properly if the device is not accepted during attach
in order to avoid null-pointer derefs (of missing interface private
data) at disconnect or release.

Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/serial/keyspan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index caf85ab..c9e3455 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -2389,7 +2389,7 @@ static int keyspan_startup(struct usb_serial *serial)
 	if (d_details == NULL) {
 		dev_err(&serial->dev->dev, "%s - unknown product id %x\n",
 		    __func__, le16_to_cpu(serial->dev->descriptor.idProduct));
-		return 1;
+		return -ENODEV;
 	}
 
 	/* Setup private data for serial driver */
-- 
1.7.10.4


