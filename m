Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778AbaKPMfn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 07:35:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35627 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457AbaKPMfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 07:35:38 -0500
Date: Sun, 16 Nov 2014 04:35:10 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-0dbc94796d8714f78446245ef0f080d2c0b7ff0e@git.kernel.org>
Cc: hpa@zytor.com, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        acme@kernel.org
Reply-To: hpa@zytor.com, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        acme@kernel.org
In-Reply-To: <1411569288-5627-2-git-send-email-andi@firstfloor.org>
References: <1411569288-5627-2-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/intel:
  Use INTEL_FLAGS_UEVENT_CONSTRAINT for PRECDIST
Git-Commit-ID: 0dbc94796d8714f78446245ef0f080d2c0b7ff0e
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

Commit-ID:  0dbc94796d8714f78446245ef0f080d2c0b7ff0e
Gitweb:     http://git.kernel.org/tip/0dbc94796d8714f78446245ef0f080d2c0b7ff0e
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Wed, 24 Sep 2014 07:34:47 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 16 Nov 2014 11:41:55 +0100

perf/x86/intel: Use INTEL_FLAGS_UEVENT_CONSTRAINT for PRECDIST

My earlier commit:

  86a04461a99f ("perf/x86: Revamp PEBS event selection")

made nearly all PEBS on Sandy/IvyBridge/Haswell to reject non zero flags.

However this wasn't done for the INST_RETIRED.PREC_DIST event
because no suitable macro existed. Now that we have
INTEL_FLAGS_UEVENT_CONSTRAINT enforce zero flags for
INST_RETIRED.PREC_DIST too.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Link: http://lkml.kernel.org/r/1411569288-5627-2-git-send-email-andi@firstfloor.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 46211bc..12fe1dc 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -606,7 +606,7 @@ struct event_constraint intel_westmere_pebs_event_constraints[] = {
 };
 
 struct event_constraint intel_snb_pebs_event_constraints[] = {
-	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
 	INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
 	INTEL_PST_CONSTRAINT(0x02cd, 0x8),    /* MEM_TRANS_RETIRED.PRECISE_STORES */
 	/* UOPS_RETIRED.ALL, inv=1, cmask=16 (cycles:p). */
@@ -617,7 +617,7 @@ struct event_constraint intel_snb_pebs_event_constraints[] = {
 };
 
 struct event_constraint intel_ivb_pebs_event_constraints[] = {
-        INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
+        INTEL_FLAGS_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
         INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
 	INTEL_PST_CONSTRAINT(0x02cd, 0x8),    /* MEM_TRANS_RETIRED.PRECISE_STORES */
 	/* UOPS_RETIRED.ALL, inv=1, cmask=16 (cycles:p). */
@@ -628,7 +628,7 @@ struct event_constraint intel_ivb_pebs_event_constraints[] = {
 };
 
 struct event_constraint intel_hsw_pebs_event_constraints[] = {
-	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
 	INTEL_PLD_CONSTRAINT(0x01cd, 0xf),    /* MEM_TRANS_RETIRED.* */
 	/* UOPS_RETIRED.ALL, inv=1, cmask=16 (cycles:p). */
 	INTEL_FLAGS_EVENT_CONSTRAINT(0x108001c2, 0xf),
