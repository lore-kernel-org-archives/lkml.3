Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab3BJF6v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 00:58:51 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:34182 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab3BJF6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 00:58:40 -0500
From: Len Brown <lenb@kernel.org>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 07/16] ARM64 idle: delete pm_idle
Date: Sun, 10 Feb 2013 00:58:14 -0500
Message-Id: <c09e2c0f2928cfe6173bcafe0d906bf87287d5c2.1360475150.git.len.brown@intel.com>
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

pm_idle() on arm64 was a synonym for default_idle(),
so remove it and invoke default_idle() directly.

Signed-off-by: Len Brown <len.brown@intel.com>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm64/kernel/process.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index cb0956b..c7002d4 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -97,14 +97,9 @@ static void default_idle(void)
 	local_irq_enable();
 }
 
-void (*pm_idle)(void) = default_idle;
-EXPORT_SYMBOL_GPL(pm_idle);
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
@@ -122,10 +117,10 @@ void cpu_idle(void)
 			local_irq_disable();
 			if (!need_resched()) {
 				stop_critical_timings();
-				pm_idle();
+				default_idle();
 				start_critical_timings();
 				/*
-				 * pm_idle functions should always return
+				 * default_idle functions should always return
 				 * with IRQs enabled.
 				 */
 				WARN_ON(irqs_disabled());
-- 
1.8.1.3.535.ga923c31

