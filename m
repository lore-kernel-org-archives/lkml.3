Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302AbaI3BgK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 21:36:10 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:48524 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169AbaI3BgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 21:36:01 -0400
From: Brian Norris <computersforpeace@gmail.com>
To: <linux-arm-kernel@lists.infradead.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: [PATCH 4/5] ARM: vexpress: drop unnecessary include
Date: Mon, 29 Sep 2014 18:35:29 -0700
Message-Id: <1412040930-16864-5-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412040930-16864-1-git-send-email-computersforpeace@gmail.com>
References: <1412040930-16864-1-git-send-email-computersforpeace@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<asm/cp15.h> is only being included because of the implicit requirements
of v7_exit_coherency_flush(). Now that the implicit include is provided
for us, we can drop it from our explicit list.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
---
 arch/arm/mach-vexpress/dcscb.c  | 1 -
 arch/arm/mach-vexpress/tc2_pm.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/arch/arm/mach-vexpress/dcscb.c b/arch/arm/mach-vexpress/dcscb.c
index 30b993399ed7..28b0a33c91e1 100644
--- a/arch/arm/mach-vexpress/dcscb.c
+++ b/arch/arm/mach-vexpress/dcscb.c
@@ -22,7 +22,6 @@
 #include <asm/proc-fns.h>
 #include <asm/cacheflush.h>
 #include <asm/cputype.h>
-#include <asm/cp15.h>
 
 
 #define RST_HOLD0	0x0
diff --git a/arch/arm/mach-vexpress/tc2_pm.c b/arch/arm/mach-vexpress/tc2_pm.c
index 2fb78b4648cb..bc596f7d0d85 100644
--- a/arch/arm/mach-vexpress/tc2_pm.c
+++ b/arch/arm/mach-vexpress/tc2_pm.c
@@ -26,7 +26,6 @@
 #include <asm/proc-fns.h>
 #include <asm/cacheflush.h>
 #include <asm/cputype.h>
-#include <asm/cp15.h>
 
 #include <linux/arm-cci.h>
 
-- 
1.9.1

