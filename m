Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524Ab3EJG3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 02:29:41 -0400
Received: from mail-da0-f43.google.com ([209.85.210.43]:55084 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab3EJG3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 02:29:40 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, sachin.kamat@linaro.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Nicolas Pitre <nico@linaro.org>
Subject: [PATCH 1/1] ARM: mcpm: Fix build error with gic_secondary_init call
Date: Fri, 10 May 2013 11:45:26 +0530
Message-Id: <1368166526-12525-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c0114709ed ("irqchip: gic: Perform the gic_secondary_init()
call via CPU notifier") removed all platform calls to gic_secondary_init.
Since this file got merged after the removal of the above call, this
function got left out in the current file which is causing the following
build error:
arch/arm/common/mcpm_platsmp.c:52:2: error: implicit declaration of function
‘gic_secondary_init’ [-Werror=implicit-function-declaration]
gic_secondary_init(0);

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Nicolas Pitre <nico@linaro.org>
---
Compile tested only.
---
 arch/arm/common/mcpm_platsmp.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm/common/mcpm_platsmp.c b/arch/arm/common/mcpm_platsmp.c
index 52b88d8..3caed0d 100644
--- a/arch/arm/common/mcpm_platsmp.c
+++ b/arch/arm/common/mcpm_platsmp.c
@@ -15,8 +15,6 @@
 #include <linux/smp.h>
 #include <linux/spinlock.h>
 
-#include <linux/irqchip/arm-gic.h>
-
 #include <asm/mcpm.h>
 #include <asm/smp.h>
 #include <asm/smp_plat.h>
@@ -49,7 +47,6 @@ static int __cpuinit mcpm_boot_secondary(unsigned int cpu, struct task_struct *i
 static void __cpuinit mcpm_secondary_init(unsigned int cpu)
 {
 	mcpm_cpu_powered_up();
-	gic_secondary_init(0);
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-- 
1.7.9.5

