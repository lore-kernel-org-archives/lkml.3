Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbaG2Ide (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 04:33:34 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:56646 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbaG2Idb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 04:33:31 -0400
Date: Tue, 29 Jul 2014 09:33:25 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Michael Welling <mwelling@emacinc.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, rogerq@ti.com,
        gregkh@linuxfoundation.org, stern@rowland.harvard.edu, balbi@ti.com,
        stable@vger.kernel.org
Subject: [PATCH] mfd: omap-usb-host: Fix improper mask use
Message-ID: <20140729083325.GA9030@lee--X1>
References: <1406588464-19104-1-git-send-email-mwelling@emacinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406588464-19104-1-git-send-email-mwelling@emacinc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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

--> Applied, thanks. <--

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
