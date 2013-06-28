Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab3F1KYy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 06:24:54 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:63367 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975Ab3F1KYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 06:24:51 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Anders Hammarquist <iko@iko.pp.se>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Johan Hovold <jhovold@gmail.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH] USB: ti_usb_3410_5052: fix dynamic-id matching
Date: Fri, 28 Jun 2013 12:24:26 +0200
Message-Id: <1372415066-1031-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <20130628102333.GA13241@localhost>
References: <20130628102333.GA13241@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver failed to take the dynamic ids into account when determining
the device type and therefore all devices were detected as 2-port
devices when using the dynamic-id interface.

Match on the usb-serial-driver field instead of doing redundant id-table
searches.

Reported-by: Anders Hammarquist <iko@iko.pp.se>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/ti_usb_3410_5052.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index 5585b20..5c07d55 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -309,7 +309,7 @@ static int ti_startup(struct usb_serial *serial)
 	usb_set_serial_data(serial, tdev);
 
 	/* determine device type */
-	if (usb_match_id(serial->interface, ti_id_table_3410))
+	if (serial->type == &ti_1port_device)
 		tdev->td_is_3410 = 1;
 	dev_dbg(&dev->dev, "%s - device type is %s\n", __func__,
 		tdev->td_is_3410 ? "3410" : "5052");
-- 
1.8.2.1

