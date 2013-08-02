Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab3HBKeJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:34:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37605 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab3HBKSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:18:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anders Hammarquist <iko@iko.pp.se>, Johan Hovold <jhovold@gmail.com>
Subject: [ 13/39] USB: ti_usb_3410_5052: fix dynamic-id matching
Date: Fri,  2 Aug 2013 18:18:23 +0800
Message-Id: <20130802101458.706260410@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802101456.800497005@linuxfoundation.org>
References: <20130802101456.800497005@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 1fad56424f5ad3ce4973505a357212b2e2282b3f upstream.

The driver failed to take the dynamic ids into account when determining
the device type and therefore all devices were detected as 2-port
devices when using the dynamic-id interface.

Match on the usb-serial-driver field instead of doing redundant id-table
searches.

Reported-by: Anders Hammarquist <iko@iko.pp.se>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ti_usb_3410_5052.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -390,7 +390,7 @@ static int ti_startup(struct usb_serial
 	usb_set_serial_data(serial, tdev);
 
 	/* determine device type */
-	if (usb_match_id(serial->interface, ti_id_table_3410))
+	if (serial->type == &ti_1port_device)
 		tdev->td_is_3410 = 1;
 	dbg("%s - device type is %s", __func__,
 				tdev->td_is_3410 ? "3410" : "5052");


