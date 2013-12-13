Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab3LML2t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 06:28:49 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:50253 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab3LML2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 06:28:47 -0500
From: panchaxari <panchaxari.prasannamurthy@linaro.org>
To: heiko@sntech.de
Cc: panchaxari.prasannamurthy@linaro.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH CFT] ARM:S3C24XX: Enable ARM_PATCH_PHYS_VIRT and AUTO_ZRELADDR by default
Date: Fri, 13 Dec 2013 16:58:25 +0530
Message-Id: <1386934105-23392-1-git-send-email-panchaxari.prasannamurthy@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Configs ARM_PATCH_PHYS_VIRT and AUTO_ZRELADDR are enabled as default
to platform S3C24XX.

Introduction of PHYS_VIRT config as default would enable phy-to-virt and
virt-to-phy translation function at boot and module loading time
and enforce dynamic reallocation of memory. AUTO_ZRELADDR config would
enable calculation of kernel load address at run time.

PHYS_VIRT config is mutually exclusive to XIP_KERNEL, XIP_KERNEL is used in
systems with NOR flash devices, and ZRELADDR config is mutually exclusive
to ZBOOT_ROM.

CFT::Call For Testing

Requesting maintainers of S3C24XX  platforms to evaluate the changes on the
board and comment, as I dont have the board for testing and also requesting
an ACK the changes.

Signed-off-by: panchaxari <panchaxari.prasannamurthy@linaro.org>
Cc: Heiko Stuebner <heiko@sntech.de>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

---
S3C24XX is basically a Samsung SOC with ARM920T instruction set, and has
an operating frquency of 203MHz, it also has enhanced MMU architecture
to support WinCE, EPOC 32 and Linux.

This SOC is an Integrated system for hand-held devices and general
embedded systems.

Supports various types of ROM for booting (NOR/NAND Flash, EEPROM, and others).
Supports 8 memory banks, 128M for each bank, with a total of 1GB.
---
 arch/arm/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 32acacb..ec1faea 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -708,6 +708,8 @@ config ARCH_S3C24XX
 	bool "Samsung S3C24XX SoCs"
 	select ARCH_HAS_CPUFREQ
 	select ARCH_REQUIRE_GPIOLIB
+	select ARM_PATCH_PHYS_VIRT
+	select AUTO_ZRELADDR
 	select CLKDEV_LOOKUP
 	select CLKSRC_SAMSUNG_PWM
 	select GENERIC_CLOCKEVENTS
-- 
1.7.10.4

