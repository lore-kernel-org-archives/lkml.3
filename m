Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab3BDLIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:08:45 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5061 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab3BDLIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:08:43 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 04 Feb 2013 03:08:43 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <linux-kernel@vger.kernel.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, <linux-tegra@vger.kernel.org>,
        Sami Liedes <sliedes@nvidia.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 1/2] ARM: tegra: Fix build error for gic update
Date: Mon, 4 Feb 2013 13:08:18 +0200
Message-ID: <1359976100-28871-1-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix build error in board-dt-tegra114.c(next-20130204)

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
Reported-by: Sami Liedes<sliedes@nvidia.com>
---
 arch/arm/mach-tegra/board-dt-tegra114.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/mach-tegra/board-dt-tegra114.c b/arch/arm/mach-tegra/board-dt-tegra114.c
index 3ed17ce..72598e2 100644
--- a/arch/arm/mach-tegra/board-dt-tegra114.c
+++ b/arch/arm/mach-tegra/board-dt-tegra114.c
@@ -19,7 +19,6 @@
 #include <linux/clocksource.h>
 
 #include <asm/mach/arch.h>
-#include <asm/hardware/gic.h>
 
 #include "board.h"
 #include "common.h"
@@ -39,7 +38,6 @@ DT_MACHINE_START(TEGRA114_DT, "NVIDIA Tegra114 (Flattened Device Tree)")
 	.map_io		= tegra_map_common_io,
 	.init_early	= tegra30_init_early,
 	.init_irq	= tegra_dt_init_irq,
-	.handle_irq	= gic_handle_irq,
 	.init_time	= clocksource_of_init,
 	.init_machine	= tegra114_dt_init,
 	.init_late	= tegra_init_late,
-- 
1.7.9.5

