Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab3LBL3Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 06:29:24 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:39264 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab3LBL3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 06:29:23 -0500
From: panchaxari <panchaxari.prasannamurthy@linaro.org>
To: linus.walleij@linaro.org
Cc: linux@arm.linux.org.uk, arnd@arndb.de, monstr@monstr.eu, olof@lixom.net,
        panchaxari <panchaxari.prasannamurthy@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM:INTEGRATOR: Default enable ARM_PATCH_PHYS_VIRT, AUTO_ZRELADDR
Date: Mon,  2 Dec 2013 16:58:51 +0530
Message-Id: <1385983731-13196-2-git-send-email-panchaxari.prasannamurthy@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1385983731-13196-1-git-send-email-panchaxari.prasannamurthy@linaro.org>
References: <1385983731-13196-1-git-send-email-panchaxari.prasannamurthy@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM_PATCH_PHYS_VIRT and AUTO_ZRELADDR has been enabled as default configs
to integrator platform.

Introduction of PHYS_VIRT config as default would enable phy-to-virt and
virt-to-phy translation function at boot and module loading time
and enforce dynamic reallocation of memory. AUTO_ZRELADDR config would
enable calculation of kernel load address at run time.

PHYS_VIRT config is mutually exclusive to XIP_KERNEL, XIP_KERNEL is used in
systems with NOR flash devices, and ZRELADDR config is mutually exclusive
to ZBOOT_ROM.

Requesting maintainers of Integrator platform to evaluate the changes on the
board and comment, as I dont have the board for testing and also requesting
an ACK.

Signed-off-by: panchaxari <panchaxari.prasannamurthy@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Olof Johansson <olof@lixom.net>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 28d84f3..79ba1a8 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -313,6 +313,8 @@ config ARCH_INTEGRATOR
 	bool "ARM Ltd. Integrator family"
 	select ARCH_HAS_CPUFREQ
 	select ARM_AMBA
+	select ARM_PATCH_PHYS_VIRT
+	select AUTO_ZRELADDR
 	select COMMON_CLK
 	select COMMON_CLK_VERSATILE
 	select GENERIC_CLOCKEVENTS
-- 
1.7.10.4

