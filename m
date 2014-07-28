Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589AbaG1XBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 19:01:17 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:47279 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaG1XBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 19:01:11 -0400
From: Michael Welling <mwelling@emacinc.com>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, rogerq@ti.com,
        gregkh@linuxfoundation.org, stern@rowland.harvard.edu, balbi@ti.com
Cc: Michael Welling <mwelling@emacinc.com>
Subject: [PATCH] drivers:mfd:omap-usb-host.c: Fix improper mask use.
Date: Mon, 28 Jul 2014 18:01:04 -0500
Message-Id: <1406588464-19104-1-git-send-email-mwelling@emacinc.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

single-ulpi-bypass is a flag used for older OMAP3 silicon.

The flag when set, can excite code that improperly uses the
OMAP_UHH_HOSTCONFIG_UPLI_BYPASS define to clear the corresponding bit.
Instead it clears all of the other bits disabling all of the ports in
the process.

Signed-off-by: Michael Welling <mwelling@emacinc.com>
---
 drivers/mfd/omap-usb-host.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index b48d80c..33a9234 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -445,7 +445,7 @@ static unsigned omap_usbhs_rev1_hostconfig(struct usbhs_hcd_omap *omap,
 
 		for (i = 0; i < omap->nports; i++) {
 			if (is_ehci_phy_mode(pdata->port_mode[i])) {
-				reg &= OMAP_UHH_HOSTCONFIG_ULPI_BYPASS;
+				reg &= ~OMAP_UHH_HOSTCONFIG_ULPI_BYPASS;
 				break;
 			}
 		}
-- 
1.7.10.4

