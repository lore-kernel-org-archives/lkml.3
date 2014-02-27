Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbaB0Ma1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:30:27 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:42946 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbaB0Ma0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:30:26 -0500
Date: Thu, 27 Feb 2014 17:58:12 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        josh@joshtriplett.org
Subject: [PATCH 40/46] kernel: Include appropriate header file in
 kernel/sched/core.c
Message-ID: <974993179b4fb4ac002da6a094df7120a8cc00cc.1393493277.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include appropriate header file include/linux/sched.h in
kernel/sched/core.c because it containes prototype declaration of
function defined in kernel/sched/core.c. Also, fix the typo error in
prototype declaration of function 'arch_sd_sibling_asym_packing’ in
include/linux/sched.h.

This eliminates the following warning in sched/core.c:
kernel/sched/core.c:5814:12: warning: no previous prototype for ‘arch_sd_sibling_asym_packing’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/sched.h |    2 +-
 kernel/sched/core.c   |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index fac6f9d..56aa7ee 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -866,7 +866,7 @@ enum cpu_idle_type {
 #define SD_OVERLAP		0x2000	/* sched_domains of this level overlap */
 #define SD_NUMA			0x4000	/* cross-node balancing */
 
-extern int __weak arch_sd_sibiling_asym_packing(void);
+extern int __weak arch_sd_sibling_asym_packing(void);
 
 struct sched_domain_attr {
 	int relax_domain_level;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 90570e1..9c3df36 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -72,6 +72,7 @@
 #include <linux/slab.h>
 #include <linux/init_task.h>
 #include <linux/binfmts.h>
+#include <linux/sched.h>
 #include <linux/context_tracking.h>
 
 #include <asm/switch_to.h>
-- 
1.7.9.5

