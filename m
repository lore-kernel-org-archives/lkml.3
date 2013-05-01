Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761565Ab3EAQOF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 12:14:05 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58855 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752973Ab3EAQNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 12:13:55 -0400
Date: Wed, 1 May 2013 12:13:54 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: [PATCH] USB: remove remaining instances of USB_SUSPEND
In-Reply-To: <Pine.LNX.4.44L0.1304291706360.1152-100000@iolanthe.rowland.org>
Message-ID: <Pine.LNX.4.44L0.1305011209370.929-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 84ebc10294a3d7be4c66f51070b7aedbaa24de9b (USB: remove
CONFIG_USB_SUSPEND option) failed to remove all of the usages of
USB_SUSPEND throughout the kernel.  This patch (as1677) removes the
remaining instances of that symbol.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

As promised, here is a patch to finish the removal of USB_SUSPEND.  
It's up-to-date with 3.9 and Greg's usb-next tree as of Monday.  It's
possible that changes made since then or coming through other
subsystems have introduced new usages I'm not aware of.

It's up to the two of you to decide whether Linus should take this 
directly or whether it should go through Greg.

Alan Stern



 arch/arm/configs/omap1_defconfig     |    1 -
 arch/arm/configs/omap2plus_defconfig |    1 -
 arch/mips/configs/db1000_defconfig   |    1 -
 arch/mips/configs/db1235_defconfig   |    1 -
 arch/mips/configs/lemote2f_defconfig |    1 -
 arch/powerpc/configs/ps3_defconfig   |    1 -
 drivers/net/usb/usbnet.c             |    2 +-
 drivers/staging/gdm72xx/Kconfig      |    2 +-
 drivers/usb/core/Kconfig             |    2 +-
 drivers/usb/host/isp1760-hcd.c       |    2 +-
 drivers/usb/host/oxu210hp-hcd.c      |    2 +-
 drivers/usb/host/sl811-hcd.c         |    2 +-
 drivers/usb/phy/Kconfig              |    4 ++--
 13 files changed, 8 insertions(+), 14 deletions(-)

Index: usb-3.9/arch/arm/configs/omap1_defconfig
===================================================================
--- usb-3.9.orig/arch/arm/configs/omap1_defconfig
+++ usb-3.9/arch/arm/configs/omap1_defconfig
@@ -199,7 +199,6 @@ CONFIG_USB_PHY=y
 CONFIG_USB_DEBUG=y
 CONFIG_USB_DEVICEFS=y
 # CONFIG_USB_DEVICE_CLASS is not set
-CONFIG_USB_SUSPEND=y
 CONFIG_USB_MON=y
 CONFIG_USB_OHCI_HCD=y
 CONFIG_USB_STORAGE=y
Index: usb-3.9/arch/arm/configs/omap2plus_defconfig
===================================================================
--- usb-3.9.orig/arch/arm/configs/omap2plus_defconfig
+++ usb-3.9/arch/arm/configs/omap2plus_defconfig
@@ -199,7 +199,6 @@ CONFIG_USB=y
 CONFIG_USB_DEBUG=y
 CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
 CONFIG_USB_DEVICEFS=y
-CONFIG_USB_SUSPEND=y
 CONFIG_USB_MON=y
 CONFIG_USB_WDM=y
 CONFIG_USB_STORAGE=y
Index: usb-3.9/arch/mips/configs/db1000_defconfig
===================================================================
--- usb-3.9.orig/arch/mips/configs/db1000_defconfig
+++ usb-3.9/arch/mips/configs/db1000_defconfig
@@ -228,7 +228,6 @@ CONFIG_HIDRAW=y
 CONFIG_USB_HID=y
 CONFIG_USB_SUPPORT=y
 CONFIG_USB=y
-CONFIG_USB_SUSPEND=y
 CONFIG_USB_EHCI_HCD=y
 CONFIG_USB_EHCI_ROOT_HUB_TT=y
 CONFIG_USB_EHCI_TT_NEWSCHED=y
Index: usb-3.9/arch/mips/configs/db1235_defconfig
===================================================================
--- usb-3.9.orig/arch/mips/configs/db1235_defconfig
+++ usb-3.9/arch/mips/configs/db1235_defconfig
@@ -344,7 +344,6 @@ CONFIG_UHID=y
 CONFIG_USB_HIDDEV=y
 CONFIG_USB=y
 CONFIG_USB_DYNAMIC_MINORS=y
-CONFIG_USB_SUSPEND=y
 CONFIG_USB_EHCI_HCD=y
 CONFIG_USB_EHCI_HCD_PLATFORM=y
 CONFIG_USB_EHCI_ROOT_HUB_TT=y
Index: usb-3.9/arch/mips/configs/lemote2f_defconfig
===================================================================
--- usb-3.9.orig/arch/mips/configs/lemote2f_defconfig
+++ usb-3.9/arch/mips/configs/lemote2f_defconfig
@@ -300,7 +300,6 @@ CONFIG_USB=y
 CONFIG_USB_DEVICEFS=y
 # CONFIG_USB_DEVICE_CLASS is not set
 CONFIG_USB_DYNAMIC_MINORS=y
-CONFIG_USB_SUSPEND=y
 CONFIG_USB_OTG_WHITELIST=y
 CONFIG_USB_MON=y
 CONFIG_USB_EHCI_HCD=y
Index: usb-3.9/arch/powerpc/configs/ps3_defconfig
===================================================================
--- usb-3.9.orig/arch/powerpc/configs/ps3_defconfig
+++ usb-3.9/arch/powerpc/configs/ps3_defconfig
@@ -136,7 +136,6 @@ CONFIG_HID_SMARTJOYPLUS=m
 CONFIG_USB_HIDDEV=y
 CONFIG_USB=m
 CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
-CONFIG_USB_SUSPEND=y
 CONFIG_USB_MON=m
 CONFIG_USB_EHCI_HCD=m
 # CONFIG_USB_EHCI_HCD_PPC_OF is not set
Index: usb-3.9/drivers/net/usb/usbnet.c
===================================================================
--- usb-3.9.orig/drivers/net/usb/usbnet.c
+++ usb-3.9/drivers/net/usb/usbnet.c
@@ -1385,7 +1385,7 @@ usbnet_probe (struct usb_interface *udev
 
 	/* usbnet already took usb runtime pm, so have to enable the feature
 	 * for usb interface, otherwise usb_autopm_get_interface may return
-	 * failure if USB_SUSPEND(RUNTIME_PM) is enabled.
+	 * failure if RUNTIME_PM is enabled.
 	 */
 	if (!driver->supports_autosuspend) {
 		driver->supports_autosuspend = 1;
Index: usb-3.9/drivers/staging/gdm72xx/Kconfig
===================================================================
--- usb-3.9.orig/drivers/staging/gdm72xx/Kconfig
+++ usb-3.9/drivers/staging/gdm72xx/Kconfig
@@ -39,7 +39,7 @@ if WIMAX_GDM72XX_USB
 
 config WIMAX_GDM72XX_USB_PM
 	bool "Enable power managerment support"
-	depends on USB_SUSPEND
+	depends on PM_RUNTIME
 
 endif # WIMAX_GDM72XX_USB
 
Index: usb-3.9/drivers/usb/core/Kconfig
===================================================================
--- usb-3.9.orig/drivers/usb/core/Kconfig
+++ usb-3.9/drivers/usb/core/Kconfig
@@ -51,7 +51,7 @@ config USB_DYNAMIC_MINORS
 
 config USB_OTG
 	bool "OTG support"
-	depends on USB_SUSPEND
+	depends on PM_RUNTIME
 	default n
 	help
 	  The most notable feature of USB OTG is support for a
Index: usb-3.9/drivers/usb/host/isp1760-hcd.c
===================================================================
--- usb-3.9.orig/drivers/usb/host/isp1760-hcd.c
+++ usb-3.9/drivers/usb/host/isp1760-hcd.c
@@ -1739,7 +1739,7 @@ static int isp1760_hub_status_data(struc
 	int retval = 1;
 	unsigned long flags;
 
-	/* if !USB_SUSPEND, root hub timers won't get shut down ... */
+	/* if !PM_RUNTIME, root hub timers won't get shut down ... */
 	if (!HC_IS_RUNNING(hcd->state))
 		return 0;
 
Index: usb-3.9/drivers/usb/host/oxu210hp-hcd.c
===================================================================
--- usb-3.9.orig/drivers/usb/host/oxu210hp-hcd.c
+++ usb-3.9/drivers/usb/host/oxu210hp-hcd.c
@@ -3084,7 +3084,7 @@ static int oxu_hub_status_data(struct us
 	int ports, i, retval = 1;
 	unsigned long flags;
 
-	/* if !USB_SUSPEND, root hub timers won't get shut down ... */
+	/* if !PM_RUNTIME, root hub timers won't get shut down ... */
 	if (!HC_IS_RUNNING(hcd->state))
 		return 0;
 
Index: usb-3.9/drivers/usb/host/sl811-hcd.c
===================================================================
--- usb-3.9.orig/drivers/usb/host/sl811-hcd.c
+++ usb-3.9/drivers/usb/host/sl811-hcd.c
@@ -22,7 +22,7 @@
  * and usb-storage.
  *
  * TODO:
- * - usb suspend/resume triggered by sl811 (with USB_SUSPEND)
+ * - usb suspend/resume triggered by sl811 (with PM_RUNTIME)
  * - various issues noted in the code
  * - performance work; use both register banks; ...
  * - use urb->iso_frame_desc[] with ISO transfers
Index: usb-3.9/drivers/usb/phy/Kconfig
===================================================================
--- usb-3.9.orig/drivers/usb/phy/Kconfig
+++ usb-3.9/drivers/usb/phy/Kconfig
@@ -25,7 +25,7 @@ config AB8500_USB
 
 config FSL_USB2_OTG
 	bool "Freescale USB OTG Transceiver Driver"
-	depends on USB_EHCI_FSL && USB_FSL_USB2 && USB_SUSPEND
+	depends on USB_EHCI_FSL && USB_FSL_USB2 && PM_RUNTIME
 	select USB_OTG
 	help
 	  Enable this to support Freescale USB OTG transceiver.
@@ -162,7 +162,7 @@ config USB_MSM_OTG
 
 config USB_MV_OTG
 	tristate "Marvell USB OTG support"
-	depends on USB_EHCI_MV && USB_MV_UDC && USB_SUSPEND
+	depends on USB_EHCI_MV && USB_MV_UDC && PM_RUNTIME
 	select USB_OTG
 	help
 	  Say Y here if you want to build Marvell USB OTG transciever

