Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab3G2Mcw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 08:32:52 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:49835 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598Ab3G2McH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 08:32:07 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] ARM: dove: switch to DT probed mbus address windows
Date: Mon, 29 Jul 2013 14:31:54 +0200
Message-Id: <1375101114-28858-6-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1375101114-28858-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1375101114-28858-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With proper mbus ranges and all internal nodes moved over, we can now
switch from static address window allocation to DT probed allocation.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-dove/board-dt.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/arch/arm/mach-dove/board-dt.c b/arch/arm/mach-dove/board-dt.c
index 49f72a8..1efbe1d 100644
--- a/arch/arm/mach-dove/board-dt.c
+++ b/arch/arm/mach-dove/board-dt.c
@@ -51,13 +51,6 @@ static void __init dove_dt_time_init(void)
 	clocksource_of_init();
 }
 
-static void __init dove_dt_init_early(void)
-{
-	mvebu_mbus_init("marvell,dove-mbus",
-			BRIDGE_WINS_BASE, BRIDGE_WINS_SZ,
-			DOVE_MC_WINS_BASE, DOVE_MC_WINS_SZ);
-}
-
 static void __init dove_dt_init(void)
 {
 	pr_info("Dove 88AP510 SoC\n");
@@ -65,7 +58,7 @@ static void __init dove_dt_init(void)
 #ifdef CONFIG_CACHE_TAUROS2
 	tauros2_init(0);
 #endif
-	dove_setup_cpu_wins();
+	BUG_ON(mvebu_mbus_dt_init());
 
 	/* Setup clocks for legacy devices */
 	dove_legacy_clk_init();
@@ -83,7 +76,6 @@ static const char * const dove_dt_board_compat[] = {
 
 DT_MACHINE_START(DOVE_DT, "Marvell Dove (Flattened Device Tree)")
 	.map_io		= dove_map_io,
-	.init_early	= dove_dt_init_early,
 	.init_time	= dove_dt_time_init,
 	.init_machine	= dove_dt_init,
 	.restart	= dove_restart,
-- 
1.7.10.4

