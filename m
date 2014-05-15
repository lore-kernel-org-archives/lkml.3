Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756AbaEOU4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 16:56:25 -0400
Received: from [213.75.39.4] ([213.75.39.4]:52230 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754516AbaEOU4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 16:56:23 -0400
Message-ID: <1400187345.11786.28.camel@x220>
Subject: [PATCH] ARM: OMAP: replace checks for CONFIG_USB_GADGET_OMAP
From: Paul Bolle <pebolle@tiscali.nl>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 15 May 2014 22:55:45 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 May 2014 20:55:45.0953 (UTC) FILETIME=[0AFD4910:01CF7080]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 193ab2a60700 ("usb: gadget: allow multiple gadgets to be built")
apparently required that checks for CONFIG_USB_GADGET_OMAP would be
replaced with checks for CONFIG_USB_OMAP. Do so now for the remaining
checks for CONFIG_USB_GADGET_OMAP, even though these checks have
basically been broken since v3.1.

Fixes: 193ab2a60700 ("usb: gadget: allow multiple gadgets to be built")
Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Also untested.

It seems efficient to also include the change to phy-isp1301-omap.c in
this patch (ie, not ship that as a separate patch).

 arch/arm/mach-omap1/board-h2.c        | 2 +-
 arch/arm/mach-omap1/board-h3.c        | 2 +-
 arch/arm/mach-omap1/board-innovator.c | 2 +-
 arch/arm/mach-omap1/board-osk.c       | 2 +-
 drivers/usb/phy/phy-isp1301-omap.c    | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-omap1/board-h2.c b/arch/arm/mach-omap1/board-h2.c
index 65d2acb31498..57092bc7f4f1 100644
--- a/arch/arm/mach-omap1/board-h2.c
+++ b/arch/arm/mach-omap1/board-h2.c
@@ -346,7 +346,7 @@ static struct omap_usb_config h2_usb_config __initdata = {
 	/* usb1 has a Mini-AB port and external isp1301 transceiver */
 	.otg		= 2,
 
-#ifdef	CONFIG_USB_GADGET_OMAP
+#ifdef	CONFIG_USB_OMAP
 	.hmc_mode	= 19,	/* 0:host(off) 1:dev|otg 2:disabled */
 	/* .hmc_mode	= 21,*/	/* 0:host(off) 1:dev(loopback) 2:host(loopback) */
 #elif	defined(CONFIG_USB_OHCI_HCD) || defined(CONFIG_USB_OHCI_HCD_MODULE)
diff --git a/arch/arm/mach-omap1/board-h3.c b/arch/arm/mach-omap1/board-h3.c
index 816ecd13f81e..c828aacf469a 100644
--- a/arch/arm/mach-omap1/board-h3.c
+++ b/arch/arm/mach-omap1/board-h3.c
@@ -366,7 +366,7 @@ static struct omap_usb_config h3_usb_config __initdata = {
 	/* usb1 has a Mini-AB port and external isp1301 transceiver */
 	.otg	    = 2,
 
-#ifdef CONFIG_USB_GADGET_OMAP
+#ifdef CONFIG_USB_OMAP
 	.hmc_mode       = 19,   /* 0:host(off) 1:dev|otg 2:disabled */
 #elif  defined(CONFIG_USB_OHCI_HCD) || defined(CONFIG_USB_OHCI_HCD_MODULE)
 	/* NONSTANDARD CABLE NEEDED (B-to-Mini-B) */
diff --git a/arch/arm/mach-omap1/board-innovator.c b/arch/arm/mach-omap1/board-innovator.c
index bd5f02e9c354..1652ead0effa 100644
--- a/arch/arm/mach-omap1/board-innovator.c
+++ b/arch/arm/mach-omap1/board-innovator.c
@@ -312,7 +312,7 @@ static struct omap_usb_config h2_usb_config __initdata = {
 	/* usb1 has a Mini-AB port and external isp1301 transceiver */
 	.otg		= 2,
 
-#ifdef	CONFIG_USB_GADGET_OMAP
+#ifdef	CONFIG_USB_OMAP
 	.hmc_mode	= 19,	/* 0:host(off) 1:dev|otg 2:disabled */
 	/* .hmc_mode	= 21,*/	/* 0:host(off) 1:dev(loopback) 2:host(loopback) */
 #elif	defined(CONFIG_USB_OHCI_HCD) || defined(CONFIG_USB_OHCI_HCD_MODULE)
diff --git a/arch/arm/mach-omap1/board-osk.c b/arch/arm/mach-omap1/board-osk.c
index 3a0262156e93..70b1b282e5c2 100644
--- a/arch/arm/mach-omap1/board-osk.c
+++ b/arch/arm/mach-omap1/board-osk.c
@@ -283,7 +283,7 @@ static struct omap_usb_config osk_usb_config __initdata = {
 	 * be used, with a NONSTANDARD gender-bending cable/dongle, as
 	 * a peripheral.
 	 */
-#ifdef	CONFIG_USB_GADGET_OMAP
+#ifdef	CONFIG_USB_OMAP
 	.register_dev	= 1,
 	.hmc_mode	= 0,
 #else
diff --git a/drivers/usb/phy/phy-isp1301-omap.c b/drivers/usb/phy/phy-isp1301-omap.c
index 6e146d723b37..1ea6a0c30040 100644
--- a/drivers/usb/phy/phy-isp1301-omap.c
+++ b/drivers/usb/phy/phy-isp1301-omap.c
@@ -1295,7 +1295,7 @@ isp1301_set_host(struct usb_otg *otg, struct usb_bus *host)
 		return isp1301_otg_enable(isp);
 	return 0;
 
-#elif	!defined(CONFIG_USB_GADGET_OMAP)
+#elif	!defined(CONFIG_USB_OMAP)
 	// FIXME update its refcount
 	otg->host = host;
 
-- 
1.9.0

