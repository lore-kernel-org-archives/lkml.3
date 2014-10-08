Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbaJHNDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 09:03:11 -0400
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:55420 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144AbaJHNDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 09:03:07 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shuge <shuge@allwinnertech.com>, Meng Zhang <kevin@allwinnertech.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: [PATCH v3 1/5] ARM: sunxi: Introduce Allwinner A80 support
Date: Wed,  8 Oct 2014 21:02:52 +0800
Message-Id: <1412773376-25212-2-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1412773376-25212-1-git-send-email-wens@csie.org>
References: <1412773376-25212-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Allwinner A80 is a new Cortex octo-core A7/A15 big.LITTLE SoC.
While it's processor cores and interconnecting bus are new, it
re-uses many peripherals found in earlier Allwinner SoCs.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/mach-sunxi/Kconfig | 5 +++++
 arch/arm/mach-sunxi/sunxi.c | 9 +++++++++
 2 files changed, 14 insertions(+)

diff --git a/arch/arm/mach-sunxi/Kconfig b/arch/arm/mach-sunxi/Kconfig
index 1aaa1e1..d04f84b 100644
--- a/arch/arm/mach-sunxi/Kconfig
+++ b/arch/arm/mach-sunxi/Kconfig
@@ -42,4 +42,9 @@ config MACH_SUN8I
 	select MFD_SUN6I_PRCM
 	select RESET_CONTROLLER
 
+config MACH_SUN9I
+	bool "Allwinner (sun9i) SoCs support"
+	default ARCH_SUNXI
+	select ARM_GIC
+
 endif
diff --git a/arch/arm/mach-sunxi/sunxi.c b/arch/arm/mach-sunxi/sunxi.c
index 42d4753..ba926b5 100644
--- a/arch/arm/mach-sunxi/sunxi.c
+++ b/arch/arm/mach-sunxi/sunxi.c
@@ -139,3 +139,12 @@ static const char * const sun8i_board_dt_compat[] = {
 DT_MACHINE_START(SUN8I_DT, "Allwinner sun8i (A23) Family")
 	.dt_compat	= sun8i_board_dt_compat,
 MACHINE_END
+
+static const char * const sun9i_board_dt_compat[] = {
+	"allwinner,sun9i-a80",
+	NULL,
+};
+
+DT_MACHINE_START(SUN9I_DT, "Allwinner sun9i Family")
+	.dt_compat	= sun9i_board_dt_compat,
+MACHINE_END
-- 
2.1.1

