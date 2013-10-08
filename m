Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab3JHNqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:46:53 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:60745 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157Ab3JHNqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:46:23 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: manual merge of the mvebu tree
Date: Tue,  8 Oct 2013 15:44:13 +0200
Message-Id: <1381239855-16314-3-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381239855-16314-1-git-send-email-treding@nvidia.com>
References: <1381239855-16314-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's linux-next merge of the mvebu tree got conflicts in:

	arch/arm/mach-dove/board-dt.c

caused by commits ffe195c (ARM: dove: remove legacy pcie and clock init),
e3730b4 (ARM: dove: switch to DT probed mbus address windows), and 51e40f5
(ARM: dove: remove custom .init_time hook).

I fixed them up (see below). Please verify that the resolution looks
correct.

Thanks,
Thierry
---
diff --cc arch/arm/mach-dove/board-dt.c
index ddb8663,9a116d7..49fa9ab
--- a/arch/arm/mach-dove/board-dt.c
+++ b/arch/arm/mach-dove/board-dt.c
@@@ -17,37 -20,15 +17,8 @@@
  #include <mach/dove.h>
  #include <mach/pm.h>
  #include <plat/common.h>
 -#include <plat/irq.h>
  #include "common.h"
  
- /*
-  * There are still devices that doesn't even know about DT,
-  * get clock gates here and add a clock lookup.
-  */
- static void __init dove_legacy_clk_init(void)
- {
- 	struct device_node *np = of_find_compatible_node(NULL, NULL,
- 					 "marvell,dove-gating-clock");
- 	struct of_phandle_args clkspec;
- 
- 	clkspec.np = np;
- 	clkspec.args_count = 1;
- 
- 	clkspec.args[0] = CLOCK_GATING_BIT_PCIE0;
- 	orion_clkdev_add("0", "pcie",
- 			 of_clk_get_from_provider(&clkspec));
- 
- 	clkspec.args[0] = CLOCK_GATING_BIT_PCIE1;
- 	orion_clkdev_add("1", "pcie",
- 			 of_clk_get_from_provider(&clkspec));
- }
- 
- static void __init dove_dt_init_early(void)
 -static void __init dove_dt_time_init(void)
--{
- 	mvebu_mbus_init("marvell,dove-mbus",
- 			BRIDGE_WINS_BASE, BRIDGE_WINS_SZ,
- 			DOVE_MC_WINS_BASE, DOVE_MC_WINS_SZ);
 -	of_clk_init(NULL);
 -	clocksource_of_init();
--}
--
  static void __init dove_dt_init(void)
  {
  	pr_info("Dove 88AP510 SoC\n");
@@@ -73,7 -47,7 +37,6 @@@ static const char * const dove_dt_board
  
  DT_MACHINE_START(DOVE_DT, "Marvell Dove (Flattened Device Tree)")
  	.map_io		= dove_map_io,
- 	.init_early	= dove_dt_init_early,
 -	.init_time	= dove_dt_time_init,
  	.init_machine	= dove_dt_init,
  	.restart	= dove_restart,
  	.dt_compat	= dove_dt_board_compat,
