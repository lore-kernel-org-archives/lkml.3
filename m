Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933539AbaFQO61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:58:27 -0400
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:41386 "EHLO
	mirror2.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933160AbaFQOx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:53:28 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Subject: [PATCH v2 17/20] ARM: sunxi: Introduce Allwinner A23 support
Date: Tue, 17 Jun 2014 22:52:54 +0800
Message-Id: <1403016777-15121-18-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403016777-15121-1-git-send-email-wens@csie.org>
References: <1403016777-15121-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Allwinner A23 is a dual-core Cortex-A7-based SoC. It re-uses most of
the IPs found in previous SoCs, notably the A31.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/mach-sunxi/Kconfig |  8 ++++++++
 arch/arm/mach-sunxi/sunxi.c | 10 ++++++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/arm/mach-sunxi/Kconfig b/arch/arm/mach-sunxi/Kconfig
index 0fbd4f1..6434e3b 100644
--- a/arch/arm/mach-sunxi/Kconfig
+++ b/arch/arm/mach-sunxi/Kconfig
@@ -35,4 +35,12 @@ config MACH_SUN7I
 	select HAVE_ARM_ARCH_TIMER
 	select SUN5I_HSTIMER
 
+config MACH_SUN8I
+	bool "Allwinner A23 (sun8i) SoCs support"
+	default ARCH_SUNXI
+	select ARCH_HAS_RESET_CONTROLLER
+	select ARM_GIC
+	select MFD_SUN6I_PRCM
+	select RESET_CONTROLLER
+
 endif
diff --git a/arch/arm/mach-sunxi/sunxi.c b/arch/arm/mach-sunxi/sunxi.c
index 3f9587b..962ff30 100644
--- a/arch/arm/mach-sunxi/sunxi.c
+++ b/arch/arm/mach-sunxi/sunxi.c
@@ -53,3 +53,13 @@ static const char * const sun7i_board_dt_compat[] = {
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
+	.init_time	= sun6i_timer_init,
+	.dt_compat	= sun8i_board_dt_compat,
+MACHINE_END
-- 
2.0.0

