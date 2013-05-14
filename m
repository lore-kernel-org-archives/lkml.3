Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412Ab3ENPjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 11:39:36 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:48583 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932265Ab3ENPja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 11:39:30 -0400
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
Subject: [PATCH 20/20] ARM: vt8500: Remove init_irq declaration in machine description
Date: Tue, 14 May 2013 17:38:53 +0200
Message-Id: <1368545933-7430-21-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1368545933-7430-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1368545933-7430-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ebafed7a ("ARM: irq: Call irqchip_init if no init_irq function is
specified") removed the need to explictly setup the init_irq field in
the machine description when using only irqchip_init. Remove that
declaration for vt8500 as well.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-vt8500/vt8500.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/mach-vt8500/vt8500.c b/arch/arm/mach-vt8500/vt8500.c
index 1dd281e..70a5ac9 100644
--- a/arch/arm/mach-vt8500/vt8500.c
+++ b/arch/arm/mach-vt8500/vt8500.c
@@ -20,7 +20,6 @@
 
 #include <linux/clocksource.h>
 #include <linux/io.h>
-#include <linux/irqchip.h>
 #include <linux/pm.h>
 
 #include <asm/mach-types.h>
@@ -178,7 +177,6 @@ static const char * const vt8500_dt_compat[] = {
 DT_MACHINE_START(WMT_DT, "VIA/Wondermedia SoC (Device Tree Support)")
 	.dt_compat	= vt8500_dt_compat,
 	.map_io		= vt8500_map_io,
-	.init_irq	= irqchip_init,
 	.init_machine	= vt8500_init,
 	.init_time	= clocksource_of_init,
 	.restart	= vt8500_restart,
-- 
1.8.1.2

