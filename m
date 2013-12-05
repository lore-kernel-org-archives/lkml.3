Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab3LELZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 06:25:38 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:49723 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab3LELZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 06:25:36 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH] video: Replace local macro with PCI standard macro
Date: Thu, 5 Dec 2013 19:25:18 +0800
Message-ID: <1386242718-24372-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace local macro TGA_BUS_PCI with PCI standard
marco dev_is_pci().

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/video/tgafb.c |   16 +++++-----------
 1 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/video/tgafb.c b/drivers/video/tgafb.c
index f28674f..5e94c6e 100644
--- a/drivers/video/tgafb.c
+++ b/drivers/video/tgafb.c
@@ -32,12 +32,6 @@
 
 #include <video/tgafb.h>
 
-#ifdef CONFIG_PCI
-#define TGA_BUS_PCI(dev) (dev->bus == &pci_bus_type)
-#else
-#define TGA_BUS_PCI(dev) 0
-#endif
-
 #ifdef CONFIG_TC
 #define TGA_BUS_TC(dev) (dev->bus == &tc_bus_type)
 #else
@@ -236,7 +230,7 @@ tgafb_set_par(struct fb_info *info)
 	};
 
 	struct tga_par *par = (struct tga_par *) info->par;
-	int tga_bus_pci = TGA_BUS_PCI(par->dev);
+	int tga_bus_pci = dev_is_pci(par->dev);
 	int tga_bus_tc = TGA_BUS_TC(par->dev);
 	u32 htimings, vtimings, pll_freq;
 	u8 tga_type;
@@ -519,7 +513,7 @@ tgafb_setcolreg(unsigned regno, unsigned red, unsigned green, unsigned blue,
 		unsigned transp, struct fb_info *info)
 {
 	struct tga_par *par = (struct tga_par *) info->par;
-	int tga_bus_pci = TGA_BUS_PCI(par->dev);
+	int tga_bus_pci = dev_is_pci(par->dev);
 	int tga_bus_tc = TGA_BUS_TC(par->dev);
 
 	if (regno > 255)
@@ -1472,7 +1466,7 @@ static void
 tgafb_init_fix(struct fb_info *info)
 {
 	struct tga_par *par = (struct tga_par *)info->par;
-	int tga_bus_pci = TGA_BUS_PCI(par->dev);
+	int tga_bus_pci = dev_is_pci(par->dev);
 	int tga_bus_tc = TGA_BUS_TC(par->dev);
 	u8 tga_type = par->tga_type;
 	const char *tga_type_name = NULL;
@@ -1560,7 +1554,7 @@ static int tgafb_register(struct device *dev)
 	const struct fb_videomode *modedb_tga = NULL;
 	resource_size_t bar0_start = 0, bar0_len = 0;
 	const char *mode_option_tga = NULL;
-	int tga_bus_pci = TGA_BUS_PCI(dev);
+	int tga_bus_pci = dev_is_pci(dev);
 	int tga_bus_tc = TGA_BUS_TC(dev);
 	unsigned int modedbsize_tga = 0;
 	void __iomem *mem_base;
@@ -1690,7 +1684,7 @@ static int tgafb_register(struct device *dev)
 static void tgafb_unregister(struct device *dev)
 {
 	resource_size_t bar0_start = 0, bar0_len = 0;
-	int tga_bus_pci = TGA_BUS_PCI(dev);
+	int tga_bus_pci = dev_is_pci(dev);
 	int tga_bus_tc = TGA_BUS_TC(dev);
 	struct fb_info *info = NULL;
 	struct tga_par *par;
-- 
1.7.1


