Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab3BJF6t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 00:58:49 -0500
Received: from mail-vb0-f49.google.com ([209.85.212.49]:45241 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab3BJF6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 00:58:43 -0500
From: Len Brown <lenb@kernel.org>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        linux-ia64@vger.kernel.org
Subject: [PATCH 09/16] ia64 idle: delete pm_idle
Date: Sun, 10 Feb 2013 00:58:16 -0500
Message-Id: <7dc2a692a27e9c3da86acf150c4a89024e48bd05.1360475150.git.len.brown@intel.com>
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

pm_idle() on ia64 was a synonym for default_idle().
So simply invoke default_idle() directly.

Signed-off-by: Len Brown <len.brown@intel.com>
Cc: linux-ia64@vger.kernel.org
---
 arch/ia64/kernel/process.c | 3 ---
 arch/ia64/kernel/setup.c   | 1 -
 2 files changed, 4 deletions(-)

diff --git a/arch/ia64/kernel/process.c b/arch/ia64/kernel/process.c
index 31360cb..e34f565 100644
--- a/arch/ia64/kernel/process.c
+++ b/arch/ia64/kernel/process.c
@@ -57,8 +57,6 @@ void (*ia64_mark_idle)(int);
 
 unsigned long boot_option_idle_override = IDLE_NO_OVERRIDE;
 EXPORT_SYMBOL(boot_option_idle_override);
-void (*pm_idle) (void);
-EXPORT_SYMBOL(pm_idle);
 void (*pm_power_off) (void);
 EXPORT_SYMBOL(pm_power_off);
 
@@ -301,7 +299,6 @@ cpu_idle (void)
 			if (mark_idle)
 				(*mark_idle)(1);
 
-			idle = pm_idle;
 			if (!idle)
 				idle = default_idle;
 			(*idle)();
diff --git a/arch/ia64/kernel/setup.c b/arch/ia64/kernel/setup.c
index aaefd9b..2029cc0 100644
--- a/arch/ia64/kernel/setup.c
+++ b/arch/ia64/kernel/setup.c
@@ -1051,7 +1051,6 @@ cpu_init (void)
 		max_num_phys_stacked = num_phys_stacked;
 	}
 	platform_cpu_init();
-	pm_idle = default_idle;
 }
 
 void __init
-- 
1.8.1.3.535.ga923c31

