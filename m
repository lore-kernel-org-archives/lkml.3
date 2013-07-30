Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932683Ab3G3JiL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:38:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53378 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932646Ab3G3Jdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:33:54 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 093/106] USB: ti_usb_3410_5052: fix dynamic-id matching
Date: Tue, 30 Jul 2013 10:31:52 +0100
Message-Id: <1375176725-5825-94-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/ti_usb_3410_5052.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index a8c03e6..2f02f79 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -380,7 +380,7 @@ static int ti_startup(struct usb_serial *serial)
 	usb_set_serial_data(serial, tdev);
 
 	/* determine device type */
-	if (usb_match_id(serial->interface, ti_id_table_3410))
+	if (serial->type == &ti_1port_device)
 		tdev->td_is_3410 = 1;
 	dbg("%s - device type is %s", __func__,
 				tdev->td_is_3410 ? "3410" : "5052");
-- 
1.8.3.2

