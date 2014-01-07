Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbaAGCdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 21:33:17 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:58084 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131AbaAGCdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 21:33:15 -0500
MIME-Version: 1.0
Date: Tue, 7 Jan 2014 10:33:14 +0800
Message-ID: <CANthSfZij7=q1azM1wrRNDWjFY972zFpe4njBKr3bzUVsm5m-Q@mail.gmail.com>
Subject: [PATCH] usb:hub set hub->change_bits when over-current happens
From: =?GB2312?B?yfK54g==?= <shenguang10@gmail.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set hub->change_bits when we plug in a device which causes
over-current condition, so that hub_events() will check it.

Signed-off-by: Shen Guang <shenguang10@gmail.com>
---
 drivers/usb/core/hub.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index bd9dc35..98b5679 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1154,7 +1154,8 @@ static void hub_activate(struct usb_hub *hub,
enum hub_activation_type type)
                        /* Tell khubd to disconnect the device or
                         * check for a new connection
                         */
-                       if (udev || (portstatus & USB_PORT_STAT_CONNECTION))
+                       if (udev || (portstatus & USB_PORT_STAT_CONNECTION) ||
+                               (portstatus & USB_PORT_STAT_OVERCURRENT))
                                set_bit(port1, hub->change_bits);

                } else if (portstatus & USB_PORT_STAT_ENABLE) {
--
1.7.9.5
