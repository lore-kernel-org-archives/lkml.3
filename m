Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbaF1Ssp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:48:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53391 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230AbaF1Rtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:49:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 3.14 018/110] ARM: OMAP: replace checks for CONFIG_USB_GADGET_OMAP
Date: Sat, 28 Jun 2014 10:46:15 -0700
Message-Id: <20140628174546.336708349@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174545.354748696@linuxfoundation.org>
References: <20140628174545.354748696@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-omap1/board-h2.c        |    2 +-
 arch/arm/mach-omap1/board-h3.c        |    2 +-
 arch/arm/mach-omap1/board-innovator.c |    2 +-
 arch/arm/mach-omap1/board-osk.c       |    2 +-
 drivers/usb/phy/phy-isp1301-omap.c    |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

--- a/arch/arm/mach-omap1/board-h2.c
+++ b/arch/arm/mach-omap1/board-h2.c
@@ -343,7 +343,7 @@ static struct omap_usb_config h2_usb_con
 	/* usb1 has a Mini-AB port and external isp1301 transceiver */
 	.otg		= 2,
 
-#ifdef	CONFIG_USB_GADGET_OMAP
+#if IS_ENABLED(CONFIG_USB_OMAP)
 	.hmc_mode	= 19,	/* 0:host(off) 1:dev|otg 2:disabled */
 	/* .hmc_mode	= 21,*/	/* 0:host(off) 1:dev(loopback) 2:host(loopback) */
 #elif	defined(CONFIG_USB_OHCI_HCD) || defined(CONFIG_USB_OHCI_HCD_MODULE)
--- a/arch/arm/mach-omap1/board-h3.c
+++ b/arch/arm/mach-omap1/board-h3.c
@@ -366,7 +366,7 @@ static struct omap_usb_config h3_usb_con
 	/* usb1 has a Mini-AB port and external isp1301 transceiver */
 	.otg	    = 2,
 
-#ifdef CONFIG_USB_GADGET_OMAP
+#if IS_ENABLED(CONFIG_USB_OMAP)
 	.hmc_mode       = 19,   /* 0:host(off) 1:dev|otg 2:disabled */
 #elif  defined(CONFIG_USB_OHCI_HCD) || defined(CONFIG_USB_OHCI_HCD_MODULE)
 	/* NONSTANDARD CABLE NEEDED (B-to-Mini-B) */
--- a/arch/arm/mach-omap1/board-innovator.c
+++ b/arch/arm/mach-omap1/board-innovator.c
@@ -312,7 +312,7 @@ static struct omap_usb_config h2_usb_con
 	/* usb1 has a Mini-AB port and external isp1301 transceiver */
 	.otg		= 2,
 
-#ifdef	CONFIG_USB_GADGET_OMAP
+#if IS_ENABLED(CONFIG_USB_OMAP)
 	.hmc_mode	= 19,	/* 0:host(off) 1:dev|otg 2:disabled */
 	/* .hmc_mode	= 21,*/	/* 0:host(off) 1:dev(loopback) 2:host(loopback) */
 #elif	defined(CONFIG_USB_OHCI_HCD) || defined(CONFIG_USB_OHCI_HCD_MODULE)
--- a/arch/arm/mach-omap1/board-osk.c
+++ b/arch/arm/mach-omap1/board-osk.c
@@ -280,7 +280,7 @@ static struct omap_usb_config osk_usb_co
 	 * be used, with a NONSTANDARD gender-bending cable/dongle, as
 	 * a peripheral.
 	 */
-#ifdef	CONFIG_USB_GADGET_OMAP
+#if IS_ENABLED(CONFIG_USB_OMAP)
 	.register_dev	= 1,
 	.hmc_mode	= 0,
 #else
--- a/drivers/usb/phy/phy-isp1301-omap.c
+++ b/drivers/usb/phy/phy-isp1301-omap.c
@@ -1295,7 +1295,7 @@ isp1301_set_host(struct usb_otg *otg, st
 		return isp1301_otg_enable(isp);
 	return 0;
 
-#elif	!defined(CONFIG_USB_GADGET_OMAP)
+#elif !IS_ENABLED(CONFIG_USB_OMAP)
 	// FIXME update its refcount
 	otg->host = host;
 


