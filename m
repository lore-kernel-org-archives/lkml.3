Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527Ab3LLFNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 00:13:20 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:54058 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab3LLFNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 00:13:17 -0500
From: panchaxari <panchaxari.prasannamurthy@linaro.org>
To: kgene.kim@samsung.com
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
        panchaxari.prasannamurthy@linaro.org,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH CFT] ARM:S5P64X0: Enable ARM_PATCH_PHYS_VIRT and AUTO_ZRELADDR by default
Date: Thu, 12 Dec 2013 10:42:32 +0530
Message-Id: <1386825152-398-1-git-send-email-panchaxari.prasannamurthy@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM_PATCH_PHYS_VIRT and AUTO_ZRELADDR have been enabled as default configs
to S5P64X0 platforms.

Introduction of PHYS_VIRT config as default would enable phy-to-virt and
virt-to-phy translation function at boot and module loading time
and enforce dynamic reallocation of memory. AUTO_ZRELADDR config would
enable calculation of kernel load address at run time.

PHYS_VIRT config is mutually exclusive to XIP_KERNEL, XIP_KERNEL is used in
systems with NOR flash devices, and ZRELADDR config is mutually exclusive
to ZBOOT_ROM.

CFT::Call For Testing

Requesting maintainers of S5P64X0 platforms to evaluate the changes on the
board and comment, as I dont have the board for testing and also requesting
an ACK

Signed-off-by: panchaxari <panchaxari.prasannamurthy@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Heiko Stuebner <heiko@sntech.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

---
The samsung S5P64X0 vega has an average performing CPU with max speed 667 Mhz.
This SOC has two variants S5P6440 and S5P6450. It has one core based on
ARM1176JZF-S instruction set, and has 16KB data and instruction cache each.

SOC has a memory subsystem with support to NAND Flash interface with x8 data
bus, with 1/4/8/12/16 bit hardware ECC circuit and 4KB Page mode. It has
Mobile DDR interface with x16 or x32 data bus, and DDR2 interface with x16 or
x32 data bus it also supports eMMC4.4.

Below lkml link is a quoting by Russell which clears the concept of PHYS_VIRT
and ZRELADDR
-------------------------------------------------

https://lkml.org/lkml/2011/10/14/434

-------------------------------------------------
---
 arch/arm/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 934e26c..8986335 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -759,6 +759,8 @@ config ARCH_S3C64XX
 
 config ARCH_S5P64X0
 	bool "Samsung S5P6440 S5P6450"
+	select ARM_PATCH_PHYS_VIRT
+	select AUTO_ZRELADDR
 	select CLKDEV_LOOKUP
 	select CLKSRC_SAMSUNG_PWM
 	select CPU_V6
-- 
1.7.10.4

