Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808Ab3EUCqx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 22:46:53 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:34828 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758758Ab3EUCnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 22:43:19 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <stern@rowland.harvard.edu>, <gregkh@linuxfoundation.org>, <balbi@ti.com>,
        <sarah.a.sharp@linux.intel.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <lizefan@huawei.com>,
        <libo.chen@huawei.com>
Subject: [PATCH 02/19] drivers/usb/host: add missing platform_driver owner
Date: Tue, 21 May 2013 10:42:07 +0800
Message-ID: <1369104127-6284-1-git-send-email-libo.chen@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set the owner of platform_driver, to ensure that the
caller of driver holds a module refernece

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/usb/host/ehci-atmel.c   |    1 +
 drivers/usb/host/ehci-msm.c     |    1 +
 drivers/usb/host/ehci-mv.c      |    1 +
 drivers/usb/host/ehci-mxc.c     |    1 +
 drivers/usb/host/ehci-omap.c    |    1 +
 drivers/usb/host/ehci-spear.c   |    1 +
 drivers/usb/host/isp1760-if.c   |    1 +
 drivers/usb/host/oxu210hp-hcd.c |    1 +
 drivers/usb/host/xhci-plat.c    |    1 +
 9 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/ehci-atmel.c b/drivers/usb/host/ehci-atmel.c
index 6642009..4fbb59b 100644
--- a/drivers/usb/host/ehci-atmel.c
+++ b/drivers/usb/host/ehci-atmel.c
@@ -182,6 +182,7 @@ static struct platform_driver ehci_atmel_driver = {
 	.shutdown	= usb_hcd_platform_shutdown,
 	.driver		= {
 		.name	= "atmel-ehci",
+		.owner	= THIS_MODULE,
 		.of_match_table	= of_match_ptr(atmel_ehci_dt_ids),
 	},
 };
diff --git a/drivers/usb/host/ehci-msm.c b/drivers/usb/host/ehci-msm.c
index 0f717dc..03e94d7 100644
--- a/drivers/usb/host/ehci-msm.c
+++ b/drivers/usb/host/ehci-msm.c
@@ -191,6 +191,7 @@ static struct platform_driver ehci_msm_driver = {
 	.remove	= ehci_msm_remove,
 	.driver = {
 		   .name = "msm_hsusb_host",
+		   .owner = THIS_MODULE,
 		   .pm = &ehci_msm_dev_pm_ops,
 	},
 };
diff --git a/drivers/usb/host/ehci-mv.c b/drivers/usb/host/ehci-mv.c
index 4020629..ba12653 100644
--- a/drivers/usb/host/ehci-mv.c
+++ b/drivers/usb/host/ehci-mv.c
@@ -335,6 +335,7 @@ static struct platform_driver ehci_mv_driver = {
 	.shutdown = mv_ehci_shutdown,
 	.driver = {
 		   .name = "mv-ehci",
+		   .owner = THIS_MODULE,
 		   .bus = &platform_bus_type,
 		   },
 	.id_table = ehci_id_table,
diff --git a/drivers/usb/host/ehci-mxc.c b/drivers/usb/host/ehci-mxc.c
index c369767..e9c9651 100644
--- a/drivers/usb/host/ehci-mxc.c
+++ b/drivers/usb/host/ehci-mxc.c
@@ -214,6 +214,7 @@ static struct platform_driver ehci_mxc_driver = {
 	.shutdown = ehci_mxc_drv_shutdown,
 	.driver = {
 		   .name = "mxc-ehci",
+		   .owner	= THIS_MODULE,
 	},
 };
 
diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index 3d1491b..f630e62 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -294,6 +294,7 @@ static struct platform_driver ehci_hcd_omap_driver = {
 	/*.resume		= ehci_hcd_omap_resume, */
 	.driver = {
 		.name		= hcd_name,
+		.owner	= THIS_MODULE,
 		.of_match_table = of_match_ptr(omap_ehci_dt_ids),
 	}
 };
diff --git a/drivers/usb/host/ehci-spear.c b/drivers/usb/host/ehci-spear.c
index 61ecfb3..2df73be 100644
--- a/drivers/usb/host/ehci-spear.c
+++ b/drivers/usb/host/ehci-spear.c
@@ -172,6 +172,7 @@ static struct platform_driver spear_ehci_hcd_driver = {
 	.shutdown	= usb_hcd_platform_shutdown,
 	.driver		= {
 		.name = "spear-ehci",
+		.owner	= THIS_MODULE,
 		.bus = &platform_bus_type,
 		.pm = &ehci_spear_pm_ops,
 		.of_match_table = of_match_ptr(spear_ehci_id_table),
diff --git a/drivers/usb/host/isp1760-if.c b/drivers/usb/host/isp1760-if.c
index bbb791b..9c572da 100644
--- a/drivers/usb/host/isp1760-if.c
+++ b/drivers/usb/host/isp1760-if.c
@@ -435,6 +435,7 @@ static struct platform_driver isp1760_plat_driver = {
 	.remove	= isp1760_plat_remove,
 	.driver	= {
 		.name	= "isp1760",
+		.owner	= THIS_MODULE,
 	},
 };
 
diff --git a/drivers/usb/host/oxu210hp-hcd.c b/drivers/usb/host/oxu210hp-hcd.c
index 4f0f033..c5e1d1f 100644
--- a/drivers/usb/host/oxu210hp-hcd.c
+++ b/drivers/usb/host/oxu210hp-hcd.c
@@ -3947,6 +3947,7 @@ static struct platform_driver oxu_driver = {
 	.resume		= oxu_drv_resume,
 	.driver = {
 		.name = "oxu210hp-hcd",
+		.owner	= THIS_MODULE,
 		.bus = &platform_bus_type
 	}
 };
diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index df90fe5..34a6067 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -190,6 +190,7 @@ static struct platform_driver usb_xhci_driver = {
 	.remove	= xhci_plat_remove,
 	.driver	= {
 		.name = "xhci-hcd",
+		.owner	= THIS_MODULE,
 	},
 };
 MODULE_ALIAS("platform:xhci-hcd");
-- 
1.7.1


