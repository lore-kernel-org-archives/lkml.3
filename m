Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbaEWIem (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 04:34:42 -0400
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:39563 "EHLO
	mirror2.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaEWI1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 04:27:33 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Subject: [PATCH 18/22] ARM: sunxi: Introduce Allwinner A23 support
Date: Fri, 23 May 2014 15:51:21 +0800
Message-Id: <1400831485-28576-19-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1400831485-28576-1-git-send-email-wens@csie.org>
References: <1400831485-28576-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Allwinner A23 is a dual-core Cortex-A7-based SoC. It re-uses most of
the IPs found in previous SoCs, notably the A31.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/mach-sunxi/Kconfig |  8 ++++++++
 arch/arm/mach-sunxi/sunxi.c | 12 ++++++++++++
 2 files changed, 20 insertions(+)

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
index df906e3..a43b295 100644
--- a/arch/arm/mach-sunxi/sunxi.c
+++ b/arch/arm/mach-sunxi/sunxi.c
@@ -159,3 +159,15 @@ DT_MACHINE_START(SUN7I_DT, "Allwinner sun7i (A20) Family")
 	.dt_compat	= sun7i_board_dt_compat,
 	.restart	= sun4i_restart,
 MACHINE_END
+
+static const char * const sun8i_board_dt_compat[] = {
+	"allwinner,sun8i-a23",
+	NULL,
+};
+
+DT_MACHINE_START(SUN8I_DT, "Allwinner sun8i (A23) Family")
+	.init_machine	= sunxi_dt_init,
+	.init_time	= sun6i_timer_init,
+	.dt_compat	= sun8i_board_dt_compat,
+	.restart	= sun6i_restart,
+MACHINE_END
-- 
2.0.0.rc2

