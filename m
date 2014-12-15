Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbaLOObI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:31:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39078 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113AbaLOO31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:29:27 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joonyoung Shim <jy0922.shim@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 166/168] USB: add reset resume quirk for usb3503
Date: Mon, 15 Dec 2014 14:27:00 +0000
Message-Id: <1418653622-21105-167-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joonyoung Shim <jy0922.shim@samsung.com>

commit 526a4045c60fbaede88ec95a69a73059dff02160 upstream.

The usb device will autoresume from choose_wakeup() if it is
autosuspended with the wrong wakeup setting, but below errors occur
because usb3503 misc driver will switch to standby mode when suspended.

As add USB_QUIRK_RESET_RESUME, it can stop setting wrong wakeup from
autosuspend_check().

[    7.734717] usb 1-3: reset high-speed USB device number 3 using exynos-ehci
[    7.854658] usb 1-3: device descriptor read/64, error -71
[    8.079657] usb 1-3: device descriptor read/64, error -71
[    8.294664] usb 1-3: reset high-speed USB device number 3 using exynos-ehci
[    8.414658] usb 1-3: device descriptor read/64, error -71
[    8.639657] usb 1-3: device descriptor read/64, error -71
[    8.854667] usb 1-3: reset high-speed USB device number 3 using exynos-ehci
[    9.264598] usb 1-3: device not accepting address 3, error -71
[    9.374655] usb 1-3: reset high-speed USB device number 3 using exynos-ehci
[    9.784601] usb 1-3: device not accepting address 3, error -71
[    9.784838] usb usb1-port3: device 1-3 not suspended yet

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/core/quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index b195fdb1effc..7f4a4412b2fc 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -165,6 +165,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* INTEL VALUE SSD */
 	{ USB_DEVICE(0x8086, 0xf1a5), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* USB3503 */
+	{ USB_DEVICE(0x0424, 0x3503), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	{ }  /* terminating entry must be last */
 };
 
-- 
2.1.3

