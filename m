Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965210AbaGCJ3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:29:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52649 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758145AbaGCJZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:25:17 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paul Bolle <pebolle@tiscali.nl>, Tony Lindgren <tony@atomide.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 188/198] ARM: OMAP: replace checks for CONFIG_USB_GADGET_OMAP
Date: Thu,  3 Jul 2014 10:20:31 +0100
Message-Id: <1404379241-8590-189-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Bolle <pebolle@tiscali.nl>

commit 77c2f02edbeda9409a7cf3fd66233015820c213a upstream.

Commit 193ab2a60700 ("usb: gadget: allow multiple gadgets to be built")
apparently required that checks for CONFIG_USB_GADGET_OMAP would be
replaced with checks for CONFIG_USB_OMAP. Do so now for the remaining
checks for CONFIG_USB_GADGET_OMAP, even though these checks have
basically been broken since v3.1.

And, since we're touching this code, use the IS_ENABLED() macro, so
things will now (hopefully) also work if USB_OMAP is modular.

Fixes: 193ab2a60700 ("usb: gadget: allow multiple gadgets to be built")
Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-omap1/board-h2.c        | 2 +-
 arch/arm/mach-omap1/board-h3.c        | 2 +-
 arch/arm/mach-omap1/board-innovator.c | 2 +-
 arch/arm/mach-omap1/board-osk.c       | 2 +-
 drivers/usb/phy/phy-isp1301-omap.c    | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-omap1/board-h2.c b/arch/arm/mach-omap1/board-h2.c
index fd90cafc2e36..db57072aeed3 100644
--- a/arch/arm/mach-omap1/board-h2.c
+++ b/arch/arm/mach-omap1/board-h2.c
@@ -343,7 +343,7 @@ static struct omap_usb_config h2_usb_config __initdata = {
 	/* usb1 has a Mini-AB port and external isp1301 transceiver */
 	.otg		= 2,
 
-#ifdef	CONFIG_USB_GADGET_OMAP
+#if IS_ENABLED(CONFIG_USB_OMAP)
 	.hmc_mode	= 19,	/* 0:host(off) 1:dev|otg 2:disabled */
 	/* .hmc_mode	= 21,*/	/* 0:host(off) 1:dev(loopback) 2:host(loopback) */
 #elif	defined(CONFIG_USB_OHCI_HCD) || defined(CONFIG_USB_OHCI_HCD_MODULE)
diff --git a/arch/arm/mach-omap1/board-h3.c b/arch/arm/mach-omap1/board-h3.c
index 816ecd13f81e..bfed4f928663 100644
--- a/arch/arm/mach-omap1/board-h3.c
+++ b/arch/arm/mach-omap1/board-h3.c
@@ -366,7 +366,7 @@ static struct omap_usb_config h3_usb_config __initdata = {
 	/* usb1 has a Mini-AB port and external isp1301 transceiver */
 	.otg	    = 2,
 
-#ifdef CONFIG_USB_GADGET_OMAP
+#if IS_ENABLED(CONFIG_USB_OMAP)
 	.hmc_mode       = 19,   /* 0:host(off) 1:dev|otg 2:disabled */
 #elif  defined(CONFIG_USB_OHCI_HCD) || defined(CONFIG_USB_OHCI_HCD_MODULE)
 	/* NONSTANDARD CABLE NEEDED (B-to-Mini-B) */
diff --git a/arch/arm/mach-omap1/board-innovator.c b/arch/arm/mach-omap1/board-innovator.c
index bd5f02e9c354..c49ce83cc1eb 100644
--- a/arch/arm/mach-omap1/board-innovator.c
+++ b/arch/arm/mach-omap1/board-innovator.c
@@ -312,7 +312,7 @@ static struct omap_usb_config h2_usb_config __initdata = {
 	/* usb1 has a Mini-AB port and external isp1301 transceiver */
 	.otg		= 2,
 
-#ifdef	CONFIG_USB_GADGET_OMAP
+#if IS_ENABLED(CONFIG_USB_OMAP)
 	.hmc_mode	= 19,	/* 0:host(off) 1:dev|otg 2:disabled */
 	/* .hmc_mode	= 21,*/	/* 0:host(off) 1:dev(loopback) 2:host(loopback) */
 #elif	defined(CONFIG_USB_OHCI_HCD) || defined(CONFIG_USB_OHCI_HCD_MODULE)
diff --git a/arch/arm/mach-omap1/board-osk.c b/arch/arm/mach-omap1/board-osk.c
index a7ce69286688..006fbb5f9654 100644
--- a/arch/arm/mach-omap1/board-osk.c
+++ b/arch/arm/mach-omap1/board-osk.c
@@ -280,7 +280,7 @@ static struct omap_usb_config osk_usb_config __initdata = {
 	 * be used, with a NONSTANDARD gender-bending cable/dongle, as
 	 * a peripheral.
 	 */
-#ifdef	CONFIG_USB_GADGET_OMAP
+#if IS_ENABLED(CONFIG_USB_OMAP)
 	.register_dev	= 1,
 	.hmc_mode	= 0,
 #else
diff --git a/drivers/usb/phy/phy-isp1301-omap.c b/drivers/usb/phy/phy-isp1301-omap.c
index ae481afcb3ec..9201feb97e9e 100644
--- a/drivers/usb/phy/phy-isp1301-omap.c
+++ b/drivers/usb/phy/phy-isp1301-omap.c
@@ -1299,7 +1299,7 @@ isp1301_set_host(struct usb_otg *otg, struct usb_bus *host)
 		return isp1301_otg_enable(isp);
 	return 0;
 
-#elif	!defined(CONFIG_USB_GADGET_OMAP)
+#elif !IS_ENABLED(CONFIG_USB_OMAP)
 	// FIXME update its refcount
 	otg->host = host;
 
-- 
1.9.1

