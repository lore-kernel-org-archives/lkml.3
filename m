Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172Ab3BFUbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:31:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36416 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756968Ab3BFUa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 15:30:57 -0500
Date: Wed, 6 Feb 2013 12:30:30 -0800
From: tip-bot for Jacob Shin <jacob.shin@amd.com>
Message-ID: <tip-9f19010af8c651879ac2c36f1a808a3a4419cd40@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, jolsa@redhat.com, jacob.shin@amd.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, jacob.shin@amd.com, tglx@linutronix.de,
        jolsa@redhat.com
In-Reply-To: <1360171589-6381-4-git-send-email-jacob.shin@amd.com>
References: <1360171589-6381-4-git-send-email-jacob.shin@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/amd:
  Use proper naming scheme for AMD bit field definitions
Git-Commit-ID: 9f19010af8c651879ac2c36f1a808a3a4419cd40
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 06 Feb 2013 12:30:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9f19010af8c651879ac2c36f1a808a3a4419cd40
Gitweb:     http://git.kernel.org/tip/9f19010af8c651879ac2c36f1a808a3a4419cd40
Author:     Jacob Shin <jacob.shin@amd.com>
AuthorDate: Wed, 6 Feb 2013 11:26:26 -0600
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Feb 2013 19:45:23 +0100

perf/x86/amd: Use proper naming scheme for AMD bit field definitions

Update these AMD bit field names to be consistent with naming
convention followed by the rest of the file.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
Acked-by: Stephane Eranian <eranian@google.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1360171589-6381-4-git-send-email-jacob.shin@amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/perf_event.h    | 4 ++--
 arch/x86/kernel/cpu/perf_event_amd.c | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 4fabcdf..2234eaaec 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -29,8 +29,8 @@
 #define ARCH_PERFMON_EVENTSEL_INV			(1ULL << 23)
 #define ARCH_PERFMON_EVENTSEL_CMASK			0xFF000000ULL
 
-#define AMD_PERFMON_EVENTSEL_GUESTONLY			(1ULL << 40)
-#define AMD_PERFMON_EVENTSEL_HOSTONLY			(1ULL << 41)
+#define AMD64_EVENTSEL_GUESTONLY			(1ULL << 40)
+#define AMD64_EVENTSEL_HOSTONLY				(1ULL << 41)
 
 #define AMD64_EVENTSEL_EVENT	\
 	(ARCH_PERFMON_EVENTSEL_EVENT | (0x0FULL << 32))
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index f8c9dfb..aea8c20 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -156,9 +156,9 @@ static int amd_pmu_hw_config(struct perf_event *event)
 		event->hw.config &= ~(ARCH_PERFMON_EVENTSEL_USR |
 				      ARCH_PERFMON_EVENTSEL_OS);
 	else if (event->attr.exclude_host)
-		event->hw.config |= AMD_PERFMON_EVENTSEL_GUESTONLY;
+		event->hw.config |= AMD64_EVENTSEL_GUESTONLY;
 	else if (event->attr.exclude_guest)
-		event->hw.config |= AMD_PERFMON_EVENTSEL_HOSTONLY;
+		event->hw.config |= AMD64_EVENTSEL_HOSTONLY;
 
 	if (event->attr.type != PERF_TYPE_RAW)
 		return 0;
@@ -336,7 +336,7 @@ static void amd_pmu_cpu_starting(int cpu)
 	struct amd_nb *nb;
 	int i, nb_id;
 
-	cpuc->perf_ctr_virt_mask = AMD_PERFMON_EVENTSEL_HOSTONLY;
+	cpuc->perf_ctr_virt_mask = AMD64_EVENTSEL_HOSTONLY;
 
 	if (boot_cpu_data.x86_max_cores < 2)
 		return;
@@ -669,7 +669,7 @@ void amd_pmu_disable_virt(void)
 	 * SVM is disabled the Guest-only bits still gets set and the counter
 	 * will not count anything.
 	 */
-	cpuc->perf_ctr_virt_mask = AMD_PERFMON_EVENTSEL_HOSTONLY;
+	cpuc->perf_ctr_virt_mask = AMD64_EVENTSEL_HOSTONLY;
 
 	/* Reload all events */
 	x86_pmu_disable_all();
