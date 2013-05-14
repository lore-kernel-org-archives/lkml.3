Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab3ENPkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 11:40:25 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:48540 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185Ab3ENPj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 11:39:27 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jamie Iles <jamie@jamieiles.com>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Christian Daudt <csd@broadcom.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        David Brown <davidb@codeaurora.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Shawn Guo <shawn.guo@linaro.org>, Barry Song <baohua.song@csr.com>,
        Tony Prisk <linux@prisktech.co.nz>
Cc: linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Subject: [PATCH 17/20] ARM: sirf: Remove init_irq declaration in machine description
Date: Tue, 14 May 2013 17:38:50 +0200
Message-Id: <1368545933-7430-18-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1368545933-7430-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1368545933-7430-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ebafed7a ("ARM: irq: Call irqchip_init if no init_irq function is
specified") removed the need to explictly setup the init_irq field in
the machine description when using only irqchip_init. Remove that
declaration for sirf as well.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Acked-by: Barry Song <Baohua.Song@csr.com>
---
 arch/arm/mach-prima2/common.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm/mach-prima2/common.c b/arch/arm/mach-prima2/common.c
index 4f94cd8..a9f475c 100644
--- a/arch/arm/mach-prima2/common.c
+++ b/arch/arm/mach-prima2/common.c
@@ -9,7 +9,6 @@
 #include <linux/clocksource.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/irqchip.h>
 #include <asm/sizes.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -55,7 +54,6 @@ DT_MACHINE_START(ATLAS6_DT, "Generic ATLAS6 (Flattened Device Tree)")
 	/* Maintainer: Barry Song <baohua.song@csr.com> */
 	.nr_irqs	= 128,
 	.map_io         = sirfsoc_map_io,
-	.init_irq	= irqchip_init,
 	.init_time	= sirfsoc_init_time,
 	.init_machine	= sirfsoc_mach_init,
 	.init_late	= sirfsoc_init_late,
@@ -74,7 +72,6 @@ DT_MACHINE_START(PRIMA2_DT, "Generic PRIMA2 (Flattened Device Tree)")
 	/* Maintainer: Barry Song <baohua.song@csr.com> */
 	.nr_irqs	= 128,
 	.map_io         = sirfsoc_map_io,
-	.init_irq	= irqchip_init,
 	.init_time	= sirfsoc_init_time,
 	.dma_zone_size	= SZ_256M,
 	.init_machine	= sirfsoc_mach_init,
@@ -94,7 +91,6 @@ DT_MACHINE_START(MARCO_DT, "Generic MARCO (Flattened Device Tree)")
 	/* Maintainer: Barry Song <baohua.song@csr.com> */
 	.smp            = smp_ops(sirfsoc_smp_ops),
 	.map_io         = sirfsoc_map_io,
-	.init_irq	= irqchip_init,
 	.init_time	= sirfsoc_init_time,
 	.init_machine	= sirfsoc_mach_init,
 	.init_late	= sirfsoc_init_late,
-- 
1.8.1.2

