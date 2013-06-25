Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab3FYALX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 20:11:23 -0400
Received: from mail-ye0-f171.google.com ([209.85.213.171]:54088 "EHLO
	mail-ye0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab3FYALV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 20:11:21 -0400
X-Greylist: delayed 452 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Jun 2013 20:11:20 EDT
From: Fabio Estevam <festevam@gmail.com>
To: john.stultz@linaro.org
Cc: tglx@linutronix.de, shc_work@mail.ru, linux-kernel@vger.kernel.org,
        sboyd@codeaurora.org, Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] ARM: mach-clps711x: common: Use linux/sched_clock.h
Date: Mon, 24 Jun 2013 21:03:35 -0300
Message-Id: <1372118615-14805-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Commit 38ff87f7 (sched_clock: Make ARM's sched_clock generic for all 
architectures) changed the header to <linux/sched_clock.h>, so adapt it in order
to fix the following build error:

arch/arm/mach-clps711x/common.c:37:29: fatal error: asm/sched_clock.h: No such file or directory

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 arch/arm/mach-clps711x/common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-clps711x/common.c b/arch/arm/mach-clps711x/common.c
index 4ca2f3c..134641d 100644
--- a/arch/arm/mach-clps711x/common.c
+++ b/arch/arm/mach-clps711x/common.c
@@ -29,12 +29,12 @@
 #include <linux/clockchips.h>
 #include <linux/clocksource.h>
 #include <linux/clk-provider.h>
+#include <linux/sched_clock.h>
 
 #include <asm/exception.h>
 #include <asm/mach/irq.h>
 #include <asm/mach/map.h>
 #include <asm/mach/time.h>
-#include <asm/sched_clock.h>
 #include <asm/system_misc.h>
 
 #include <mach/hardware.h>
-- 
1.8.1.2

