Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362Ab3EDIUz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 04:20:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52710 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab3EDIUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 04:20:53 -0400
Date: Sat, 4 May 2013 01:20:32 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-jwra43mujrv1oq9xk6mfe57v@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, stable@kernel.org, ak@linux.intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, stable@kernel.org, ak@linux.intel.com,
        tglx@linutronix.de
In-Reply-To: <20130503121256.083340271@chello.nl>
References: <20130503121256.083340271@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86:
  Blacklist all MEM_*_RETIRED events for Ivy Bridge
Git-Commit-ID: 741a698f420c34c458294a6accecfbad702a7c52
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  741a698f420c34c458294a6accecfbad702a7c52
Gitweb:     http://git.kernel.org/tip/741a698f420c34c458294a6accecfbad702a7c52
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 3 May 2013 14:11:23 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 4 May 2013 08:37:46 +0200

perf/x86: Blacklist all MEM_*_RETIRED events for Ivy Bridge

Errata BV98 states that all MEM_*_RETIRED events corrupt the
counter value of the SMT sibling's counters. Blacklist these
events

Reported-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: <stable@kernel.org>
Cc: eranian@google.com
Link: http://lkml.kernel.org/r/20130503121256.083340271@chello.nl
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/n/tip-jwra43mujrv1oq9xk6mfe57v@git.kernel.org
---
 arch/x86/kernel/cpu/perf_event_intel.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index cc45deb..4a0a462 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -125,10 +125,15 @@ static struct event_constraint intel_ivb_event_constraints[] __read_mostly =
 	INTEL_UEVENT_CONSTRAINT(0x08a3, 0x4), /* CYCLE_ACTIVITY.CYCLES_L1D_PENDING */
 	INTEL_UEVENT_CONSTRAINT(0x0ca3, 0x4), /* CYCLE_ACTIVITY.STALLS_L1D_PENDING */
 	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PREC_DIST */
-	INTEL_EVENT_CONSTRAINT(0xd0, 0xf), /* MEM_UOPS_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xd1, 0xf), /* MEM_LOAD_UOPS_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xd2, 0xf), /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xd3, 0xf), /*  MEM_LOAD_UOPS_LLC_MISS_RETIRED.* */
+	/*
+	 * Errata BV98 -- MEM_*_RETIRED events can leak between counters of SMT
+	 * siblings; disable these events because they can corrupt unrelated
+	 * counters.
+	 */
+	INTEL_EVENT_CONSTRAINT(0xd0, 0x0), /* MEM_UOPS_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xd1, 0x0), /* MEM_LOAD_UOPS_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xd2, 0x0), /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xd3, 0x0), /* MEM_LOAD_UOPS_LLC_MISS_RETIRED.* */
 	EVENT_CONSTRAINT_END
 };
 
