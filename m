Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529Ab3HMQvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:51:42 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:34215 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab3HMQvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:51:40 -0400
Date: Tue, 13 Aug 2013 18:51:33 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20130813165133.GA6679@gmail.com>
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

   HEAD: 0499bd867bd17c0a88963551a1583b8efc7b03d7 perf/x86: Add Haswell ULT model number used in Macbook Air and other systems

Two small fixlets.

 Thanks,

	Ingo

------------------>
Andi Kleen (1):
      perf/x86: Add Haswell ULT model number used in Macbook Air and other systems

Vince Weaver (1):
      perf/x86: Fix intel QPI uncore event definitions


 arch/x86/kernel/cpu/perf_event_intel.c        | 1 +
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index fbc9210..a45d8d4 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2270,6 +2270,7 @@ __init int intel_pmu_init(void)
 	case 70:
 	case 71:
 	case 63:
+	case 69:
 		x86_pmu.late_ack = true;
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids, sizeof(hw_cache_event_ids));
 		memcpy(hw_cache_extra_regs, snb_hw_cache_extra_regs, sizeof(hw_cache_extra_regs));
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index cad791d..1fb6c72 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -314,8 +314,8 @@ static struct uncore_event_desc snbep_uncore_imc_events[] = {
 static struct uncore_event_desc snbep_uncore_qpi_events[] = {
 	INTEL_UNCORE_EVENT_DESC(clockticks,       "event=0x14"),
 	INTEL_UNCORE_EVENT_DESC(txl_flits_active, "event=0x00,umask=0x06"),
-	INTEL_UNCORE_EVENT_DESC(drs_data,         "event=0x02,umask=0x08"),
-	INTEL_UNCORE_EVENT_DESC(ncb_data,         "event=0x03,umask=0x04"),
+	INTEL_UNCORE_EVENT_DESC(drs_data,         "event=0x102,umask=0x08"),
+	INTEL_UNCORE_EVENT_DESC(ncb_data,         "event=0x103,umask=0x04"),
 	{ /* end: all zeroes */ },
 };
 
