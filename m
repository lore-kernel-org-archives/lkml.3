Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934419AbaHZMP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 08:15:27 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:30501 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829AbaHZMN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 08:13:57 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-0a-53fc7a01ab2a
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Grant Likely <grant.likely@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Laura Abbott <lauraa@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 6/7] ARM: Exynos: convert MFC to generic reserved memory
 bindings
Date: Tue, 26 Aug 2014 14:09:47 +0200
Message-id: <1409054988-32758-7-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1409054988-32758-1-git-send-email-m.szyprowski@samsung.com>
References: <1409054988-32758-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNLMWRmVeSWpSXmKPExsVy+t/xa7qMVX+CDf7M1rP4O+kYu8WBPzsY
	LVZ2N7NZ7Fz3jtHibNMbdovtnTPYLb5cechksenxNVaLy7vmsFn0bNjKajHj/D4mi7VH7rJb
	LDjewmqxfsZrFgc+j9+/JjF6XO7rZfLoenuFyePOtT1sHpuX1Hvc/veY2WPdn1dMHn1bVjF6
	fN4kF8AZxWWTkpqTWZZapG+XwJWx5sVltoKO+oruLU/ZGhi3pXUxcnJICJhItP36zgxhi0lc
	uLeerYuRi0NIYCmjxKONj6CcPiaJTTdPM4JUsQkYSnS97WIDsUUEsiV+fJvMAmIzCyxllpg3
	SwrEFhYIlnh5uAVsKouAqsTPjQ/A6nkFPCQuN29kgtgmJ/H/5Qogm4ODU8BT4tyUapCwEFDJ
	xunvWSYw8i5gZFjFKJpamlxQnJSea6RXnJhbXJqXrpecn7uJERLAX3cwLj1mdYhRgINRiYf3
	QdrvYCHWxLLiytxDjBIczEoivD+S/gQL8aYkVlalFuXHF5XmpBYfYmTi4JRqYBQR5VgQGbOI
	cY79Zvl0vaP7xed9EZKybFutvExwufsr69zbwgf2eK7/JOEm75iUHOVcueVUseQXocd22Sym
	4eKpq0LT3XorS3727q/8P/VCxuYsp0t7k/PXFxo4nvNNepz2NdD52DULBuFVb0zsRJeK3029
	E3xeoKbwWtusc5eVb7PPatTbosRSnJFoqMVcVJwIAO+FW4A+AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for reserved memory for MFC device (samsung,mfc-r and samsung,mfc-l properties) was merged quickly without any deep review and discussion. This patch replaces those custom properties with support for
generic reserved memory bindings. All custom code for handling MFC-specific
reserved memory can be now removed.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 .../devicetree/bindings/media/s5p-mfc.txt          | 16 ++--
 arch/arm/boot/dts/exynos4210-origen.dts            | 22 ++++-
 arch/arm/boot/dts/exynos4210-smdkv310.dts          | 22 ++++-
 arch/arm/boot/dts/exynos4412-origen.dts            | 22 ++++-
 arch/arm/boot/dts/exynos4412-smdk4412.dts          | 22 ++++-
 arch/arm/boot/dts/exynos5250-arndale.dts           | 22 ++++-
 arch/arm/boot/dts/exynos5250-smdk5250.dts          | 22 ++++-
 arch/arm/boot/dts/exynos5420-arndale-octa.dts      | 22 ++++-
 arch/arm/boot/dts/exynos5420-smdk5420.dts          | 22 ++++-
 arch/arm/mach-exynos/exynos.c                      | 18 -----
 arch/arm/mach-exynos/mfc.h                         | 16 ----
 arch/arm/plat-samsung/Kconfig                      |  5 --
 arch/arm/plat-samsung/Makefile                     |  1 -
 arch/arm/plat-samsung/s5p-dev-mfc.c                | 94 ----------------------
 14 files changed, 168 insertions(+), 158 deletions(-)
 delete mode 100644 arch/arm/mach-exynos/mfc.h
 delete mode 100644 arch/arm/plat-samsung/s5p-dev-mfc.c

diff --git a/Documentation/devicetree/bindings/media/s5p-mfc.txt b/Documentation/devicetree/bindings/media/s5p-mfc.txt
index 3e3c5f349570..468e991b322c 100644
--- a/Documentation/devicetree/bindings/media/s5p-mfc.txt
+++ b/Documentation/devicetree/bindings/media/s5p-mfc.txt
@@ -21,16 +21,16 @@ Required properties:
   - clock-names : from common clock binding: must contain "mfc",
 		  corresponding to entry in the clocks property.
 
-  - samsung,mfc-r : Base address of the first memory bank used by MFC
-		    for DMA contiguous memory allocation and its size.
-
-  - samsung,mfc-l : Base address of the second memory bank used by MFC
-		    for DMA contiguous memory allocation and its size.
-
 Optional properties:
   - samsung,power-domain : power-domain property defined with a phandle
 			   to respective power domain.
 
+  - memory-region : from reserved memory binding: phandles to two reserved
+	memory regions: accessed by "left" and "right" mfc memory bus
+	interfaces, used when no SYSMMU support is available
+  - memory-region-names : from reserved memory binding: must be "left"
+	and "right"
+
 Example:
 SoC specific DT entry:
 
@@ -46,6 +46,6 @@ mfc: codec@13400000 {
 Board specific DT entry:
 
 codec@13400000 {
-	samsung,mfc-r = <0x43000000 0x800000>;
-	samsung,mfc-l = <0x51000000 0x800000>;
+	memory-region = <&mfc_left>, <&mfc_right>;
+	memory-region-names = "left", "right";
 };
diff --git a/arch/arm/boot/dts/exynos4210-origen.dts b/arch/arm/boot/dts/exynos4210-origen.dts
index f767c425d0b5..face32952a36 100644
--- a/arch/arm/boot/dts/exynos4210-origen.dts
+++ b/arch/arm/boot/dts/exynos4210-origen.dts
@@ -29,6 +29,24 @@
 		       0x70000000 0x10000000>;
 	};
 
+	reserved-memory {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		mfc_left: region@51000000 {
+			compatible = "shared-dma-pool";
+			no-map;
+			reg = <0x51000000 0x800000>;
+		};
+
+		mfc_right: region@43000000 {
+			compatible = "shared-dma-pool";
+			no-map;
+			reg = <0x43000000 0x800000>;
+		};
+	};
+
 	chosen {
 		bootargs ="root=/dev/ram0 rw ramdisk=8192 initrd=0x41000000,8M console=ttySAC2,115200 init=/linuxrc";
 	};
@@ -82,8 +100,8 @@
 	};
 
 	codec@13400000 {
-		samsung,mfc-r = <0x43000000 0x800000>;
-		samsung,mfc-l = <0x51000000 0x800000>;
+		memory-region = <&mfc_left>, <&mfc_right>;
+		memory-region-names = "left", "right";
 		status = "okay";
 	};
 
diff --git a/arch/arm/boot/dts/exynos4210-smdkv310.dts b/arch/arm/boot/dts/exynos4210-smdkv310.dts
index 676e6e0c8cf3..292f2188d7b6 100644
--- a/arch/arm/boot/dts/exynos4210-smdkv310.dts
+++ b/arch/arm/boot/dts/exynos4210-smdkv310.dts
@@ -25,6 +25,24 @@
 		reg = <0x40000000 0x80000000>;
 	};
 
+	reserved-memory {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		mfc_left: region@51000000 {
+			compatible = "shared-dma-pool";
+			no-map;
+			reg = <0x51000000 0x800000>;
+		};
+
+		mfc_right: region@43000000 {
+			compatible = "shared-dma-pool";
+			no-map;
+			reg = <0x43000000 0x800000>;
+		};
+	};
+
 	chosen {
 		bootargs = "root=/dev/ram0 rw ramdisk=8192 initrd=0x41000000,8M console=ttySAC1,115200 init=/linuxrc";
 	};
@@ -41,8 +59,8 @@
 	};
 
 	codec@13400000 {
-		samsung,mfc-r = <0x43000000 0x800000>;
-		samsung,mfc-l = <0x51000000 0x800000>;
+		memory-region = <&mfc_left>, <&mfc_right>;
+		memory-region-names = "left", "right";
 		status = "okay";
 	};
 
diff --git a/arch/arm/boot/dts/exynos4412-origen.dts b/arch/arm/boot/dts/exynos4412-origen.dts
index e925c9fbfb07..d007b186c722 100644
--- a/arch/arm/boot/dts/exynos4412-origen.dts
+++ b/arch/arm/boot/dts/exynos4412-origen.dts
@@ -24,6 +24,24 @@
 		reg = <0x40000000 0x40000000>;
 	};
 
+	reserved-memory {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		mfc_left: region@51000000 {
+			compatible = "shared-dma-pool";
+			no-map;
+			reg = <0x51000000 0x800000>;
+		};
+
+		mfc_right: region@43000000 {
+			compatible = "shared-dma-pool";
+			no-map;
+			reg = <0x43000000 0x800000>;
+		};
+	};
+
 	chosen {
 		bootargs ="console=ttySAC2,115200";
 	};
@@ -151,8 +169,8 @@
 	};
 
 	codec@13400000 {
-		samsung,mfc-r = <0x43000000 0x800000>;
-		samsung,mfc-l = <0x51000000 0x800000>;
+		memory-region = <&mfc_left>, <&mfc_right>;
+		memory-region-names = "left", "right";
 		status = "okay";
 	};
 
diff --git a/arch/arm/boot/dts/exynos4412-smdk4412.dts b/arch/arm/boot/dts/exynos4412-smdk4412.dts
index ded0b70f7644..a1a25d2c999b 100644
--- a/arch/arm/boot/dts/exynos4412-smdk4412.dts
+++ b/arch/arm/boot/dts/exynos4412-smdk4412.dts
@@ -23,6 +23,24 @@
 		reg = <0x40000000 0x40000000>;
 	};
 
+	reserved-memory {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		mfc_left: region@51000000 {
+			compatible = "shared-dma-pool";
+			no-map;
+			reg = <0x51000000 0x800000>;
+		};
+
+		mfc_right: region@43000000 {
+			compatible = "shared-dma-pool";
+			no-map;
+			reg = <0x43000000 0x800000>;
+		};
+	};
+
 	chosen {
 		bootargs ="root=/dev/ram0 rw ramdisk=8192 initrd=0x41000000,8M console=ttySAC1,115200 init=/linuxrc";
 	};
@@ -126,8 +144,8 @@
 	};
 
 	codec@13400000 {
-		samsung,mfc-r = <0x43000000 0x800000>;
-		samsung,mfc-l = <0x51000000 0x800000>;
+		memory-region = <&mfc_left>, <&mfc_right>;
+		memory-region-names = "left", "right";
 		status = "okay";
 	};
 
diff --git a/arch/arm/boot/dts/exynos5250-arndale.dts b/arch/arm/boot/dts/exynos5250-arndale.dts
index d0de1f50d15b..c444b6a7cd47 100644
--- a/arch/arm/boot/dts/exynos5250-arndale.dts
+++ b/arch/arm/boot/dts/exynos5250-arndale.dts
@@ -22,6 +22,24 @@
 		reg = <0x40000000 0x80000000>;
 	};
 
+	reserved-memory {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		mfc_left: region@51000000 {
+			compatible = "shared-dma-pool";
+			no-map;
+			reg = <0x51000000 0x800000>;
+		};
+
+		mfc_right: region@43000000 {
+			compatible = "shared-dma-pool";
+			no-map;
+			reg = <0x43000000 0x800000>;
+		};
+	};
+
 	chosen {
 		bootargs = "console=ttySAC2,115200";
 	};
@@ -31,8 +49,8 @@
 	};
 
 	codec@11000000 {
-		samsung,mfc-r = <0x43000000 0x800000>;
-		samsung,mfc-l = <0x51000000 0x800000>;
+		memory-region = <&mfc_left>, <&mfc_right>;
+		memory-region-names = "left", "right";
 	};
 
 	i2c@12C60000 {
diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
index b4b35adae565..f22e3c884449 100644
--- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
+++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
@@ -23,6 +23,24 @@
 		reg = <0x40000000 0x80000000>;
 	};
 
+	reserved-memory {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		mfc_left: region@51000000 {
+			compatible = "shared-dma-pool";
+			no-map;
+			reg = <0x51000000 0x800000>;
+		};
+
+		mfc_right: region@43000000 {
+			compatible = "shared-dma-pool";
+			no-map;
+			reg = <0x43000000 0x800000>;
+		};
+	};
+
 	chosen {
 		bootargs = "root=/dev/ram0 rw ramdisk=8192 initrd=0x41000000,8M console=ttySAC2,115200 init=/linuxrc";
 	};
@@ -350,8 +368,8 @@
 	};
 
 	codec@11000000 {
-		samsung,mfc-r = <0x43000000 0x800000>;
-		samsung,mfc-l = <0x51000000 0x800000>;
+		memory-region = <&mfc_left>, <&mfc_right>;
+		memory-region-names = "left", "right";
 	};
 
 	i2s0: i2s@03830000 {
diff --git a/arch/arm/boot/dts/exynos5420-arndale-octa.dts b/arch/arm/boot/dts/exynos5420-arndale-octa.dts
index 434fd9d3e09d..f237c0a98131 100644
--- a/arch/arm/boot/dts/exynos5420-arndale-octa.dts
+++ b/arch/arm/boot/dts/exynos5420-arndale-octa.dts
@@ -22,6 +22,24 @@
 		reg = <0x20000000 0x80000000>;
 	};
 
+	reserved-memory {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		mfc_left: region@51000000 {
+			compatible = "shared-dma-pool";
+			no-map;
+			reg = <0x51000000 0x800000>;
+		};
+
+		mfc_right: region@43000000 {
+			compatible = "shared-dma-pool";
+			no-map;
+			reg = <0x43000000 0x800000>;
+		};
+	};
+
 	chosen {
 		bootargs = "console=ttySAC3,115200";
 	};
@@ -43,8 +61,8 @@
 	};
 
 	codec@11000000 {
-		samsung,mfc-r = <0x43000000 0x800000>;
-		samsung,mfc-l = <0x51000000 0x800000>;
+		memory-region = <&mfc_left>, <&mfc_right>;
+		memory-region-names = "left", "right";
 	};
 
 	mmc@12200000 {
diff --git a/arch/arm/boot/dts/exynos5420-smdk5420.dts b/arch/arm/boot/dts/exynos5420-smdk5420.dts
index 6052aa9c5659..3cac4015b0c4 100644
--- a/arch/arm/boot/dts/exynos5420-smdk5420.dts
+++ b/arch/arm/boot/dts/exynos5420-smdk5420.dts
@@ -20,6 +20,24 @@
 		reg = <0x20000000 0x80000000>;
 	};
 
+	reserved-memory {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		mfc_left: region@51000000 {
+			compatible = "shared-dma-pool";
+			no-map;
+			reg = <0x51000000 0x800000>;
+		};
+
+		mfc_right: region@43000000 {
+			compatible = "shared-dma-pool";
+			no-map;
+			reg = <0x43000000 0x800000>;
+		};
+	};
+
 	chosen {
 		bootargs = "console=ttySAC2,115200 init=/linuxrc";
 	};
@@ -69,8 +87,8 @@
 	};
 
 	codec@11000000 {
-		samsung,mfc-r = <0x43000000 0x800000>;
-		samsung,mfc-l = <0x51000000 0x800000>;
+		memory-region = <&mfc_left>, <&mfc_right>;
+		memory-region-names = "left", "right";
 	};
 
 	mmc@12200000 {
diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index 6a24e111d6e1..c20eb2bf6dbe 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -28,7 +28,6 @@
 #include <asm/memory.h>
 
 #include "common.h"
-#include "mfc.h"
 #include "regs-pmu.h"
 #include "regs-sys.h"
 
@@ -340,22 +339,6 @@ static char const *exynos_dt_compat[] __initconst = {
 	NULL
 };
 
-static void __init exynos_reserve(void)
-{
-#ifdef CONFIG_S5P_DEV_MFC
-	int i;
-	char *mfc_mem[] = {
-		"samsung,mfc-v5",
-		"samsung,mfc-v6",
-		"samsung,mfc-v7",
-	};
-
-	for (i = 0; i < ARRAY_SIZE(mfc_mem); i++)
-		if (of_scan_flat_dt(s5p_fdt_alloc_mfc_mem, mfc_mem[i]))
-			break;
-#endif
-}
-
 static void __init exynos_dt_fixup(void)
 {
 	/*
@@ -378,6 +361,5 @@ DT_MACHINE_START(EXYNOS_DT, "SAMSUNG EXYNOS (Flattened Device Tree)")
 	.init_late	= exynos_init_late,
 	.dt_compat	= exynos_dt_compat,
 	.restart	= exynos_restart,
-	.reserve	= exynos_reserve,
 	.dt_fixup	= exynos_dt_fixup,
 MACHINE_END
diff --git a/arch/arm/mach-exynos/mfc.h b/arch/arm/mach-exynos/mfc.h
deleted file mode 100644
index dec93cd5b3c6..000000000000
--- a/arch/arm/mach-exynos/mfc.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/*
- * Copyright (C) 2013 Samsung Electronics Co.Ltd
- *
- * This program is free software; you can redistribute  it and/or modify it
- * under  the terms of  the GNU General  Public License as published by the
- * Free Software Foundation;  either version 2 of the  License, or (at your
- * option) any later version.
- */
-
-#ifndef __MACH_EXYNOS_MFC_H
-#define __MACH_EXYNOS_MFC_H __FILE__
-
-int __init s5p_fdt_alloc_mfc_mem(unsigned long node, const char *uname,
-				int depth, void *data);
-
-#endif /* __MACH_EXYNOS_MFC_H */
diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-samsung/Kconfig
index c87aefbf3a13..8b0d53b76917 100644
--- a/arch/arm/plat-samsung/Kconfig
+++ b/arch/arm/plat-samsung/Kconfig
@@ -260,11 +260,6 @@ config SAMSUNG_DMADEV
 
 endif
 
-config S5P_DEV_MFC
-	bool
-	help
-	  Compile in setup memory (init) code for MFC
-
 comment "Power management"
 
 config SAMSUNG_PM_DEBUG
diff --git a/arch/arm/plat-samsung/Makefile b/arch/arm/plat-samsung/Makefile
index 5fe175017f07..46561b66d9a0 100644
--- a/arch/arm/plat-samsung/Makefile
+++ b/arch/arm/plat-samsung/Makefile
@@ -25,7 +25,6 @@ obj-$(CONFIG_SAMSUNG_ATAGS)	+= platformdata.o
 
 obj-$(CONFIG_SAMSUNG_ATAGS)	+= devs.o
 obj-$(CONFIG_SAMSUNG_ATAGS)	+= dev-uart.o
-obj-$(CONFIG_S5P_DEV_MFC)	+= s5p-dev-mfc.o
 
 obj-$(CONFIG_SAMSUNG_DEV_BACKLIGHT)	+= dev-backlight.o
 
diff --git a/arch/arm/plat-samsung/s5p-dev-mfc.c b/arch/arm/plat-samsung/s5p-dev-mfc.c
deleted file mode 100644
index 0b04b6b0fa30..000000000000
--- a/arch/arm/plat-samsung/s5p-dev-mfc.c
+++ /dev/null
@@ -1,94 +0,0 @@
-/*
- * Copyright (C) 2010-2011 Samsung Electronics Co.Ltd
- *
- * Base S5P MFC resource and device definitions
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/kernel.h>
-#include <linux/interrupt.h>
-#include <linux/platform_device.h>
-#include <linux/dma-mapping.h>
-#include <linux/memblock.h>
-#include <linux/ioport.h>
-#include <linux/of_fdt.h>
-#include <linux/of.h>
-
-static struct platform_device s5p_device_mfc_l;
-static struct platform_device s5p_device_mfc_r;
-
-struct s5p_mfc_dt_meminfo {
-	unsigned long	loff;
-	unsigned long	lsize;
-	unsigned long	roff;
-	unsigned long	rsize;
-	char		*compatible;
-};
-
-struct s5p_mfc_reserved_mem {
-	phys_addr_t	base;
-	unsigned long	size;
-	struct device	*dev;
-};
-
-static struct s5p_mfc_reserved_mem s5p_mfc_mem[2] __initdata;
-
-
-static void __init s5p_mfc_reserve_mem(phys_addr_t rbase, unsigned int rsize,
-				phys_addr_t lbase, unsigned int lsize)
-{
-	int i;
-
-	s5p_mfc_mem[0].dev = &s5p_device_mfc_r.dev;
-	s5p_mfc_mem[0].base = rbase;
-	s5p_mfc_mem[0].size = rsize;
-
-	s5p_mfc_mem[1].dev = &s5p_device_mfc_l.dev;
-	s5p_mfc_mem[1].base = lbase;
-	s5p_mfc_mem[1].size = lsize;
-
-	for (i = 0; i < ARRAY_SIZE(s5p_mfc_mem); i++) {
-		struct s5p_mfc_reserved_mem *area = &s5p_mfc_mem[i];
-		if (memblock_remove(area->base, area->size)) {
-			printk(KERN_ERR "Failed to reserve memory for MFC device (%ld bytes at 0x%08lx)\n",
-			       area->size, (unsigned long) area->base);
-			area->base = 0;
-		}
-	}
-}
-
-int __init s5p_fdt_alloc_mfc_mem(unsigned long node, const char *uname,
-				int depth, void *data)
-{
-	const __be32 *prop;
-	int len;
-	struct s5p_mfc_dt_meminfo mfc_mem;
-
-	if (!data)
-		return 0;
-
-	if (!of_flat_dt_is_compatible(node, data))
-		return 0;
-
-	prop = of_get_flat_dt_prop(node, "samsung,mfc-l", &len);
-	if (!prop || (len != 2 * sizeof(unsigned long)))
-		return 0;
-
-	mfc_mem.loff = be32_to_cpu(prop[0]);
-	mfc_mem.lsize = be32_to_cpu(prop[1]);
-
-	prop = of_get_flat_dt_prop(node, "samsung,mfc-r", &len);
-	if (!prop || (len != 2 * sizeof(unsigned long)))
-		return 0;
-
-	mfc_mem.roff = be32_to_cpu(prop[0]);
-	mfc_mem.rsize = be32_to_cpu(prop[1]);
-
-	s5p_mfc_reserve_mem(mfc_mem.roff, mfc_mem.rsize,
-			mfc_mem.loff, mfc_mem.lsize);
-
-	return 1;
-}
-- 
1.9.2

