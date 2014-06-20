Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbaFTOxv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 10:53:51 -0400
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:41715 "EHLO
	mirror2.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbaFTOxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 10:53:09 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@googlegroups.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/4] ARM: sunxi: Introduce Allwinner A23 support
Date: Fri, 20 Jun 2014 22:52:50 +0800
Message-Id: <1403275973-24259-2-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403275973-24259-1-git-send-email-wens@csie.org>
References: <1403275973-24259-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Allwinner A23 is a dual-core Cortex-A7-based SoC. It re-uses most of
the IPs found in previous SoCs, notably the A31.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/mach-sunxi/Kconfig | 5 +++++
 arch/arm/mach-sunxi/sunxi.c | 9 +++++++++
 2 files changed, 14 insertions(+)

diff --git a/arch/arm/mach-sunxi/Kconfig b/arch/arm/mach-sunxi/Kconfig
index 0fbd4f1..f776c5f 100644
--- a/arch/arm/mach-sunxi/Kconfig
+++ b/arch/arm/mach-sunxi/Kconfig
@@ -35,4 +35,9 @@ config MACH_SUN7I
 	select HAVE_ARM_ARCH_TIMER
 	select SUN5I_HSTIMER
 
+config MACH_SUN8I
+	bool "Allwinner A23 (sun8i) SoCs support"
+	default ARCH_SUNXI
+	select ARM_GIC
+
 endif
diff --git a/arch/arm/mach-sunxi/sunxi.c b/arch/arm/mach-sunxi/sunxi.c
index 3f9587b..4d09469 100644
--- a/arch/arm/mach-sunxi/sunxi.c
+++ b/arch/arm/mach-sunxi/sunxi.c
@@ -53,3 +53,12 @@ static const char * const sun7i_board_dt_compat[] = {
 DT_MACHINE_START(SUN7I_DT, "Allwinner sun7i (A20) Family")
 	.dt_compat	= sun7i_board_dt_compat,
 MACHINE_END
+
+static const char * const sun8i_board_dt_compat[] = {
+	"allwinner,sun8i-a23",
+	NULL,
+};
+
+DT_MACHINE_START(SUN8I_DT, "Allwinner sun8i (A23) Family")
+	.dt_compat	= sun8i_board_dt_compat,
+MACHINE_END
-- 
2.0.0

