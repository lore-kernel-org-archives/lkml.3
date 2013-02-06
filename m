Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732Ab3BFR2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 12:28:50 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:16242
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755941Ab3BFR0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 12:26:35 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1155h)
X-WSS-ID: 0MHT745-01-175-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        <linux-kernel@vger.kernel.org>, Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 3/6] perf, amd: Use proper naming scheme for AMD bit field definitions
Date: Wed, 6 Feb 2013 11:26:26 -0600
Message-ID: <1360171589-6381-4-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360171589-6381-1-git-send-email-jacob.shin@amd.com>
References: <1360171589-6381-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update these AMD bit field names to be consistent with naming
convention followed by the rest of the file.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
Acked-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/include/asm/perf_event.h    |    4 ++--
 arch/x86/kernel/cpu/perf_event_amd.c |    8 ++++----
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
-- 
1.7.9.5


