Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426AbaAIJTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 04:19:55 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:63219 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbaAIJTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 04:19:45 -0500
From: panchaxari <panchaxari.prasannamurthy@linaro.org>
To: hsweeten@visionengravers.com
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
        panchaxari.prasannamurthy@linaro.org, Ryan Mallon <rmallon@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH CFT] ARM:EP93XX: Enable ARM_PATCH_PHYS_VIRT and AUTO_ZRELADDR by default
Date: Thu,  9 Jan 2014 14:49:24 +0530
Message-Id: <1389259164-7442-1-git-send-email-panchaxari.prasannamurthy@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables ARM_PATCH_PHYS_VIRT and AUTO_ZRELADDR as default configs
to EP93XX platforms from Cirrus.

Introduction of PHYS_VIRT config as default config enables phy-to-virt and
virt-to-phy translation functions at boot and module loading time, and enforce
dynamic reallocation of memory. PHYS_VIRT config is mutually exclusive to
XIP_KERNEL, XIP_KERNEL is used in systems with NOR flash devices.

AUTO_ZRELADDR config enables auto calculation of the decompressed kernel image
address. AUTO_ZRELADDR config is mutually exclusive to ZBOOT_ROM, and also
assumes zImage to be loaded in the first 128MiB from start of memory.

CFT::Call For Testing

Requesting maintainers of EP93XX platform to evaluate the changes on the
board and comment, as I dont have the board for testing and also requesting
an ACK.

Signed-off-by: panchaxari <panchaxari.prasannamurthy@linaro.org>
Cc: Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
Below lkml link is a quoting by Russell which explains more on concept of
PHYS_VIRT and ZRELADDR
-------------------------------------------------

https://lkml.org/lkml/2011/10/14/434

-------------------------------------------------
---
 arch/arm/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 3501362..077ef9d 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -420,10 +420,12 @@ config ARCH_EBSA110
 config ARCH_EP93XX
 	bool "EP93xx-based"
 	select ARCH_HAS_HOLES_MEMORYMODEL
+	select ARCH_PATCH_PHYS_VIRT
 	select ARCH_REQUIRE_GPIOLIB
 	select ARCH_USES_GETTIMEOFFSET
 	select ARM_AMBA
 	select ARM_VIC
+	select AUTO_ZRELADDR
 	select CLKDEV_LOOKUP
 	select CPU_ARM920T
 	select NEED_MACH_MEMORY_H
-- 
1.7.10.4

