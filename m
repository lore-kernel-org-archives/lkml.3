Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760563Ab3EBPVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 11:21:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55192 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759045Ab3EBPQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 11:16:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH, RFC 15/22] USB: EHCI: remove bogus #error
Date: Thu,  2 May 2013 17:16:19 +0200
Message-Id: <1367507786-505303-16-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367507786-505303-1-git-send-email-arnd@arndb.de>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:mPU+qDF++LaJO56hALkT3OyajiZ2VVWeMmTR4XF4L1T
 H3TpjdHu9B9xjhwsjxXurySV5mTBEC2ss3ujvAmLJP1ewnGUGl
 xlzUVFZeEDmge6G115jCmvA1ChhBjrxfsm5bfA1zxZWgHo3xaF
 167xRCkXmSqM+AGpk0qlyp0+j/1fvgPpO0dhRGmb3xXT4OGZTr
 V8SF8pEQbQ1/cV6nTvS9AU6IOSseZ09HydyO0ayrsWjDkObfkc
 w3Ktj5gIozE460JD1dorUBbiVzKZV0lh/3xwJnc9MvDgqZUT3g
 FYY0FVJRz+F6NW1SsFEVm8QamLiyaB1BqlbHylI8IzWCNBi6yP
 EhrpFgG8LR+R27IBEJo/488vnJpnXzOIOSF0jBiQz
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EHCI host controller driver can be built standalone now,
without enabling any of the available bus glue drivers, so
there is not really a reason to error out here:

drivers/usb/host/ehci-hcd.c:1303:2: error:
 #error "missing bus glue for ehci-hcd"  #error "missing bus glue for ehci-hcd"

The alternative would be to change the Kconfig code to build
the ehci-hcd module only if any of the symbols below are
in fact enabled.

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/usb/host/ehci-hcd.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 312fc10..246e124 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -1286,23 +1286,6 @@ MODULE_LICENSE ("GPL");
 #define	PLATFORM_DRIVER		ehci_hcd_sead3_driver
 #endif
 
-#if !IS_ENABLED(CONFIG_USB_EHCI_PCI) && \
-	!IS_ENABLED(CONFIG_USB_EHCI_HCD_PLATFORM) && \
-	!IS_ENABLED(CONFIG_USB_CHIPIDEA_HOST) && \
-	!IS_ENABLED(CONFIG_USB_EHCI_MXC) && \
-	!IS_ENABLED(CONFIG_USB_EHCI_HCD_OMAP) && \
-	!IS_ENABLED(CONFIG_USB_EHCI_HCD_ORION) && \
-	!IS_ENABLED(CONFIG_USB_EHCI_HCD_SPEAR) && \
-	!IS_ENABLED(CONFIG_USB_EHCI_S5P) && \
-	!IS_ENABLED(CONFIG_USB_EHCI_HCD_AT91) && \
-	!IS_ENABLED(CONFIG_USB_EHCI_MSM) && \
-	!defined(PLATFORM_DRIVER) && \
-	!defined(PS3_SYSTEM_BUS_DRIVER) && \
-	!defined(OF_PLATFORM_DRIVER) && \
-	!defined(XILINX_OF_PLATFORM_DRIVER)
-#error "missing bus glue for ehci-hcd"
-#endif
-
 static int __init ehci_hcd_init(void)
 {
 	int retval = 0;
-- 
1.8.1.2

