Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218Ab3IBHm6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 03:42:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52484 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172Ab3IBHmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 03:42:55 -0400
Date: Mon, 2 Sep 2013 00:42:18 -0700
From: tip-bot for Joe Perches <tipbot@zytor.com>
Message-ID: <tip-7bfb7e6bdd906f11ee9e751b3fec4f4fc728e818@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        joe@perches.com, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        joe@perches.com, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <f58599ae1a8d7b32d37e9cf283e95fba6452f7f6.1377809875.git.joe@perches.com>
References: <f58599ae1a8d7b32d37e9cf283e95fba6452f7f6.1377809875.git.joe@perches.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Convert kmalloc_node(...GFP_ZERO...)
  to kzalloc_node()
Git-Commit-ID: 7bfb7e6bdd906f11ee9e751b3fec4f4fc728e818
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 02 Sep 2013 00:42:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7bfb7e6bdd906f11ee9e751b3fec4f4fc728e818
Gitweb:     http://git.kernel.org/tip/7bfb7e6bdd906f11ee9e751b3fec4f4fc728e818
Author:     Joe Perches <joe@perches.com>
AuthorDate: Thu, 29 Aug 2013 13:59:17 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 2 Sep 2013 08:42:49 +0200

perf: Convert kmalloc_node(...GFP_ZERO...) to kzalloc_node()

Use the convenience function instead of __GFP_ZERO.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/f58599ae1a8d7b32d37e9cf283e95fba6452f7f6.1377809875.git.joe@perches.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_amd.c          | 3 +--
 arch/x86/kernel/cpu/perf_event_intel_ds.c     | 6 +++---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 2 +-
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 4cbe032..beeb7cc 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -347,8 +347,7 @@ static struct amd_nb *amd_alloc_nb(int cpu)
 	struct amd_nb *nb;
 	int i;
 
-	nb = kmalloc_node(sizeof(struct amd_nb), GFP_KERNEL | __GFP_ZERO,
-			  cpu_to_node(cpu));
+	nb = kzalloc_node(sizeof(struct amd_nb), GFP_KERNEL, cpu_to_node(cpu));
 	if (!nb)
 		return NULL;
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 442fcc2..63438aa 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -224,7 +224,7 @@ static int alloc_pebs_buffer(int cpu)
 	if (!x86_pmu.pebs)
 		return 0;
 
-	buffer = kmalloc_node(PEBS_BUFFER_SIZE, GFP_KERNEL | __GFP_ZERO, node);
+	buffer = kzalloc_node(PEBS_BUFFER_SIZE, GFP_KERNEL, node);
 	if (unlikely(!buffer))
 		return -ENOMEM;
 
@@ -262,7 +262,7 @@ static int alloc_bts_buffer(int cpu)
 	if (!x86_pmu.bts)
 		return 0;
 
-	buffer = kmalloc_node(BTS_BUFFER_SIZE, GFP_KERNEL | __GFP_ZERO, node);
+	buffer = kzalloc_node(BTS_BUFFER_SIZE, GFP_KERNEL, node);
 	if (unlikely(!buffer))
 		return -ENOMEM;
 
@@ -295,7 +295,7 @@ static int alloc_ds_buffer(int cpu)
 	int node = cpu_to_node(cpu);
 	struct debug_store *ds;
 
-	ds = kmalloc_node(sizeof(*ds), GFP_KERNEL | __GFP_ZERO, node);
+	ds = kzalloc_node(sizeof(*ds), GFP_KERNEL, node);
 	if (unlikely(!ds))
 		return -ENOMEM;
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 34c11ae..fd8011e 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2713,7 +2713,7 @@ struct intel_uncore_box *uncore_alloc_box(struct intel_uncore_type *type, int cp
 
 	size = sizeof(*box) + type->num_shared_regs * sizeof(struct intel_uncore_extra_reg);
 
-	box = kmalloc_node(size, GFP_KERNEL | __GFP_ZERO, cpu_to_node(cpu));
+	box = kzalloc_node(size, GFP_KERNEL, cpu_to_node(cpu));
 	if (!box)
 		return NULL;
 
