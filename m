Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937583Ab3DKAPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 20:15:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60371 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936176Ab3DKAGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 20:06:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 10/30] usb: exynos: do not include plat/usb-phy.h
Date: Thu, 11 Apr 2013 02:04:52 +0200
Message-Id: <1365638712-1028578-11-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:GIO/GKPpWX/WbsJpvoBIPVPZ+XSbUFTMKbDQdKY+fR1
 jIBis9y4tIxHt6TuwJzXMbzt2DtvmZzzed24gwkyWcWeJGD+uV
 YL7QQ2jSafLFhMA990zi7xZjEnJ1nPIAmwY6iEgICo7wGtsHcI
 vELalqSCgt+LTxTuYEHksPXyaaUlfdYe0PNDujqtZEUF9JJ6wh
 otTEP83xPRqI6r7ZfWlBRZrcl/auG+jhssid5nZ7xbMhna+Jkh
 vkYpp1+y3PN75iItEMPkuioVyrku8zrIMWXibes91fdFKTPUkl
 rT035nUKiB3pzwno7U9byWMLcK6JzNe/JElG1JqIAmy0lV8/gn
 WMhRQ4+WYmhAqIOACEsqKFhCriGo4mnrXV/17t7hdekKC+v+ld
 IToQi1phcwYWg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The definitions have moved to include/linux/usb/samsung-usb-phy.h,
and plat/usb-phy.h is unavailable from drivers in a multiplatform
configuration.

Also fix up the plat/usb-phy.h header file to use the definitions
from the new header instead of providing a separate copy.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: linux-usb@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
---
 arch/arm/mach-exynos/setup-usb-phy.c         | 8 ++++----
 arch/arm/mach-s3c64xx/setup-usb-phy.c        | 4 ++--
 arch/arm/mach-s5pv210/setup-usb-phy.c        | 4 ++--
 arch/arm/plat-samsung/include/plat/usb-phy.h | 5 +----
 drivers/usb/host/ehci-s5p.c                  | 1 -
 drivers/usb/host/ohci-exynos.c               | 1 -
 6 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/arch/arm/mach-exynos/setup-usb-phy.c b/arch/arm/mach-exynos/setup-usb-phy.c
index b81cc56..6af4066 100644
--- a/arch/arm/mach-exynos/setup-usb-phy.c
+++ b/arch/arm/mach-exynos/setup-usb-phy.c
@@ -204,9 +204,9 @@ static int exynos4210_usb_phy1_exit(struct platform_device *pdev)
 
 int s5p_usb_phy_init(struct platform_device *pdev, int type)
 {
-	if (type == S5P_USB_PHY_DEVICE)
+	if (type == USB_PHY_TYPE_DEVICE)
 		return exynos4210_usb_phy0_init(pdev);
-	else if (type == S5P_USB_PHY_HOST)
+	else if (type == USB_PHY_TYPE_HOST)
 		return exynos4210_usb_phy1_init(pdev);
 
 	return -EINVAL;
@@ -214,9 +214,9 @@ int s5p_usb_phy_init(struct platform_device *pdev, int type)
 
 int s5p_usb_phy_exit(struct platform_device *pdev, int type)
 {
-	if (type == S5P_USB_PHY_DEVICE)
+	if (type == USB_PHY_TYPE_DEVICE)
 		return exynos4210_usb_phy0_exit(pdev);
-	else if (type == S5P_USB_PHY_HOST)
+	else if (type == USB_PHY_TYPE_HOST)
 		return exynos4210_usb_phy1_exit(pdev);
 
 	return -EINVAL;
diff --git a/arch/arm/mach-s3c64xx/setup-usb-phy.c b/arch/arm/mach-s3c64xx/setup-usb-phy.c
index c8174d9..ca960bd 100644
--- a/arch/arm/mach-s3c64xx/setup-usb-phy.c
+++ b/arch/arm/mach-s3c64xx/setup-usb-phy.c
@@ -76,7 +76,7 @@ static int s3c_usb_otgphy_exit(struct platform_device *pdev)
 
 int s5p_usb_phy_init(struct platform_device *pdev, int type)
 {
-	if (type == S5P_USB_PHY_DEVICE)
+	if (type == USB_PHY_TYPE_DEVICE)
 		return s3c_usb_otgphy_init(pdev);
 
 	return -EINVAL;
@@ -84,7 +84,7 @@ int s5p_usb_phy_init(struct platform_device *pdev, int type)
 
 int s5p_usb_phy_exit(struct platform_device *pdev, int type)
 {
-	if (type == S5P_USB_PHY_DEVICE)
+	if (type == USB_PHY_TYPE_DEVICE)
 		return s3c_usb_otgphy_exit(pdev);
 
 	return -EINVAL;
diff --git a/arch/arm/mach-s5pv210/setup-usb-phy.c b/arch/arm/mach-s5pv210/setup-usb-phy.c
index 356a090..b2ee533 100644
--- a/arch/arm/mach-s5pv210/setup-usb-phy.c
+++ b/arch/arm/mach-s5pv210/setup-usb-phy.c
@@ -80,7 +80,7 @@ static int s5pv210_usb_otgphy_exit(struct platform_device *pdev)
 
 int s5p_usb_phy_init(struct platform_device *pdev, int type)
 {
-	if (type == S5P_USB_PHY_DEVICE)
+	if (type == USB_PHY_TYPE_DEVICE)
 		return s5pv210_usb_otgphy_init(pdev);
 
 	return -EINVAL;
@@ -88,7 +88,7 @@ int s5p_usb_phy_init(struct platform_device *pdev, int type)
 
 int s5p_usb_phy_exit(struct platform_device *pdev, int type)
 {
-	if (type == S5P_USB_PHY_DEVICE)
+	if (type == USB_PHY_TYPE_DEVICE)
 		return s5pv210_usb_otgphy_exit(pdev);
 
 	return -EINVAL;
diff --git a/arch/arm/plat-samsung/include/plat/usb-phy.h b/arch/arm/plat-samsung/include/plat/usb-phy.h
index 959bcdb..ab34dfa 100644
--- a/arch/arm/plat-samsung/include/plat/usb-phy.h
+++ b/arch/arm/plat-samsung/include/plat/usb-phy.h
@@ -11,10 +11,7 @@
 #ifndef __PLAT_SAMSUNG_USB_PHY_H
 #define __PLAT_SAMSUNG_USB_PHY_H __FILE__
 
-enum s5p_usb_phy_type {
-	S5P_USB_PHY_DEVICE,
-	S5P_USB_PHY_HOST,
-};
+#include <linux/usb/samsung_usb_phy.h>
 
 extern int s5p_usb_phy_init(struct platform_device *pdev, int type);
 extern int s5p_usb_phy_exit(struct platform_device *pdev, int type);
diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
index 20ebf6a..7dc9c15 100644
--- a/drivers/usb/host/ehci-s5p.c
+++ b/drivers/usb/host/ehci-s5p.c
@@ -19,7 +19,6 @@
 #include <linux/platform_data/usb-ehci-s5p.h>
 #include <linux/usb/phy.h>
 #include <linux/usb/samsung_usb_phy.h>
-#include <plat/usb-phy.h>
 
 #define EHCI_INSNREG00(base)			(base + 0x90)
 #define EHCI_INSNREG00_ENA_INCR16		(0x1 << 25)
diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
index 0bd6f47..0792bfd 100644
--- a/drivers/usb/host/ohci-exynos.c
+++ b/drivers/usb/host/ohci-exynos.c
@@ -18,7 +18,6 @@
 #include <linux/usb/phy.h>
 #include <linux/usb/samsung_usb_phy.h>
 
-#include <plat/usb-phy.h>
 
 struct exynos_ohci_hcd {
 	struct device *dev;
-- 
1.8.1.2

