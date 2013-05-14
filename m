Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349Ab3ENPlD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 11:41:03 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:48531 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758135Ab3ENPj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 11:39:26 -0400
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
Subject: [PATCH 16/20] ARM: mxs: Remove init_irq declaration in machine description
Date: Tue, 14 May 2013 17:38:49 +0200
Message-Id: <1368545933-7430-17-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1368545933-7430-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1368545933-7430-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ebafed7a ("ARM: irq: Call irqchip_init if no init_irq function is
specified") removed the need to explictly setup the init_irq field in
the machine description when using only irqchip_init. Remove that
declaration for mxs as well.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-mxs/mach-mxs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/mach-mxs/mach-mxs.c b/arch/arm/mach-mxs/mach-mxs.c
index 5b62b64..66fe810 100644
--- a/arch/arm/mach-mxs/mach-mxs.c
+++ b/arch/arm/mach-mxs/mach-mxs.c
@@ -19,7 +19,6 @@
 #include <linux/err.h>
 #include <linux/gpio.h>
 #include <linux/init.h>
-#include <linux/irqchip.h>
 #include <linux/irqchip/mxs.h>
 #include <linux/micrel_phy.h>
 #include <linux/of_address.h>
@@ -435,7 +434,6 @@ static const char *mxs_dt_compat[] __initdata = {
 
 DT_MACHINE_START(MXS, "Freescale MXS (Device Tree)")
 	.map_io		= debug_ll_io_init,
-	.init_irq	= irqchip_init,
 	.handle_irq	= icoll_handle_irq,
 	.init_time	= mxs_timer_init,
 	.init_machine	= mxs_machine_init,
-- 
1.8.1.2

