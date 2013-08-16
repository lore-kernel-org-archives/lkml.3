Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab3HPSsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 14:48:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40400 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422Ab3HPSsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 14:48:00 -0400
Date: Fri, 16 Aug 2013 11:47:26 -0700
From: "tip-bot for Yan, Zheng" <tipbot@zytor.com>
Message-ID: <tip-77b339bce3e21f7a069447fc25a414b18e36fa2e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, zheng.z.yan@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, zheng.z.yan@intel.com,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1376375382-21350-4-git-send-email-zheng.z.yan@intel.com>
References: <1376375382-21350-4-git-send-email-zheng.z.yan@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/intel/uncore:
  Enable EV_SEL_EXT bit for PCU
Git-Commit-ID: 77b339bce3e21f7a069447fc25a414b18e36fa2e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 16 Aug 2013 11:47:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  77b339bce3e21f7a069447fc25a414b18e36fa2e
Gitweb:     http://git.kernel.org/tip/77b339bce3e21f7a069447fc25a414b18e36fa2e
Author:     Yan, Zheng <zheng.z.yan@intel.com>
AuthorDate: Tue, 13 Aug 2013 14:29:42 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 16 Aug 2013 17:55:50 +0200

perf/x86/intel/uncore: Enable EV_SEL_EXT bit for PCU

This patch adds support for the SNB-EP PCU uncore PMU extra_sel_bit
(bit 21) which is missing from the documentation in Table-2.75 of
Intel Xeon Processor E5-2600 Product Family Uncore Performance
Monitoring Guide. It is referred to later in Table-2.81. Without
this selection bit explicitly enabled by the kernel, some events
such as COREx_TRANSITION_CYCLES do not count correctly.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Reviewed-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1376375382-21350-4-git-send-email-zheng.z.yan@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 2 +-
 arch/x86/kernel/cpu/perf_event_intel_uncore.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 6b8b9c9..e9696d8 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -301,7 +301,7 @@ static struct attribute *snbep_uncore_cbox_formats_attr[] = {
 };
 
 static struct attribute *snbep_uncore_pcu_formats_attr[] = {
-	&format_attr_event.attr,
+	&format_attr_event_ext.attr,
 	&format_attr_occ_sel.attr,
 	&format_attr_edge.attr,
 	&format_attr_inv.attr,
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
index 628500e..a80ab71 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -117,6 +117,7 @@
 				(SNBEP_PMON_CTL_EV_SEL_MASK | \
 				 SNBEP_PCU_MSR_PMON_CTL_OCC_SEL_MASK | \
 				 SNBEP_PMON_CTL_EDGE_DET | \
+				 SNBEP_PMON_CTL_EV_SEL_EXT | \
 				 SNBEP_PMON_CTL_INVERT | \
 				 SNBEP_PCU_MSR_PMON_CTL_TRESH_MASK | \
 				 SNBEP_PCU_MSR_PMON_CTL_OCC_INVERT | \
