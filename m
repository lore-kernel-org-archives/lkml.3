Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933438AbbA2CLc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:11:32 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:62662 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933407AbbA2CLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:11:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Felipe Balbi <balbi@ti.com>
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] usb: musb: add generic usb phy dependencies
Date: Wed, 28 Jan 2015 22:50:04 +0100
Message-ID: <4595774.yLOm5IvvqR@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:QRl3uQrgU3nty2Mnp2jV9Psev6kXXWVFd/xnsFpAbDBKLfgd8Ko
 7FB8rlfsT+zYrt6e9LkeBRCwmgocsWWY9d4NqxZSgxstTNTnG/PEFisXbR6v5dTrhaswDTQ
 t1CMTvAH/eIIpNkI8aaEMjBAro5Ua26/x/tiXVkAbcgt/ZCwjPkUNIzNmE/DtgkOa0ncfRP
 bG3TfeTPaH6T5PlpeEM/A==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Multiple musb glue drivers depend on the generic usb phy support,
but fail to list it as a dependency in Kconfig. This results
in build erros like:

drivers/built-in.o: In function `am35x_remove':
:(.text+0xadacc): undefined reference to `usb_phy_generic_unregister'
drivers/built-in.o: In function `am35x_probe':
:(.text+0xae1c8): undefined reference to `usb_phy_generic_register'
:(.text+0xae244): undefined reference to `usb_phy_generic_unregister'
drivers/built-in.o: In function `jz4740_remove':
:(.text+0xaf648): undefined reference to `usb_phy_generic_unregister'
drivers/built-in.o: In function `jz4740_musb_init':
:(.text+0xaf694): undefined reference to `usb_phy_generic_register'

This adds the ones that are missing.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
index b005010240e5..26c835f1b726 100644
--- a/drivers/usb/musb/Kconfig
+++ b/drivers/usb/musb/Kconfig
@@ -63,11 +63,13 @@ comment "Platform Glue Layer"
 config USB_MUSB_DAVINCI
 	tristate "DaVinci"
 	depends on ARCH_DAVINCI_DMx
+	depends on NOP_USB_XCEIV
 	depends on BROKEN
 
 config USB_MUSB_DA8XX
 	tristate "DA8xx/OMAP-L1x"
 	depends on ARCH_DAVINCI_DA8XX
+	depends on NOP_USB_XCEIV
 	depends on BROKEN
 
 config USB_MUSB_TUSB6010
@@ -83,6 +85,7 @@ config USB_MUSB_OMAP2PLUS
 config USB_MUSB_AM35X
 	tristate "AM35x"
 	depends on ARCH_OMAP
+	depends on NOP_USB_XCEIV
 
 config USB_MUSB_DSPS
 	tristate "TI DSPS platforms"
@@ -93,6 +96,7 @@ config USB_MUSB_DSPS
 config USB_MUSB_BLACKFIN
 	tristate "Blackfin"
 	depends on (BF54x && !BF544) || (BF52x && ! BF522 && !BF523)
+	depends on NOP_USB_XCEIV
 
 config USB_MUSB_UX500
 	tristate "Ux500 platforms"
@@ -100,6 +104,7 @@ config USB_MUSB_UX500
 
 config USB_MUSB_JZ4740
 	tristate "JZ4740"
+	depends on NOP_USB_XCEIV
 	depends on MACH_JZ4740 || COMPILE_TEST
 	depends on USB_MUSB_GADGET
 	depends on USB_OTG_BLACKLIST_HUB

