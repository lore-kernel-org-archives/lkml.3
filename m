Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223Ab3H2U7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 16:59:21 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:44422 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755430Ab3H2U7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 16:59:20 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: [PATCH] perf_event: Convert kmalloc_node(...GFP_ZERO...) to kzalloc_node
Date: Thu, 29 Aug 2013 13:59:17 -0700
Message-Id: <f58599ae1a8d7b32d37e9cf283e95fba6452f7f6.1377809875.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the convenience function instead of __GFP_ZERO.

Signed-off-by: Joe Perches <joe@perches.com>
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
index 3065c57..88cfbbd 100644
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
 
-- 
1.8.1.2.459.gbcd45b4.dirty

