Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab3GJIwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 04:52:51 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:64106 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab3GJIwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 04:52:49 -0400
Date: Wed, 10 Jul 2013 10:52:43 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20130710085243.GA25545@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   HEAD: e5302920da9ef23f9d19d4e9ac85704cc25bee7a perf: Fix interrupt handler timing harness

Two small fixlets.

 Thanks,

	Ingo

------------------>
Peter Zijlstra (1):
      perf/x86/amd: Do not print an error when the device is not present

Stephane Eranian (1):
      perf: Fix interrupt handler timing harness


 arch/x86/kernel/cpu/perf_event_amd_iommu.c | 4 +---
 kernel/events/core.c                       | 4 ++--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_iommu.c b/arch/x86/kernel/cpu/perf_event_amd_iommu.c
index 0db655e..639d128 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_iommu.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_iommu.c
@@ -491,10 +491,8 @@ static struct perf_amd_iommu __perf_iommu = {
 static __init int amd_iommu_pc_init(void)
 {
 	/* Make sure the IOMMU PC resource is available */
-	if (!amd_iommu_pc_supported()) {
-		pr_err("perf: amd_iommu PMU not installed. No support!\n");
+	if (!amd_iommu_pc_supported())
 		return -ENODEV;
-	}
 
 	_init_perf_amd_iommu(&__perf_iommu, "amd_iommu");
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1db3af9..1833bc5 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -182,7 +182,7 @@ void update_perf_cpu_limits(void)
 	u64 tmp = perf_sample_period_ns;
 
 	tmp *= sysctl_perf_cpu_time_max_percent;
-	tmp = do_div(tmp, 100);
+	do_div(tmp, 100);
 	atomic_set(&perf_sample_allowed_ns, tmp);
 }
 
@@ -232,7 +232,7 @@ DEFINE_PER_CPU(u64, running_sample_length);
 void perf_sample_event_took(u64 sample_len_ns)
 {
 	u64 avg_local_sample_len;
-	u64 local_samples_len = __get_cpu_var(running_sample_length);
+	u64 local_samples_len;
 
 	if (atomic_read(&perf_sample_allowed_ns) == 0)
 		return;
