Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab3H0VaX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 17:30:23 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:46065 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab3H0V2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 17:28:25 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFC v2 07/16] ARM: mvebu: remove custom .init_time hook
Date: Tue, 27 Aug 2013 23:28:01 +0200
Message-Id: <1377638890-371-8-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With arch/arm calling of_clk_init(NULL) from time_init(), we can now
remove custom .init_time hooks.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Changelog:
v1->v2:
- only remove of_clk_init from custom timer hook, further cleanup
  will be carried out later (Reported by Gregory Clement)

Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-mvebu/armada-370-xp.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-mvebu/armada-370-xp.c b/arch/arm/mach-mvebu/armada-370-xp.c
index 829b573..164c62b 100644
--- a/arch/arm/mach-mvebu/armada-370-xp.c
+++ b/arch/arm/mach-mvebu/armada-370-xp.c
@@ -14,7 +14,6 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/clk-provider.h>
 #include <linux/of_address.h>
 #include <linux/of_platform.h>
 #include <linux/io.h>
@@ -36,7 +35,6 @@ static void __init armada_370_xp_map_io(void)
 
 static void __init armada_370_xp_timer_and_clk_init(void)
 {
-	of_clk_init(NULL);
 	armada_370_xp_timer_init();
 	coherency_init();
 	BUG_ON(mvebu_mbus_dt_init());
-- 
1.7.2.5

