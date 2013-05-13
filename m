Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab3EMJrw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 05:47:52 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:41611 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab3EMJoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 05:44:37 -0400
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
Subject: [PATCH 06/14] ARM: bcm281xx: Remove init_irq declaration in machine description
Date: Mon, 13 May 2013 11:44:05 +0200
Message-Id: <1368438253-28218-7-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1368438253-28218-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1368438253-28218-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ebafed7a ("ARM: irq: Call irqchip_init if no init_irq function is
specified") removed the need to explictly setup the init_irq field in
the machine description when using only irqchip_init. Remove that
declaration for bcm281xx as well.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-bcm/board_bcm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-bcm/board_bcm.c b/arch/arm/mach-bcm/board_bcm.c
index 22e8421..24556cf 100644
--- a/arch/arm/mach-bcm/board_bcm.c
+++ b/arch/arm/mach-bcm/board_bcm.c
@@ -54,7 +54,6 @@ static void __init board_init(void)
 static const char * const bcm11351_dt_compat[] = { "bcm,bcm11351", NULL, };
 
 DT_MACHINE_START(BCM11351_DT, "Broadcom Application Processor")
-	.init_irq = irqchip_init,
 	.init_time = clocksource_of_init,
 	.init_machine = board_init,
 	.dt_compat = bcm11351_dt_compat,
-- 
1.8.1.2

