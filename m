Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbaF3MmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:42:20 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932101AbaF3MbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:31:15 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paul Bolle <pebolle@tiscali.nl>,
        Tony Lindgren <tony@atomide.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 107/181] ARM: OMAP: replace checks for CONFIG_USB_GADGET_OMAP
Date: Mon, 30 Jun 2014 13:52:08 +0200
Message-Id: <c4f66fb853955e8a620eb1e7d84e4585f4f32b9c.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Bolle <pebolle@tiscali.nl>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
index d3a5160e4cc7..4a2ced057b40 100644
--- a/drivers/usb/phy/phy-isp1301-omap.c
+++ b/drivers/usb/phy/phy-isp1301-omap.c
@@ -1295,7 +1295,7 @@ isp1301_set_host(struct usb_otg *otg, struct usb_bus *host)
 		return isp1301_otg_enable(isp);
 	return 0;
 
-#elif	!defined(CONFIG_USB_GADGET_OMAP)
+#elif !IS_ENABLED(CONFIG_USB_OMAP)
 	// FIXME update its refcount
 	otg->host = host;
 
-- 
2.0.0

