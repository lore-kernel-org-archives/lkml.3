Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab3I3NFv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:05:51 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:10896 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab3I3NFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:05:47 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-a7-524977242329
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] ARM: omap1: fix incorrect placement of __initdata tag
Date: Mon, 30 Sep 2013 15:05:25 +0200
Message-id: <1861324.5ZgdrbcBQI@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t9jAV2Vcs8gg++t2hZnm96wW2x6fI3V
	4vKuOWwWs5f0s1jsv+LlwOrx7eskFo/NS+o9+rasYvT4vEkugCWKyyYlNSezLLVI3y6BK2Px
	9W9sBR+CKo50v2RvYLzp3MXIySEhYCJx9/5hZghbTOLCvfVsXYxcHEICixglds+fzA7htDBJ
	3P9wlhGkik3ASmJi+yogm4NDREBF4u5Le5AaZoF+Roltky+ygdQIC7hJHGm9ygpiswioSsz+
	sooJxOYV0JTY/70HLC4q4CnxadJSZoi4oMSPyfdYQGxmAXmJffunskLYWhLrdx5nmsDINwtJ
	2SwkZbOQlC1gZF7FKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERyUz6R3MK5qsDjEKMDBqMTD
	a7HUI0iINbGsuDL3EKMEB7OSCK94mWeQEG9KYmVValF+fFFpTmrxIUZpDhYlcd6DrdaBQgLp
	iSWp2ampBalFMFkmDk6pBsapHAdLZvaumS6yOV/4W9kFjjxbttO/Hsrt+S8S5JV5Mbn7NLvl
	/eK3s4NXmF80kVjsWK1k6Hy4R7ikVuhL5Xkhx8/aPg3Lfj1tqhKbsaGu0s1jhvHnqN/P/+/U
	iX9iyc9RpHgg5G+68guWIzta1nbEaP2fZzjJTKDzzvn3lz4rPCu3/dwZ4qvEUpyRaKjFXFSc
	CAARyVwwRgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__initdata tag should be placed between the variable name and equal
sign for the variable to be placed in the intended .init.data section.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-omap1/gpio15xx.c |  8 ++++----
 arch/arm/mach-omap1/gpio16xx.c | 22 +++++++++++-----------
 arch/arm/mach-omap1/gpio7xx.c  | 30 +++++++++++++++---------------
 3 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/arch/arm/mach-omap1/gpio15xx.c b/arch/arm/mach-omap1/gpio15xx.c
index 02b3eb2..420e94b 100644
--- a/arch/arm/mach-omap1/gpio15xx.c
+++ b/arch/arm/mach-omap1/gpio15xx.c
@@ -25,7 +25,7 @@
 #define OMAP1510_GPIO_BASE		0xFFFCE000
 
 /* gpio1 */
-static struct __initdata resource omap15xx_mpu_gpio_resources[] = {
+static struct resource omap15xx_mpu_gpio_resources[] __initdata = {
 	{
 		.start	= OMAP1_MPUIO_VBASE,
 		.end	= OMAP1_MPUIO_VBASE + SZ_2K - 1,
@@ -48,7 +48,7 @@ static struct omap_gpio_reg_offs omap15xx_mpuio_regs = {
 	.irqctrl	= OMAP_MPUIO_GPIO_INT_EDGE,
 };
 
-static struct __initdata omap_gpio_platform_data omap15xx_mpu_gpio_config = {
+static struct omap_gpio_platform_data omap15xx_mpu_gpio_config __initdata = {
 	.is_mpuio		= true,
 	.bank_width		= 16,
 	.bank_stride		= 1,
@@ -66,7 +66,7 @@ static struct platform_device omap15xx_mpu_gpio = {
 };
 
 /* gpio2 */
-static struct __initdata resource omap15xx_gpio_resources[] = {
+static struct resource omap15xx_gpio_resources[] __initdata = {
 	{
 		.start	= OMAP1510_GPIO_BASE,
 		.end	= OMAP1510_GPIO_BASE + SZ_2K - 1,
@@ -90,7 +90,7 @@ static struct omap_gpio_reg_offs omap15xx_gpio_regs = {
 	.pinctrl	= OMAP1510_GPIO_PIN_CONTROL,
 };
 
-static struct __initdata omap_gpio_platform_data omap15xx_gpio_config = {
+static struct omap_gpio_platform_data omap15xx_gpio_config __initdata = {
 	.bank_width		= 16,
 	.regs                   = &omap15xx_gpio_regs,
 };
diff --git a/arch/arm/mach-omap1/gpio16xx.c b/arch/arm/mach-omap1/gpio16xx.c
index b9952a2..16e7fcf 100644
--- a/arch/arm/mach-omap1/gpio16xx.c
+++ b/arch/arm/mach-omap1/gpio16xx.c
@@ -31,7 +31,7 @@
 #define SYSCONFIG_WORD			0x14
 
 /* mpu gpio */
-static struct __initdata resource omap16xx_mpu_gpio_resources[] = {
+static struct resource omap16xx_mpu_gpio_resources[] __initdata = {
 	{
 		.start	= OMAP1_MPUIO_VBASE,
 		.end	= OMAP1_MPUIO_VBASE + SZ_2K - 1,
@@ -54,7 +54,7 @@ static struct omap_gpio_reg_offs omap16xx_mpuio_regs = {
 	.irqctrl	= OMAP_MPUIO_GPIO_INT_EDGE,
 };
 
-static struct __initdata omap_gpio_platform_data omap16xx_mpu_gpio_config = {
+static struct omap_gpio_platform_data omap16xx_mpu_gpio_config __initdata = {
 	.is_mpuio		= true,
 	.bank_width		= 16,
 	.bank_stride		= 1,
@@ -72,7 +72,7 @@ static struct platform_device omap16xx_mpu_gpio = {
 };
 
 /* gpio1 */
-static struct __initdata resource omap16xx_gpio1_resources[] = {
+static struct resource omap16xx_gpio1_resources[] __initdata = {
 	{
 		.start	= OMAP1610_GPIO1_BASE,
 		.end	= OMAP1610_GPIO1_BASE + SZ_2K - 1,
@@ -100,7 +100,7 @@ static struct omap_gpio_reg_offs omap16xx_gpio_regs = {
 	.edgectrl2	= OMAP1610_GPIO_EDGE_CTRL2,
 };
 
-static struct __initdata omap_gpio_platform_data omap16xx_gpio1_config = {
+static struct omap_gpio_platform_data omap16xx_gpio1_config __initdata = {
 	.bank_width		= 16,
 	.regs                   = &omap16xx_gpio_regs,
 };
@@ -116,7 +116,7 @@ static struct platform_device omap16xx_gpio1 = {
 };
 
 /* gpio2 */
-static struct __initdata resource omap16xx_gpio2_resources[] = {
+static struct resource omap16xx_gpio2_resources[] __initdata = {
 	{
 		.start	= OMAP1610_GPIO2_BASE,
 		.end	= OMAP1610_GPIO2_BASE + SZ_2K - 1,
@@ -128,7 +128,7 @@ static struct __initdata resource omap16xx_gpio2_resources[] = {
 	},
 };
 
-static struct __initdata omap_gpio_platform_data omap16xx_gpio2_config = {
+static struct omap_gpio_platform_data omap16xx_gpio2_config __initdata = {
 	.bank_width		= 16,
 	.regs                   = &omap16xx_gpio_regs,
 };
@@ -144,7 +144,7 @@ static struct platform_device omap16xx_gpio2 = {
 };
 
 /* gpio3 */
-static struct __initdata resource omap16xx_gpio3_resources[] = {
+static struct resource omap16xx_gpio3_resources[] __initdata = {
 	{
 		.start	= OMAP1610_GPIO3_BASE,
 		.end	= OMAP1610_GPIO3_BASE + SZ_2K - 1,
@@ -156,7 +156,7 @@ static struct __initdata resource omap16xx_gpio3_resources[] = {
 	},
 };
 
-static struct __initdata omap_gpio_platform_data omap16xx_gpio3_config = {
+static struct omap_gpio_platform_data omap16xx_gpio3_config __initdata = {
 	.bank_width		= 16,
 	.regs                   = &omap16xx_gpio_regs,
 };
@@ -172,7 +172,7 @@ static struct platform_device omap16xx_gpio3 = {
 };
 
 /* gpio4 */
-static struct __initdata resource omap16xx_gpio4_resources[] = {
+static struct resource omap16xx_gpio4_resources[] __initdata = {
 	{
 		.start	= OMAP1610_GPIO4_BASE,
 		.end	= OMAP1610_GPIO4_BASE + SZ_2K - 1,
@@ -184,7 +184,7 @@ static struct __initdata resource omap16xx_gpio4_resources[] = {
 	},
 };
 
-static struct __initdata omap_gpio_platform_data omap16xx_gpio4_config = {
+static struct omap_gpio_platform_data omap16xx_gpio4_config __initdata = {
 	.bank_width		= 16,
 	.regs                   = &omap16xx_gpio_regs,
 };
@@ -199,7 +199,7 @@ static struct platform_device omap16xx_gpio4 = {
 	.resource = omap16xx_gpio4_resources,
 };
 
-static struct __initdata platform_device * omap16xx_gpio_dev[] = {
+static struct platform_device *omap16xx_gpio_dev[] __initdata = {
 	&omap16xx_mpu_gpio,
 	&omap16xx_gpio1,
 	&omap16xx_gpio2,
diff --git a/arch/arm/mach-omap1/gpio7xx.c b/arch/arm/mach-omap1/gpio7xx.c
index f5819b2..8136fdc 100644
--- a/arch/arm/mach-omap1/gpio7xx.c
+++ b/arch/arm/mach-omap1/gpio7xx.c
@@ -30,7 +30,7 @@
 #define OMAP1_MPUIO_VBASE		OMAP1_MPUIO_BASE
 
 /* mpu gpio */
-static struct __initdata resource omap7xx_mpu_gpio_resources[] = {
+static struct resource omap7xx_mpu_gpio_resources[] __initdata = {
 	{
 		.start	= OMAP1_MPUIO_VBASE,
 		.end	= OMAP1_MPUIO_VBASE + SZ_2K - 1,
@@ -53,7 +53,7 @@ static struct omap_gpio_reg_offs omap7xx_mpuio_regs = {
 	.irqctrl	= OMAP_MPUIO_GPIO_INT_EDGE >> 1,
 };
 
-static struct __initdata omap_gpio_platform_data omap7xx_mpu_gpio_config = {
+static struct omap_gpio_platform_data omap7xx_mpu_gpio_config __initdata = {
 	.is_mpuio		= true,
 	.bank_width		= 16,
 	.bank_stride		= 2,
@@ -71,7 +71,7 @@ static struct platform_device omap7xx_mpu_gpio = {
 };
 
 /* gpio1 */
-static struct __initdata resource omap7xx_gpio1_resources[] = {
+static struct resource omap7xx_gpio1_resources[] __initdata = {
 	{
 		.start	= OMAP7XX_GPIO1_BASE,
 		.end	= OMAP7XX_GPIO1_BASE + SZ_2K - 1,
@@ -94,7 +94,7 @@ static struct omap_gpio_reg_offs omap7xx_gpio_regs = {
 	.irqctrl	= OMAP7XX_GPIO_INT_CONTROL,
 };
 
-static struct __initdata omap_gpio_platform_data omap7xx_gpio1_config = {
+static struct omap_gpio_platform_data omap7xx_gpio1_config __initdata = {
 	.bank_width		= 32,
 	.regs			= &omap7xx_gpio_regs,
 };
@@ -110,7 +110,7 @@ static struct platform_device omap7xx_gpio1 = {
 };
 
 /* gpio2 */
-static struct __initdata resource omap7xx_gpio2_resources[] = {
+static struct resource omap7xx_gpio2_resources[] __initdata = {
 	{
 		.start	= OMAP7XX_GPIO2_BASE,
 		.end	= OMAP7XX_GPIO2_BASE + SZ_2K - 1,
@@ -122,7 +122,7 @@ static struct __initdata resource omap7xx_gpio2_resources[] = {
 	},
 };
 
-static struct __initdata omap_gpio_platform_data omap7xx_gpio2_config = {
+static struct omap_gpio_platform_data omap7xx_gpio2_config __initdata = {
 	.bank_width		= 32,
 	.regs			= &omap7xx_gpio_regs,
 };
@@ -138,7 +138,7 @@ static struct platform_device omap7xx_gpio2 = {
 };
 
 /* gpio3 */
-static struct __initdata resource omap7xx_gpio3_resources[] = {
+static struct resource omap7xx_gpio3_resources[] __initdata = {
 	{
 		.start	= OMAP7XX_GPIO3_BASE,
 		.end	= OMAP7XX_GPIO3_BASE + SZ_2K - 1,
@@ -150,7 +150,7 @@ static struct __initdata resource omap7xx_gpio3_resources[] = {
 	},
 };
 
-static struct __initdata omap_gpio_platform_data omap7xx_gpio3_config = {
+static struct omap_gpio_platform_data omap7xx_gpio3_config __initdata = {
 	.bank_width		= 32,
 	.regs			= &omap7xx_gpio_regs,
 };
@@ -166,7 +166,7 @@ static struct platform_device omap7xx_gpio3 = {
 };
 
 /* gpio4 */
-static struct __initdata resource omap7xx_gpio4_resources[] = {
+static struct resource omap7xx_gpio4_resources[] __initdata = {
 	{
 		.start	= OMAP7XX_GPIO4_BASE,
 		.end	= OMAP7XX_GPIO4_BASE + SZ_2K - 1,
@@ -178,7 +178,7 @@ static struct __initdata resource omap7xx_gpio4_resources[] = {
 	},
 };
 
-static struct __initdata omap_gpio_platform_data omap7xx_gpio4_config = {
+static struct omap_gpio_platform_data omap7xx_gpio4_config __initdata = {
 	.bank_width		= 32,
 	.regs			= &omap7xx_gpio_regs,
 };
@@ -194,7 +194,7 @@ static struct platform_device omap7xx_gpio4 = {
 };
 
 /* gpio5 */
-static struct __initdata resource omap7xx_gpio5_resources[] = {
+static struct resource omap7xx_gpio5_resources[] __initdata = {
 	{
 		.start	= OMAP7XX_GPIO5_BASE,
 		.end	= OMAP7XX_GPIO5_BASE + SZ_2K - 1,
@@ -206,7 +206,7 @@ static struct __initdata resource omap7xx_gpio5_resources[] = {
 	},
 };
 
-static struct __initdata omap_gpio_platform_data omap7xx_gpio5_config = {
+static struct omap_gpio_platform_data omap7xx_gpio5_config __initdata = {
 	.bank_width		= 32,
 	.regs			= &omap7xx_gpio_regs,
 };
@@ -222,7 +222,7 @@ static struct platform_device omap7xx_gpio5 = {
 };
 
 /* gpio6 */
-static struct __initdata resource omap7xx_gpio6_resources[] = {
+static struct resource omap7xx_gpio6_resources[] __initdata = {
 	{
 		.start	= OMAP7XX_GPIO6_BASE,
 		.end	= OMAP7XX_GPIO6_BASE + SZ_2K - 1,
@@ -234,7 +234,7 @@ static struct __initdata resource omap7xx_gpio6_resources[] = {
 	},
 };
 
-static struct __initdata omap_gpio_platform_data omap7xx_gpio6_config = {
+static struct omap_gpio_platform_data omap7xx_gpio6_config __initdata = {
 	.bank_width		= 32,
 	.regs			= &omap7xx_gpio_regs,
 };
@@ -249,7 +249,7 @@ static struct platform_device omap7xx_gpio6 = {
 	.resource = omap7xx_gpio6_resources,
 };
 
-static struct __initdata platform_device * omap7xx_gpio_dev[] = {
+static struct platform_device *omap7xx_gpio_dev[] __initdata = {
 	&omap7xx_mpu_gpio,
 	&omap7xx_gpio1,
 	&omap7xx_gpio2,
-- 
1.8.2.3


