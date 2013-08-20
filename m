Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921Ab3HTXWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 19:22:07 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:60231 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab3HTXWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 19:22:05 -0400
From: Julius Werner <jwerner@chromium.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Benson Leung <bleung@chromium.org>,
        Julius Werner <jwerner@chromium.org>
Subject: [PATCH] usb: xhci-plat: Enable USB 2.0 hardware LPM support for platform xHCs
Date: Tue, 20 Aug 2013 16:21:49 -0700
Message-Id: <1377040909-18428-1-git-send-email-jwerner@chromium.org>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver methods required for hardware LPM have only been added to the
PCI version of the XHCI driver, for no apparent reason. They seem to
work just as well with the platform driver, so let's add them to give
more devices the chance for additional power savings. Tested on the DWC3
xHC of an Exynos5420.

Signed-off-by: Julius Werner <jwerner@chromium.org>
---
 drivers/usb/host/xhci-plat.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index 51e22bf..7f46b5d 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -80,6 +80,10 @@ static const struct hc_driver xhci_plat_xhci_driver = {
 	.hub_status_data =	xhci_hub_status_data,
 	.bus_suspend =		xhci_bus_suspend,
 	.bus_resume =		xhci_bus_resume,
+
+	/* LPM support */
+	.update_device =	xhci_update_device,
+	.set_usb2_hw_lpm =	xhci_set_usb2_hardware_lpm,
 };
 
 static int xhci_plat_probe(struct platform_device *pdev)
-- 
1.7.12.4

