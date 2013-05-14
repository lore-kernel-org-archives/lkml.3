Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab3ENPje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 11:39:34 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:48556 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254Ab3ENPj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 11:39:28 -0400
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
Subject: [PATCH 18/20] ARM: vexpress: Remove init_irq declaration in machine description
Date: Tue, 14 May 2013 17:38:51 +0200
Message-Id: <1368545933-7430-19-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1368545933-7430-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1368545933-7430-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ebafed7a ("ARM: irq: Call irqchip_init if no init_irq function is
specified") removed the need to explictly setup the init_irq field in
the machine description when using only irqchip_init. Remove that
declaration for vexpress as well.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Acked-by: Pawel Moll <pawel.moll@arm.com>
---
 arch/arm/mach-vexpress/v2m.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/mach-vexpress/v2m.c b/arch/arm/mach-vexpress/v2m.c
index 8802030..d601697 100644
--- a/arch/arm/mach-vexpress/v2m.c
+++ b/arch/arm/mach-vexpress/v2m.c
@@ -9,7 +9,6 @@
 #include <linux/clocksource.h>
 #include <linux/smp.h>
 #include <linux/init.h>
-#include <linux/irqchip.h>
 #include <linux/of_address.h>
 #include <linux/of_fdt.h>
 #include <linux/of_irq.h>
@@ -458,7 +457,6 @@ DT_MACHINE_START(VEXPRESS_DT, "ARM-Versatile Express")
 	.smp		= smp_ops(vexpress_smp_ops),
 	.map_io		= v2m_dt_map_io,
 	.init_early	= v2m_dt_init_early,
-	.init_irq	= irqchip_init,
 	.init_time	= v2m_dt_timer_init,
 	.init_machine	= v2m_dt_init,
 MACHINE_END
-- 
1.8.1.2

