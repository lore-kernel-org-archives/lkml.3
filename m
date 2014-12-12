Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760227AbaLLG7c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:59:32 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51714 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758592AbaLLGQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:53 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Joonyoung Shim" <jy0922.shim@samsung.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.573980791@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 016/164] USB: add reset resume quirk for usb3503
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/core/quirks.c | 3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -154,6 +154,9 @@ static const struct usb_device_id usb_qu
 	/* INTEL VALUE SSD */
 	{ USB_DEVICE(0x8086, 0xf1a5), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* USB3503 */
+	{ USB_DEVICE(0x0424, 0x3503), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	{ }  /* terminating entry must be last */
 };
 

