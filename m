Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab3BJF6i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 00:58:38 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:57863 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab3BJF6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 00:58:35 -0500
From: Len Brown <lenb@kernel.org>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        linux-sh@vger.kernel.org
Subject: [PATCH 03/16] sh idle: rename global pm_idle to static sh_idle
Date: Sun, 10 Feb 2013 00:58:10 -0500
Message-Id: <298823d45d644cb8aab67e59f0be0ebeeaf42039.1360475150.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1360475903-30007-1-git-send-email-lenb@kernel.org>
References: <1360475903-30007-1-git-send-email-lenb@kernel.org>
In-Reply-To: <2b219d07e0f287c2c713f5465fc8646158fa986e.1360475150.git.len.brown@intel.com>
References: <2b219d07e0f287c2c713f5465fc8646158fa986e.1360475150.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

SH idle code could use some simplification.
This patch enables that by guaranteeing
that "sh_idle" is local, and thus architecture specific.

Signed-off-by: Len Brown <len.brown@intel.com>
Cc: linux-sh@vger.kernel.org
---
 arch/sh/kernel/idle.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/sh/kernel/idle.c b/arch/sh/kernel/idle.c
index 0c91016..3d5a1b3 100644
--- a/arch/sh/kernel/idle.c
+++ b/arch/sh/kernel/idle.c
@@ -22,7 +22,7 @@
 #include <asm/smp.h>
 #include <asm/bl_bit.h>
 
-void (*pm_idle)(void);
+static void (*sh_idle)(void);
 
 static int hlt_counter;
 
@@ -103,9 +103,9 @@ void cpu_idle(void)
 			/* Don't trace irqs off for idle */
 			stop_critical_timings();
 			if (cpuidle_idle_call())
-				pm_idle();
+				sh_idle();
 			/*
-			 * Sanity check to ensure that pm_idle() returns
+			 * Sanity check to ensure that sh_idle() returns
 			 * with IRQs enabled
 			 */
 			WARN_ON(irqs_disabled());
@@ -123,13 +123,13 @@ void __init select_idle_routine(void)
 	/*
 	 * If a platform has set its own idle routine, leave it alone.
 	 */
-	if (pm_idle)
+	if (sh_idle)
 		return;
 
 	if (hlt_works())
-		pm_idle = default_idle;
+		sh_idle = default_idle;
 	else
-		pm_idle = poll_idle;
+		sh_idle = poll_idle;
 }
 
 void stop_this_cpu(void *unused)
-- 
1.8.1.3.535.ga923c31

