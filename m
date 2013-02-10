Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab3BJGBh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 01:01:37 -0500
Received: from mail-vb0-f41.google.com ([209.85.212.41]:33573 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab3BJF6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 00:58:39 -0500
From: Len Brown <lenb@kernel.org>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 06/16] ARM idle: delete pm_idle
Date: Sun, 10 Feb 2013 00:58:13 -0500
Message-Id: <9838a4aeee256adeaef90efe56df2c9988206982.1360475150.git.len.brown@intel.com>
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

pm_idle() on ARM was a synonym for default_idle(),
so simply invoke default_idle() directly.

Signed-off-by: Len Brown <len.brown@intel.com>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/kernel/process.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index c6dec5f..047d3e4 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -172,14 +172,9 @@ static void default_idle(void)
 	local_irq_enable();
 }
 
-void (*pm_idle)(void) = default_idle;
-EXPORT_SYMBOL(pm_idle);
-
 /*
- * The idle thread, has rather strange semantics for calling pm_idle,
- * but this is what x86 does and we need to do the same, so that
- * things like cpuidle get called in the same way.  The only difference
- * is that we always respect 'hlt_counter' to prevent low power idle.
+ * The idle thread.
+ * We always respect 'hlt_counter' to prevent low power idle.
  */
 void cpu_idle(void)
 {
@@ -210,10 +205,10 @@ void cpu_idle(void)
 			} else if (!need_resched()) {
 				stop_critical_timings();
 				if (cpuidle_idle_call())
-					pm_idle();
+					default_idle();
 				start_critical_timings();
 				/*
-				 * pm_idle functions must always
+				 * default_idle functions must always
 				 * return with IRQs enabled.
 				 */
 				WARN_ON(irqs_disabled());
-- 
1.8.1.3.535.ga923c31

