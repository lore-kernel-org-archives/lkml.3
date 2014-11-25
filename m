Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbaKYKkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:40:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58061 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbaKYKk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:40:28 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 021/254] USB: core: add device-qualifier quirk
Date: Tue, 25 Nov 2014 10:36:11 +0000
Message-Id: <1416912004-5928-22-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 2a159389bf5d962359349a76827b2f683276a1c7 upstream.

Add new quirk for devices that cannot handle requests for the
device_qualifier descriptor.

A USB-2.0 compliant device must respond to requests for the
device_qualifier descriptor (even if it's with a request error), but at
least one device is known to misbehave after such a request.

Suggested-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: prereq for the following Elan touchscreen patches ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/core/hub.c     | 3 +++
 include/linux/usb/quirks.h | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index ba2a8f3b8059..0e0e0354c523 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -4524,6 +4524,9 @@ check_highspeed (struct usb_hub *hub, struct usb_device *udev, int port1)
 	struct usb_qualifier_descriptor	*qual;
 	int				status;
 
+	if (udev->quirks & USB_QUIRK_DEVICE_QUALIFIER)
+		return;
+
 	qual = kmalloc (sizeof *qual, GFP_KERNEL);
 	if (qual == NULL)
 		return;
diff --git a/include/linux/usb/quirks.h b/include/linux/usb/quirks.h
index 49587dc22f5d..8b96ae2a38fe 100644
--- a/include/linux/usb/quirks.h
+++ b/include/linux/usb/quirks.h
@@ -33,4 +33,7 @@
 /* device generates spurious wakeup, ignore remote wakeup capability */
 #define USB_QUIRK_IGNORE_REMOTE_WAKEUP	0x00000200
 
+/* device can't handle device_qualifier descriptor requests */
+#define USB_QUIRK_DEVICE_QUALIFIER	0x00000100
+
 #endif /* __LINUX_USB_QUIRKS_H */
-- 
2.1.0

