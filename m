Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab3CRLN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 07:13:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34269 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab3CRLNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 07:13:54 -0400
Date: Mon, 18 Mar 2013 04:12:43 -0700
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-fd4a5aef002bb57e8a35ed34d8a878034b9bde94@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, eranian@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, eranian@gmail.com
In-Reply-To: <20130317134957.GA8550@quad>
References: <20130317134957.GA8550@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86: Add SNB/
 SNB-EP scheduling constraints for cycle_activity event
Git-Commit-ID: fd4a5aef002bb57e8a35ed34d8a878034b9bde94
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 18 Mar 2013 04:12:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fd4a5aef002bb57e8a35ed34d8a878034b9bde94
Gitweb:     http://git.kernel.org/tip/fd4a5aef002bb57e8a35ed34d8a878034b9bde94
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Sun, 17 Mar 2013 14:49:57 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 18 Mar 2013 10:23:13 +0100

perf/x86: Add SNB/SNB-EP scheduling constraints for cycle_activity event

Add scheduling constraints for SNB/SNB-EP CYCLE_ACTIVITY event
as defined by SDM Jan 2013 edition. The STALLS umasks are
combinations with the NO_DISPATCH umask.

Signed-off-by: Stephane Eranian <eranian@gmail.com>
Cc: peterz@infradead.org
Cc: ak@linux.intel.com
Cc: jolsa@redhat.com
Link: http://lkml.kernel.org/r/20130317134957.GA8550@quad
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 529c893..dab7580 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -101,6 +101,10 @@ static struct event_constraint intel_snb_event_constraints[] __read_mostly =
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
 	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
 	FIXED_EVENT_CONSTRAINT(0x0300, 2), /* CPU_CLK_UNHALTED.REF */
+	INTEL_UEVENT_CONSTRAINT(0x04a3, 0xf), /* CYCLE_ACTIVITY.CYCLES_NO_DISPATCH */
+	INTEL_UEVENT_CONSTRAINT(0x05a3, 0xf), /* CYCLE_ACTIVITY.STALLS_L2_PENDING */
+	INTEL_UEVENT_CONSTRAINT(0x02a3, 0x4), /* CYCLE_ACTIVITY.CYCLES_L1D_PENDING */
+	INTEL_UEVENT_CONSTRAINT(0x06a3, 0x4), /* CYCLE_ACTIVITY.STALLS_L1D_PENDING */
 	INTEL_EVENT_CONSTRAINT(0x48, 0x4), /* L1D_PEND_MISS.PENDING */
 	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PREC_DIST */
 	INTEL_EVENT_CONSTRAINT(0xcd, 0x8), /* MEM_TRANS_RETIRED.LOAD_LATENCY */
