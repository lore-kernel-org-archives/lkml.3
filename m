Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161115Ab3BNWsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 17:48:05 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:58499 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161102Ab3BNWsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 17:48:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 1/9] ARM: arch_timer: include linux/errno.h
Date: Thu, 14 Feb 2013 23:47:43 +0100
Message-Id: <1360882071-4072668-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360882071-4072668-1-git-send-email-arnd@arndb.de>
References: <1360882071-4072668-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:6rTM2SIG/1MdtumRu1Eq6VoPeJqjcKm/6g8qFk0PfeD
 4GDZwfcdBdRaECcDue5YoxWboaUS2zXSkCokmIVyawLehbZk4u
 DWQbTH9BbP9oQQZ4+JJzWm1SuTwSLy53eOO5WUdKQYXyoWhzVw
 X3bebEsuHKObDhq1Ms1NrbqsWkVCh6uy29oaCmusP1Y26O6uzY
 ZVZwGH694ypWucUMgl376yJOu24EnQ7Y6md0Vrpadtc3/9IDOU
 cz1exwhm8lVb33YUAR+WPrskr4lZDWuEpwJSGswH8hcgotYoBp
 NFww5clIbsliB4glHf9He77zdG8klJ+YLe/45g2qEphDhDmM5R
 M6t0O43K/QgodSKQ8xbV95ZA4IEff+MbOdR2PcKjy
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 8a4da6e "arm: arch_timer: move core to drivers/clocksource"
moved a lot of code out of arch_timer.c, but ended up deleting
too much, which broke some configurations.

Obviously, include linux/errno.h is required to return error
values.

Without this patch, building allmodconfig results in:

arch/arm/kernel/arch_timer.c: In function 'arch_timer_sched_clock_init':
arch/arm/kernel/arch_timer.c:55:11: error: 'ENXIO' undeclared (first use in this function)
arch/arm/kernel/arch_timer.c:55:11: note: each undeclared identifier is reported only once for each function it appears in

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kernel/arch_timer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/kernel/arch_timer.c b/arch/arm/kernel/arch_timer.c
index 36ebcf4..d957a51 100644
--- a/arch/arm/kernel/arch_timer.c
+++ b/arch/arm/kernel/arch_timer.c
@@ -10,6 +10,7 @@
  */
 #include <linux/init.h>
 #include <linux/types.h>
+#include <linux/errno.h>
 
 #include <asm/delay.h>
 #include <asm/sched_clock.h>
-- 
1.8.1.2

