Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934467AbbA1EY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:24:29 -0500
Received: from mail.kernel.org ([198.145.29.136]:40683 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965066AbbA1EYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:24:25 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 130/177] USB: core: add device-qualifier quirk
Date: Wed, 28 Jan 2015 12:09:48 +0800
Message-Id: <1422418236-12852-221-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 2a159389bf5d962359349a76827b2f683276a1c7 upstream.

Add new quirk for devices that cannot handle requests for the
device_qualifier descriptor.

A USB-2.0 compliant device must respond to requests for the
device_qualifier descriptor (even if it's with a request error), but at
least one device is known to misbehave after such a request.

Suggested-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/usb/core/hub.c     | 3 +++
 include/linux/usb/quirks.h | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 2d5177a..93f2538 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3361,6 +3361,9 @@ check_highspeed (struct usb_hub *hub, struct usb_device *udev, int port1)
 	struct usb_qualifier_descriptor	*qual;
 	int				status;
 
+	if (udev->quirks & USB_QUIRK_DEVICE_QUALIFIER)
+		return;
+
 	qual = kmalloc (sizeof *qual, GFP_KERNEL);
 	if (qual == NULL)
 		return;
diff --git a/include/linux/usb/quirks.h b/include/linux/usb/quirks.h
index 8eeeb87..d0d2af0 100644
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
1.9.1

