Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab3IKL1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 07:27:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9732 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab3IKL0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 07:26:44 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=aKMliZEFi44A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=l5ML3PNUNWMA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=OmLOuBDdCEVR9qQRHBMA:9 a=MSl-tDqOz04A:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=BPSfKMXmiYsA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042907.422777620@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Anders Hammarquist <iko@iko.pp.se>, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [091/251] USB: ti_usb_3410_5052: fix dynamic-id matching
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0091-USB-ti_usb_3410_5052-fix-dynamic-id-matching.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

[ Upstream commit 1fad56424f5ad3ce4973505a357212b2e2282b3f ]

The driver failed to take the dynamic ids into account when determining
the device type and therefore all devices were detected as 2-port
devices when using the dynamic-id interface.

Match on the usb-serial-driver field instead of doing redundant id-table
searches.

Reported-by: Anders Hammarquist <iko@iko.pp.se>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/serial/ti_usb_3410_5052.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index c7550bf..d654036 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -383,7 +383,7 @@ static int ti_startup(struct usb_serial *serial)
 	usb_set_serial_data(serial, tdev);
 
 	/* determine device type */
-	if (usb_match_id(serial->interface, ti_id_table_3410))
+	if (serial->type == &ti_1port_device)
 		tdev->td_is_3410 = 1;
 	dbg("%s - device type is %s", __func__,
 				tdev->td_is_3410 ? "3410" : "5052");
-- 
1.7.10.4


