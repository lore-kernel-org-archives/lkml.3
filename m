Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab3BJF6x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 00:58:53 -0500
Received: from mail-vb0-f51.google.com ([209.85.212.51]:37733 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab3BJF6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 00:58:42 -0500
From: Len Brown <lenb@kernel.org>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        linux-cris-kernel@axis.com
Subject: [PATCH 08/16] cris idle: delete idle and pm_idle
Date: Sun, 10 Feb 2013 00:58:15 -0500
Message-Id: <128d290dacc38d1a3d09031018adf017eec0b5f2.1360475150.git.len.brown@intel.com>
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

pm_idle() and idle() served no purpose on cris --
invoke default_idle() directly.

Signed-off-by: Len Brown <len.brown@intel.com>
Cc: linux-cris-kernel@axis.com
---
 arch/cris/kernel/process.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/arch/cris/kernel/process.c b/arch/cris/kernel/process.c
index 7f65be6..104ff4d 100644
--- a/arch/cris/kernel/process.c
+++ b/arch/cris/kernel/process.c
@@ -54,11 +54,6 @@ void enable_hlt(void)
 
 EXPORT_SYMBOL(enable_hlt);
  
-/*
- * The following aren't currently used.
- */
-void (*pm_idle)(void);
-
 extern void default_idle(void);
 
 void (*pm_power_off)(void);
@@ -77,16 +72,12 @@ void cpu_idle (void)
 	while (1) {
 		rcu_idle_enter();
 		while (!need_resched()) {
-			void (*idle)(void);
 			/*
 			 * Mark this as an RCU critical section so that
 			 * synchronize_kernel() in the unload path waits
 			 * for our completion.
 			 */
-			idle = pm_idle;
-			if (!idle)
-				idle = default_idle;
-			idle();
+			default_idle();
 		}
 		rcu_idle_exit();
 		schedule_preempt_disabled();
-- 
1.8.1.3.535.ga923c31

