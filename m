Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab3LML4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 06:56:20 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:64350 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab3LML4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 06:56:19 -0500
From: panchaxari <panchaxari.prasannamurthy@linaro.org>
To: tomasz.figa@gmail.com
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
        panchaxari.prasannamurthy@linaro.org, Mark Brown <broonie@linaro.org>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH CFT] ARM:S3C64XX: Enable ARM_PATCH_PHYS_VIRT and AUTO_ZRELADDR by default
Date: Fri, 13 Dec 2013 17:25:57 +0530
Message-Id: <1386935757-24125-1-git-send-email-panchaxari.prasannamurthy@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Configs ARM_PATCH_PHYS_VIRT and AUTO_ZRELADDR are enabled as default
to S3C64XX platform

Introduction of PHYS_VIRT config as default would enable phy-to-virt and
virt-to-phy translation function at boot and module loading time
and enforce dynamic reallocation of memory. AUTO_ZRELADDR config would
enable calculation of kernel load address at run time.

PHYS_VIRT config is mutually exclusive to XIP_KERNEL, XIP_KERNEL is used in
systems with NOR flash devices, and ZRELADDR config is mutually exclusive
to ZBOOT_ROM.

CFT::Call For Testing

Requesting maintainers of S3C64XX  platforms to evaluate the changes on the
board and comment, as I dont have the board for testing and also requesting
an ACK the changes.

Signed-off-by: panchaxari <panchaxari.prasannamurthy@linaro.org>
Cc: Mark Brown <broonie@linaro.org>
Cc: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

---
This is basically a Samsung SOC with ARM1176JZF-S instruction set, and has
an operating frquency of 667MHz, it also has 64bit AXI bus. It supports
WinCE, Linux, Android and Ubuntu.

This platform has two variants of CPU, S3C6400 and S3C6410.

This SOC is an Integrated system for Mobile Internet Device, Notebook,
handheld/3G mobile devices.

Supports various types of ROM for booting (NOR/NAND Flash, OneNand, SD-card
and others).

Below lkml link is a quoting by Russell which clears the concept of PHYS_VIRT
and ZRELADDR
---------------------------------------------------

https://lkml.org/lkml/2011/10/14/434

-------------------------------------------------
---
 arch/arm/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 7c6247b..ec1faea 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -731,7 +731,9 @@ config ARCH_S3C64XX
 	bool "Samsung S3C64XX"
 	select ARCH_HAS_CPUFREQ
 	select ARCH_REQUIRE_GPIOLIB
+	select ARM_PATCH_PHYS_VIRT
 	select ARM_VIC
+	select AUTO_ZRELADDR
 	select CLKDEV_LOOKUP
 	select CLKSRC_SAMSUNG_PWM
 	select COMMON_CLK
-- 
1.7.10.4

