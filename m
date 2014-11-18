Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644AbaKROfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:35:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57203 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754930AbaKROKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:11 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 159/206] USB: core: add device-qualifier quirk
Date: Tue, 18 Nov 2014 15:08:34 +0100
Message-Id: <856cb361321b3ba16f90dd07e695b6fd4ccea5e1.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 2a159389bf5d962359349a76827b2f683276a1c7 upstream.

Add new quirk for devices that cannot handle requests for the
device_qualifier descriptor.

A USB-2.0 compliant device must respond to requests for the
device_qualifier descriptor (even if it's with a request error), but at
least one device is known to misbehave after such a request.

Suggested-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/core/hub.c     | 3 +++
 include/linux/usb/quirks.h | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 48d3eed8e250..420bf9bb09e5 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -4347,6 +4347,9 @@ check_highspeed (struct usb_hub *hub, struct usb_device *udev, int port1)
 	struct usb_qualifier_descriptor	*qual;
 	int				status;
 
+	if (udev->quirks & USB_QUIRK_DEVICE_QUALIFIER)
+		return;
+
 	qual = kmalloc (sizeof *qual, GFP_KERNEL);
 	if (qual == NULL)
 		return;
diff --git a/include/linux/usb/quirks.h b/include/linux/usb/quirks.h
index c3ddcdc36598..3fb428883460 100644
--- a/include/linux/usb/quirks.h
+++ b/include/linux/usb/quirks.h
@@ -47,4 +47,7 @@
 /* device generates spurious wakeup, ignore remote wakeup capability */
 #define USB_QUIRK_IGNORE_REMOTE_WAKEUP	0x00000200
 
+/* device can't handle device_qualifier descriptor requests */
+#define USB_QUIRK_DEVICE_QUALIFIER	0x00000100
+
 #endif /* __LINUX_USB_QUIRKS_H */
-- 
2.1.3

