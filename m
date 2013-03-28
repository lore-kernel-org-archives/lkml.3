Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab3C1Jp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 05:45:29 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:36556 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227Ab3C1JpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 05:45:25 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        STEricsson <STEricsson_nomadik_linux@list.st.com>,
        Jamie Iles <jamie@jamieiles.com>, Barry Song <baohua.song@csr.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-sh@vger.kernel.org
Subject: [PATCH 2/2] ARM: remove mach .init_irq for irqchip_init users
Date: Thu, 28 Mar 2013 10:41:44 +0100
Message-Id: <1364463704-13692-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364463704-13692-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1364463704-13692-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the arm core code calls irqchip_init, we can remove it from all
the machines that were using it.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-bcm/board_bcm.c                  |    1 -
 arch/arm/mach-msm/board-dt-8660.c              |    1 -
 arch/arm/mach-msm/board-dt-8960.c              |    1 -
 arch/arm/mach-nomadik/cpu-8815.c               |    1 -
 arch/arm/mach-picoxcell/common.c               |    1 -
 arch/arm/mach-prima2/common.c                  |    1 -
 arch/arm/mach-shmobile/board-kzm9g-reference.c |    1 -
 arch/arm/mach-shmobile/setup-emev2.c           |    1 -
 arch/arm/mach-shmobile/setup-sh73a0.c          |    1 -
 arch/arm/mach-spear/spear1310.c                |    1 -
 arch/arm/mach-spear/spear1340.c                |    1 -
 arch/arm/mach-spear/spear300.c                 |    1 -
 arch/arm/mach-spear/spear310.c                 |    1 -
 arch/arm/mach-spear/spear320.c                 |    1 -
 arch/arm/mach-spear/spear6xx.c                 |    1 -
 arch/arm/mach-vexpress/v2m.c                   |    1 -
 arch/arm/mach-virt/virt.c                      |    1 -
 arch/arm/mach-zynq/common.c                    |    1 -
 18 files changed, 18 deletions(-)

diff --git a/arch/arm/mach-bcm/board_bcm.c b/arch/arm/mach-bcm/board_bcm.c
index f0f9aba..4c819e2 100644
--- a/arch/arm/mach-bcm/board_bcm.c
+++ b/arch/arm/mach-bcm/board_bcm.c
@@ -34,7 +34,6 @@ static void __init board_init(void)
 static const char * const bcm11351_dt_compat[] = { "bcm,bcm11351", NULL, };
 
 DT_MACHINE_START(BCM11351_DT, "Broadcom Application Processor")
-	.init_irq = irqchip_init,
 	.init_time = timer_init,
 	.init_machine = board_init,
 	.dt_compat = bcm11351_dt_compat,
diff --git a/arch/arm/mach-msm/board-dt-8660.c b/arch/arm/mach-msm/board-dt-8660.c
index 7dcfc53..1360226 100644
--- a/arch/arm/mach-msm/board-dt-8660.c
+++ b/arch/arm/mach-msm/board-dt-8660.c
@@ -44,7 +44,6 @@ static const char *msm8x60_fluid_match[] __initdata = {
 DT_MACHINE_START(MSM_DT, "Qualcomm MSM (Flattened Device Tree)")
 	.smp = smp_ops(msm_smp_ops),
 	.map_io = msm_map_msm8x60_io,
-	.init_irq = irqchip_init,
 	.init_machine = msm8x60_dt_init,
 	.init_late = msm8x60_init_late,
 	.init_time	= msm_dt_timer_init,
diff --git a/arch/arm/mach-msm/board-dt-8960.c b/arch/arm/mach-msm/board-dt-8960.c
index 7301936..1e8eb1d 100644
--- a/arch/arm/mach-msm/board-dt-8960.c
+++ b/arch/arm/mach-msm/board-dt-8960.c
@@ -31,7 +31,6 @@ static const char * const msm8960_dt_match[] __initconst = {
 DT_MACHINE_START(MSM8960_DT, "Qualcomm MSM (Flattened Device Tree)")
 	.smp = smp_ops(msm_smp_ops),
 	.map_io = msm_map_msm8960_io,
-	.init_irq = irqchip_init,
 	.init_time	= msm_dt_timer_init,
 	.init_machine = msm_dt_init,
 	.dt_compat = msm8960_dt_match,
diff --git a/arch/arm/mach-nomadik/cpu-8815.c b/arch/arm/mach-nomadik/cpu-8815.c
index 59f6ff5..3d43f95 100644
--- a/arch/arm/mach-nomadik/cpu-8815.c
+++ b/arch/arm/mach-nomadik/cpu-8815.c
@@ -323,7 +323,6 @@ static const char * cpu8815_board_compat[] = {
 
 DT_MACHINE_START(NOMADIK_DT, "Nomadik STn8815")
 	.map_io		= cpu8815_map_io,
-	.init_irq	= irqchip_init,
 	.init_time	= cpu8815_timer_init_of,
 	.init_machine	= cpu8815_init_of,
 	.restart	= cpu8815_restart,
diff --git a/arch/arm/mach-picoxcell/common.c b/arch/arm/mach-picoxcell/common.c
index 70b441a..b444947 100644
--- a/arch/arm/mach-picoxcell/common.c
+++ b/arch/arm/mach-picoxcell/common.c
@@ -87,7 +87,6 @@ static void picoxcell_wdt_restart(char mode, const char *cmd)
 DT_MACHINE_START(PICOXCELL, "Picochip picoXcell")
 	.map_io		= picoxcell_map_io,
 	.nr_irqs	= NR_IRQS_LEGACY,
-	.init_irq	= irqchip_init,
 	.init_time	= dw_apb_timer_init,
 	.init_machine	= picoxcell_init_machine,
 	.dt_compat	= picoxcell_dt_match,
diff --git a/arch/arm/mach-prima2/common.c b/arch/arm/mach-prima2/common.c
index 72efb4f..efdfc32 100644
--- a/arch/arm/mach-prima2/common.c
+++ b/arch/arm/mach-prima2/common.c
@@ -90,7 +90,6 @@ DT_MACHINE_START(MARCO_DT, "Generic MARCO (Flattened Device Tree)")
 	/* Maintainer: Barry Song <baohua.song@csr.com> */
 	.smp            = smp_ops(sirfsoc_smp_ops),
 	.map_io         = sirfsoc_map_io,
-	.init_irq	= irqchip_init,
 	.init_time	= sirfsoc_marco_timer_init,
 	.init_machine	= sirfsoc_mach_init,
 	.init_late	= sirfsoc_init_late,
diff --git a/arch/arm/mach-shmobile/board-kzm9g-reference.c b/arch/arm/mach-shmobile/board-kzm9g-reference.c
index aefa50d..eaec498 100644
--- a/arch/arm/mach-shmobile/board-kzm9g-reference.c
+++ b/arch/arm/mach-shmobile/board-kzm9g-reference.c
@@ -100,7 +100,6 @@ DT_MACHINE_START(KZM9G_DT, "kzm9g-reference")
 	.map_io		= sh73a0_map_io,
 	.init_early	= sh73a0_init_delay,
 	.nr_irqs	= NR_IRQS_LEGACY,
-	.init_irq	= irqchip_init,
 	.init_machine	= kzm_init,
 	.init_time	= shmobile_timer_init,
 	.dt_compat	= kzm9g_boards_compat_dt,
diff --git a/arch/arm/mach-shmobile/setup-emev2.c b/arch/arm/mach-shmobile/setup-emev2.c
index e4545c1..36d1ac7 100644
--- a/arch/arm/mach-shmobile/setup-emev2.c
+++ b/arch/arm/mach-shmobile/setup-emev2.c
@@ -454,7 +454,6 @@ DT_MACHINE_START(EMEV2_DT, "Generic Emma Mobile EV2 (Flattened Device Tree)")
 	.smp		= smp_ops(emev2_smp_ops),
 	.init_early	= emev2_init_delay,
 	.nr_irqs	= NR_IRQS_LEGACY,
-	.init_irq	= irqchip_init,
 	.init_machine	= emev2_add_standard_devices_dt,
 	.init_time	= shmobile_timer_init,
 	.dt_compat	= emev2_boards_compat_dt,
diff --git a/arch/arm/mach-shmobile/setup-sh73a0.c b/arch/arm/mach-shmobile/setup-sh73a0.c
index e8cd93a..ad13508 100644
--- a/arch/arm/mach-shmobile/setup-sh73a0.c
+++ b/arch/arm/mach-shmobile/setup-sh73a0.c
@@ -1035,7 +1035,6 @@ DT_MACHINE_START(SH73A0_DT, "Generic SH73A0 (Flattened Device Tree)")
 	.map_io		= sh73a0_map_io,
 	.init_early	= sh73a0_init_delay,
 	.nr_irqs	= NR_IRQS_LEGACY,
-	.init_irq	= irqchip_init,
 	.init_machine	= sh73a0_add_standard_devices_dt,
 	.init_time	= shmobile_timer_init,
 	.dt_compat	= sh73a0_boards_compat_dt,
diff --git a/arch/arm/mach-spear/spear1310.c b/arch/arm/mach-spear/spear1310.c
index ed3b5c2..673783f 100644
--- a/arch/arm/mach-spear/spear1310.c
+++ b/arch/arm/mach-spear/spear1310.c
@@ -88,7 +88,6 @@ static void __init spear1310_map_io(void)
 DT_MACHINE_START(SPEAR1310_DT, "ST SPEAr1310 SoC with Flattened Device Tree")
 	.smp		=	smp_ops(spear13xx_smp_ops),
 	.map_io		=	spear1310_map_io,
-	.init_irq	=	irqchip_init,
 	.init_time	=	spear13xx_timer_init,
 	.init_machine	=	spear1310_dt_init,
 	.restart	=	spear_restart,
diff --git a/arch/arm/mach-spear/spear1340.c b/arch/arm/mach-spear/spear1340.c
index 75e3864..ea78f93 100644
--- a/arch/arm/mach-spear/spear1340.c
+++ b/arch/arm/mach-spear/spear1340.c
@@ -185,7 +185,6 @@ static const char * const spear1340_dt_board_compat[] = {
 DT_MACHINE_START(SPEAR1340_DT, "ST SPEAr1340 SoC with Flattened Device Tree")
 	.smp		=	smp_ops(spear13xx_smp_ops),
 	.map_io		=	spear13xx_map_io,
-	.init_irq	=	irqchip_init,
 	.init_time	=	spear13xx_timer_init,
 	.init_machine	=	spear1340_dt_init,
 	.restart	=	spear_restart,
diff --git a/arch/arm/mach-spear/spear300.c b/arch/arm/mach-spear/spear300.c
index bac56e8..185b9ba 100644
--- a/arch/arm/mach-spear/spear300.c
+++ b/arch/arm/mach-spear/spear300.c
@@ -212,7 +212,6 @@ static void __init spear300_map_io(void)
 
 DT_MACHINE_START(SPEAR300_DT, "ST SPEAr300 SoC with Flattened Device Tree")
 	.map_io		=	spear300_map_io,
-	.init_irq	=	irqchip_init,
 	.init_time	=	spear3xx_timer_init,
 	.init_machine	=	spear300_dt_init,
 	.restart	=	spear_restart,
diff --git a/arch/arm/mach-spear/spear310.c b/arch/arm/mach-spear/spear310.c
index 6ffbc63..ebc07e6 100644
--- a/arch/arm/mach-spear/spear310.c
+++ b/arch/arm/mach-spear/spear310.c
@@ -254,7 +254,6 @@ static void __init spear310_map_io(void)
 
 DT_MACHINE_START(SPEAR310_DT, "ST SPEAr310 SoC with Flattened Device Tree")
 	.map_io		=	spear310_map_io,
-	.init_irq	=	irqchip_init,
 	.init_time	=	spear3xx_timer_init,
 	.init_machine	=	spear310_dt_init,
 	.restart	=	spear_restart,
diff --git a/arch/arm/mach-spear/spear320.c b/arch/arm/mach-spear/spear320.c
index 6eb3eec..1fa4929 100644
--- a/arch/arm/mach-spear/spear320.c
+++ b/arch/arm/mach-spear/spear320.c
@@ -269,7 +269,6 @@ static void __init spear320_map_io(void)
 
 DT_MACHINE_START(SPEAR320_DT, "ST SPEAr320 SoC with Flattened Device Tree")
 	.map_io		=	spear320_map_io,
-	.init_irq	=	irqchip_init,
 	.init_time	=	spear3xx_timer_init,
 	.init_machine	=	spear320_dt_init,
 	.restart	=	spear_restart,
diff --git a/arch/arm/mach-spear/spear6xx.c b/arch/arm/mach-spear/spear6xx.c
index ec8eefb..0359f2e 100644
--- a/arch/arm/mach-spear/spear6xx.c
+++ b/arch/arm/mach-spear/spear6xx.c
@@ -423,7 +423,6 @@ static const char *spear600_dt_board_compat[] = {
 
 DT_MACHINE_START(SPEAR600_DT, "ST SPEAr600 (Flattened Device Tree)")
 	.map_io		=	spear6xx_map_io,
-	.init_irq	=	irqchip_init,
 	.init_time	=	spear6xx_timer_init,
 	.init_machine	=	spear600_dt_init,
 	.restart	=	spear_restart,
diff --git a/arch/arm/mach-vexpress/v2m.c b/arch/arm/mach-vexpress/v2m.c
index d0ad789..bc1493d 100644
--- a/arch/arm/mach-vexpress/v2m.c
+++ b/arch/arm/mach-vexpress/v2m.c
@@ -478,7 +478,6 @@ DT_MACHINE_START(VEXPRESS_DT, "ARM-Versatile Express")
 	.smp		= smp_ops(vexpress_smp_ops),
 	.map_io		= v2m_dt_map_io,
 	.init_early	= v2m_dt_init_early,
-	.init_irq	= irqchip_init,
 	.init_time	= v2m_dt_timer_init,
 	.init_machine	= v2m_dt_init,
 	.restart	= vexpress_restart,
diff --git a/arch/arm/mach-virt/virt.c b/arch/arm/mach-virt/virt.c
index 31666f6..6c1c46e 100644
--- a/arch/arm/mach-virt/virt.c
+++ b/arch/arm/mach-virt/virt.c
@@ -46,7 +46,6 @@ static const char *virt_dt_match[] = {
 extern struct smp_operations virt_smp_ops;
 
 DT_MACHINE_START(VIRT, "Dummy Virtual Machine")
-	.init_irq	= irqchip_init,
 	.init_time	= virt_timer_init,
 	.init_machine	= virt_init,
 	.smp		= smp_ops(virt_smp_ops),
diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index 5c89832..23b2d54 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -97,7 +97,6 @@ static const char *xilinx_dt_match[] = {
 
 MACHINE_START(XILINX_EP107, "Xilinx Zynq Platform")
 	.map_io		= xilinx_map_io,
-	.init_irq	= irqchip_init,
 	.init_machine	= xilinx_init_machine,
 	.init_time	= xilinx_zynq_timer_init,
 	.dt_compat	= xilinx_dt_match,
-- 
1.7.10.4

