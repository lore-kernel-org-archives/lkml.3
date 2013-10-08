Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab3JHIuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 04:50:44 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:39454 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603Ab3JHIuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 04:50:37 -0400
Message-ID: <5253C759.5020406@gmail.com>
Date: Tue, 08 Oct 2013 10:50:33 +0200
From: Simon Barth <simon.pe.barth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: mach-omap2: board-generic: fix undefined symbol
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since dra7 reuses the  function 'omap5_realtime_timer_init' in
arch/arm/mach-omap2/board-generic.c as timer init function, it has to be
built for this SoC as well.

Signed-off-by: Simon Barth <Simon.Pe.Barth@gmail.com>
---
 arch/arm/mach-omap2/timer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index fa74a06..ead48fa 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -628,7 +628,7 @@ void __init omap4_local_timer_init(void)
 #endif /* CONFIG_HAVE_ARM_TWD */
 #endif /* CONFIG_ARCH_OMAP4 */

-#ifdef CONFIG_SOC_OMAP5
+#if defined(CONFIG_SOC_OMAP5) || defined(CONFIG_SOC_DRA7XX)
 void __init omap5_realtime_timer_init(void)
 {
 	omap4_sync32k_timer_init();
@@ -636,7 +636,7 @@ void __init omap5_realtime_timer_init(void)

 	clocksource_of_init();
 }
-#endif /* CONFIG_SOC_OMAP5 */
+#endif /* CONFIG_SOC_OMAP5 || CONFIG_SOC_DRA7XX */

 /**
  * omap_timer_init - build and register timer device with an
-- 
1.7.9.5
