Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597Ab3IYBFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:05:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39128 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111Ab3IYAQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:16:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Linus G Thiel <linus@hanssonlarsson.se>,
        Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [ 062/110] HID: Correct the USB IDs for the new Macbook Air 6
Date: Tue, 24 Sep 2013 17:15:00 -0700
Message-Id: <20130925001330.133222854@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001323.387158698@linuxfoundation.org>
References: <20130925001323.387158698@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henrik Rydberg <rydberg@euromail.se>

commit 8c89cc17b91992845bd635813cd162fe8dfcec6e upstream.

A recent patch (9d9a04ee) added support for the new machine, but got
the sequence of USB ids wrong. Reports from both Ian and Linus T show
that the 0x0291 id is for ISO, not ANSI, which should have the missing
number 0x0290. This patchs moves the three numbers accordingly, fixing
the problem.

Reported-and-tested-by: Ian Munsie <darkstarsword@gmail.com>
Tested-by: Linus G Thiel <linus@hanssonlarsson.se>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-ids.h         |    6 +++---
 drivers/input/mouse/bcm5974.c |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -135,9 +135,9 @@
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_JIS   0x023b
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ANSI  0x0255
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ISO   0x0256
-#define USB_DEVICE_ID_APPLE_WELLSPRING8_ANSI	0x0291
-#define USB_DEVICE_ID_APPLE_WELLSPRING8_ISO	0x0292
-#define USB_DEVICE_ID_APPLE_WELLSPRING8_JIS	0x0293
+#define USB_DEVICE_ID_APPLE_WELLSPRING8_ANSI	0x0290
+#define USB_DEVICE_ID_APPLE_WELLSPRING8_ISO	0x0291
+#define USB_DEVICE_ID_APPLE_WELLSPRING8_JIS	0x0292
 #define USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY	0x030a
 #define USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY	0x030b
 #define USB_DEVICE_ID_APPLE_IRCONTROL	0x8240
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -89,9 +89,9 @@
 #define USB_DEVICE_ID_APPLE_WELLSPRING7A_ISO	0x025a
 #define USB_DEVICE_ID_APPLE_WELLSPRING7A_JIS	0x025b
 /* MacbookAir6,2 (unibody, June 2013) */
-#define USB_DEVICE_ID_APPLE_WELLSPRING8_ANSI	0x0291
-#define USB_DEVICE_ID_APPLE_WELLSPRING8_ISO	0x0292
-#define USB_DEVICE_ID_APPLE_WELLSPRING8_JIS	0x0293
+#define USB_DEVICE_ID_APPLE_WELLSPRING8_ANSI	0x0290
+#define USB_DEVICE_ID_APPLE_WELLSPRING8_ISO	0x0291
+#define USB_DEVICE_ID_APPLE_WELLSPRING8_JIS	0x0292
 
 #define BCM5974_DEVICE(prod) {					\
 	.match_flags = (USB_DEVICE_ID_MATCH_DEVICE |		\


