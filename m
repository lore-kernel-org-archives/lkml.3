Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249AbaICJ4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:56:37 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57373 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756226AbaICJ4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:56:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Joonyoung Shim <jy0922.shim@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 04/56] USB: add reset resume quirk for usb3503
Date: Wed,  3 Sep 2014 11:26:23 +0200
Message-Id: <0003ed46b16d2dd12b5f95d6dd6d2b3b1d43166d.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
References: <cover.1409735865.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joonyoung Shim <jy0922.shim@samsung.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/core/quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 1053eb651b2f..31f7ebf55868 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -154,6 +154,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* INTEL VALUE SSD */
 	{ USB_DEVICE(0x8086, 0xf1a5), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* USB3503 */
+	{ USB_DEVICE(0x0424, 0x3503), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	{ }  /* terminating entry must be last */
 };
 
-- 
2.1.0

