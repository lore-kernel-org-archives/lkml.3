Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbaETLmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 07:42:07 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:58208 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751161AbaETLmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 07:42:05 -0400
Message-ID: <1400586123.4912.40.camel@x220>
Subject: [PATCH] MIPS: PNX833x: remove checks for CONFIG_I2C_PNX0105
From: Paul Bolle <pebolle@tiscali.nl>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Date: Tue, 20 May 2014 13:42:03 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 May 2014 11:42:03.0884 (UTC) FILETIME=[85289AC0:01CF7420]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checks for CONFIG_I2C_PNX0105 were added in v2.6.28. But the related
Kconfig symbol has not been added to the tree. Remove these checks.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

Note that there's no i2c-pnx0105.h in the tree.

 arch/mips/pnx833x/common/platform.c | 73 -------------------------------------
 1 file changed, 73 deletions(-)

diff --git a/arch/mips/pnx833x/common/platform.c b/arch/mips/pnx833x/common/platform.c
index 2b7e837dc2e2..b4b774bc3178 100644
--- a/arch/mips/pnx833x/common/platform.c
+++ b/arch/mips/pnx833x/common/platform.c
@@ -33,11 +33,6 @@
 #include <linux/mtd/nand.h>
 #include <linux/mtd/partitions.h>
 
-#ifdef CONFIG_I2C_PNX0105
-/* Until i2c driver available in kernel.*/
-#include <linux/i2c-pnx0105.h>
-#endif
-
 #include <irq.h>
 #include <irq-mapping.h>
 #include <pnx833x.h>
@@ -134,70 +129,6 @@ static struct platform_device pnx833x_usb_ehci_device = {
 	.resource	= pnx833x_usb_ehci_resources,
 };
 
-#ifdef CONFIG_I2C_PNX0105
-static struct resource pnx833x_i2c0_resources[] = {
-	{
-		.start		= PNX833X_I2C0_PORTS_START,
-		.end		= PNX833X_I2C0_PORTS_END,
-		.flags		= IORESOURCE_MEM,
-	},
-	{
-		.start		= PNX833X_PIC_I2C0_INT,
-		.end		= PNX833X_PIC_I2C0_INT,
-		.flags		= IORESOURCE_IRQ,
-	},
-};
-
-static struct resource pnx833x_i2c1_resources[] = {
-	{
-		.start		= PNX833X_I2C1_PORTS_START,
-		.end		= PNX833X_I2C1_PORTS_END,
-		.flags		= IORESOURCE_MEM,
-	},
-	{
-		.start		= PNX833X_PIC_I2C1_INT,
-		.end		= PNX833X_PIC_I2C1_INT,
-		.flags		= IORESOURCE_IRQ,
-	},
-};
-
-static struct i2c_pnx0105_dev pnx833x_i2c_dev[] = {
-	{
-		.base = PNX833X_I2C0_PORTS_START,
-		.irq = -1, /* should be PNX833X_PIC_I2C0_INT but polling is faster */
-		.clock = 6,	/* 0 == 400 kHz, 4 == 100 kHz(Maximum HDMI), 6 = 50kHz(Preferred HDCP) */
-		.bus_addr = 0,	/* no slave support */
-	},
-	{
-		.base = PNX833X_I2C1_PORTS_START,
-		.irq = -1,	/* on high freq, polling is faster */
-		/*.irq = PNX833X_PIC_I2C1_INT,*/
-		.clock = 4,	/* 0 == 400 kHz, 4 == 100 kHz. 100 kHz seems a safe default for now */
-		.bus_addr = 0,	/* no slave support */
-	},
-};
-
-static struct platform_device pnx833x_i2c0_device = {
-	.name		= "i2c-pnx0105",
-	.id		= 0,
-	.dev = {
-		.platform_data = &pnx833x_i2c_dev[0],
-	},
-	.num_resources	= ARRAY_SIZE(pnx833x_i2c0_resources),
-	.resource	= pnx833x_i2c0_resources,
-};
-
-static struct platform_device pnx833x_i2c1_device = {
-	.name		= "i2c-pnx0105",
-	.id		= 1,
-	.dev = {
-		.platform_data = &pnx833x_i2c_dev[1],
-	},
-	.num_resources	= ARRAY_SIZE(pnx833x_i2c1_resources),
-	.resource	= pnx833x_i2c1_resources,
-};
-#endif
-
 static u64 ethernet_dmamask = DMA_BIT_MASK(32);
 
 static struct resource pnx833x_ethernet_resources[] = {
@@ -294,10 +225,6 @@ static struct platform_device pnx833x_flash_nand = {
 static struct platform_device *pnx833x_platform_devices[] __initdata = {
 	&pnx833x_uart_device,
 	&pnx833x_usb_ehci_device,
-#ifdef CONFIG_I2C_PNX0105
-	&pnx833x_i2c0_device,
-	&pnx833x_i2c1_device,
-#endif
 	&pnx833x_ethernet_device,
 	&pnx833x_sata_device,
 	&pnx833x_flash_nand,
-- 
1.9.0

