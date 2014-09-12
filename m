Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaILRuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 13:50:21 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:45681 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaILRuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 13:50:15 -0400
From: Robert Richter <rric@kernel.org>
To: Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: Radha Mohan Chintakuntla <rchintakuntla@cavium.com>,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Robert Richter <rrichter@cavium.com>,
        devicetree@vger.kernel.org
Subject: [PATCH v3 3/4] arm64, thunder: Add Kconfig option for Cavium Thunder SoC Family
Date: Fri, 12 Sep 2014 19:49:46 +0200
Message-Id: <1410544187-15876-4-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410544187-15876-1-git-send-email-rric@kernel.org>
References: <1410544187-15876-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Radha Mohan Chintakuntla <rchintakuntla@cavium.com>

This introduces ARCH_THUNDER to enable soc specific drivers and dtb
files.

Signed-off-by: Radha Mohan Chintakuntla <rchintakuntla@cavium.com>
Signed-off-by: Robert Richter <rrichter@cavium.com>
---
 arch/arm64/Kconfig           | 5 +++++
 arch/arm64/boot/dts/Makefile | 3 +--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 67fca2ea81a7..ff9179ba63fb 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -134,6 +134,11 @@ source "kernel/Kconfig.freezer"
 
 menu "Platform selection"
 
+config ARCH_THUNDER
+	bool "Cavium Inc. Thunder SoC Family"
+	help
+	  This enables support for Cavium's Thunder Family of SoCs.
+
 config ARCH_VEXPRESS
 	bool "ARMv8 software model (Versatile Express)"
 	select ARCH_REQUIRE_GPIOLIB
diff --git a/arch/arm64/boot/dts/Makefile b/arch/arm64/boot/dts/Makefile
index c2e8e4661a90..f8001a62029c 100644
--- a/arch/arm64/boot/dts/Makefile
+++ b/arch/arm64/boot/dts/Makefile
@@ -1,8 +1,7 @@
+dtb-$(CONFIG_ARCH_THUNDER) += thunder-88xx.dtb
 dtb-$(CONFIG_ARCH_VEXPRESS) += rtsm_ve-aemv8a.dtb foundation-v8.dtb
 dtb-$(CONFIG_ARCH_XGENE) += apm-mustang.dtb
 
-dtb-y += thunder-88xx.dtb
-
 targets += dtbs
 targets += $(dtb-y)
 
-- 
2.1.0

