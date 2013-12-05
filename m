Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500Ab3LEFyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 00:54:18 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:47712 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab3LEFyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 00:54:16 -0500
From: panchaxari <panchaxari.prasannamurthy@linaro.org>
To: linus.walleij@linaro.org
Cc: eric.y.miao@gmail.com, haojian.zhuang@gmail.com, linux@arm.linux.org.uk,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        panchaxari <panchaxari.prasannamurthy@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH CFT] ARM:MMP: Enable ARM_PATCH_PHYS_VIRT and ZRELADDR default
Date: Thu,  5 Dec 2013 11:23:50 +0530
Message-Id: <1386222830-7681-2-git-send-email-panchaxari.prasannamurthy@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1386222830-7681-1-git-send-email-panchaxari.prasannamurthy@linaro.org>
References: <1386222830-7681-1-git-send-email-panchaxari.prasannamurthy@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM_PATCH_PHYS_VIRT and AUTO_ZRELADDR has been enabled as default configs
to Marvell PXA168/910/MMP2 platforms.

Introduction of PHYS_VIRT config as default would enable phy-to-virt and
virt-to-phy translation function at boot and module loading time
and enforce dynamic reallocation of memory. AUTO_ZRELADDR config would
enable calculation of kernel load address at run time.

PHYS_VIRT config is mutually exclusive to XIP_KERNEL, XIP_KERNEL is used in
systems with NOR flash devices, and ZRELADDR config is mutually exclusive
to ZBOOT_ROM.

CFT::Call For Testing

Requesting maintainers of Marvell PXA168/910/MMP2 platforms to evaluate the
changes on the board and comment, as I dont have the board for testing and
also requesting an ACK

Signed-off-by: panchaxari <panchaxari.prasannamurthy@linaro.org>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 79ba1a8..13621ed 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -560,6 +560,8 @@ config ARCH_MMP
 	bool "Marvell PXA168/910/MMP2"
 	depends on MMU
 	select ARCH_REQUIRE_GPIOLIB
+	select ARM_PATCH_PHYS_VIRT
+	select AUTO_ZRELADDR
 	select CLKDEV_LOOKUP
 	select GENERIC_ALLOCATOR
 	select GENERIC_CLOCKEVENTS
-- 
1.7.10.4

