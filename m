Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761003Ab3LIJlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 04:41:21 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:51493 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab3LIJlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 04:41:19 -0500
From: panchaxari <panchaxari.prasannamurthy@linaro.org>
To: linus.walleij@linaro.org
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
        panchaxari.prasannamurthy@linaro.org,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH CFT] ARM:MSM: Enable ARM_PATCH_PHYS_VIRT and AUTO_ZRELADDR default
Date: Mon,  9 Dec 2013 15:10:50 +0530
Message-Id: <1386582050-21375-1-git-send-email-panchaxari.prasannamurthy@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM_PATCH_PHYS_VIRT and AUTO_ZRELADDR have been enabled as default configs
to MSM platform

Introduction of PHYS_VIRT config as default would enable phy-to-virt and
virt-to-phy translation function at boot and module loading time
and enforce dynamic reallocation of memory. AUTO_ZRELADDR config would
enable calculation of kernel load address at run time.

PHYS_VIRT config is mutually exclusive to XIP_KERNEL, XIP_KERNEL is used in
systems with NOR flash devices, and ZRELADDR config is mutually exclusive
to ZBOOT_ROM.

CFT::Call For Testing

Requesting maintainers of MSM platforms to evaluate the changes on the board
and comment, as I dont have the board for testing and also requesting an ACK

Signed-off-by: panchaxari <panchaxari.prasannamurthy@linaro.org>
Cc: David Brown <davidb@codeaurora.org>
Cc: Daniel Walker <dwalker@fifo99.com>
Cc: Bryan Huntsman <bryanh@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-msm@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org

---
ARCH_MSM supports for Qualcomm MSM/QSD based systems.  This runs on the apps
processor of the MSM/QSD and depends on a shared memory interface to the modem
processor which runs the baseband stack and controls some vital subsystems
like clock and power control.

Snapdragon is based on ARMv7 instruction set. And supports Random memory devices
like DDR1, LPDDR2 and LPDDR3. And storage memory devices like NAND, eMMC.

Below lkml link is a quoting by Russell which clears the concept of PHYS_VIRT
and ZRELADDR
---------------------------------------------------

https://lkml.org/lkml/2011/10/14/434

-------------------------------------------------
---
 arch/arm/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 13621ed..3b77864 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -638,6 +638,8 @@ config ARCH_PXA
 config ARCH_MSM
 	bool "Qualcomm MSM"
 	select ARCH_REQUIRE_GPIOLIB
+	select ARM_PATCH_PHYS_VIRT
+	select AUTO_ZRELADDR
 	select CLKSRC_OF if OF
 	select COMMON_CLK
 	select GENERIC_CLOCKEVENTS
-- 
1.7.10.4

