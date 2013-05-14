Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab3ENQUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 12:20:54 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:33695 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab3ENQUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 12:20:51 -0400
Date: Tue, 14 May 2013 17:20:46 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jamie Iles <jamie@jamieiles.com>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Christian Daudt <csd@broadcom.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        David Brown <davidb@codeaurora.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Shawn Guo <shawn.guo@linaro.org>, Barry Song <baohua.song@csr.com>,
        Tony Prisk <linux@prisktech.co.nz>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 04/20] ARM: picoxcell: Remove init_irq declaration in
 machine description
Message-ID: <20130514162046.GA16346@page>
References: <1368545933-7430-1-git-send-email-maxime.ripard@free-electrons.com>
 <1368545933-7430-5-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368545933-7430-5-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

Thanks for this, I'll add it to my tree.  I've modified it slightly to 
kill off the other irq includes, hopefully that's okay with you.

Thanks,

Jamie

8<---

>From 4b83f75a7af388aaf5f79ccf72c37074bc9166da Mon Sep 17 00:00:00 2001
From: Maxime Ripard <maxime.ripard@free-electrons.com>
Date: Tue, 14 May 2013 17:38:37 +0200
Subject: [PATCH] ARM: picoxcell: Remove init_irq declaration in machine
 description

Commit ebafed7a ("ARM: irq: Call irqchip_init if no init_irq function is
specified") removed the need to explictly setup the init_irq field in
the machine description when using only irqchip_init. Remove that
declaration for picoxcell as well.

[ jiles: removed other, unused irq includes. ]

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 arch/arm/mach-picoxcell/common.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm/mach-picoxcell/common.c b/arch/arm/mach-picoxcell/common.c
index f6f71bb..b069fa6 100644
--- a/arch/arm/mach-picoxcell/common.c
+++ b/arch/arm/mach-picoxcell/common.c
@@ -8,12 +8,8 @@
  * All enquiries to support@picochip.com
  */
 #include <linux/delay.h>
-#include <linux/irq.h>
-#include <linux/irqchip.h>
-#include <linux/irqdomain.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
-#include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/dw_apb_timer.h>
 
@@ -85,7 +81,6 @@ static void picoxcell_wdt_restart(char mode, const char *cmd)
 DT_MACHINE_START(PICOXCELL, "Picochip picoXcell")
 	.map_io		= picoxcell_map_io,
 	.nr_irqs	= NR_IRQS_LEGACY,
-	.init_irq	= irqchip_init,
 	.init_time	= dw_apb_timer_init,
 	.init_machine	= picoxcell_init_machine,
 	.dt_compat	= picoxcell_dt_match,
-- 
1.8.1.2

