Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbaFEOks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:40:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48764 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbaFEOkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:40:42 -0400
Date: Thu, 5 Jun 2014 07:39:49 -0700
From: tip-bot for Anshuman Khandual <tipbot@zytor.com>
Message-ID: <tip-37548914fbfcd56e1955a9b7e55dc3b84a3e9e25@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        khandual@linux.vnet.ibm.com, acme@kernel.org, ak@linux.intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        khandual@linux.vnet.ibm.com, peterz@infradead.org, acme@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1400743210-32289-3-git-send-email-khandual@linux.vnet.ibm.com>
References: <1400743210-32289-3-git-send-email-khandual@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86:
  Add conditional branch filtering support
Git-Commit-ID: 37548914fbfcd56e1955a9b7e55dc3b84a3e9e25
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

Commit-ID:  37548914fbfcd56e1955a9b7e55dc3b84a3e9e25
Gitweb:     http://git.kernel.org/tip/37548914fbfcd56e1955a9b7e55dc3b84a3e9e25
Author:     Anshuman Khandual <khandual@linux.vnet.ibm.com>
AuthorDate: Thu, 22 May 2014 12:50:09 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jun 2014 12:30:23 +0200

perf/x86: Add conditional branch filtering support

This patch adds conditional branch filtering support,
enabling it for PERF_SAMPLE_BRANCH_COND in perf branch
stack sampling framework by utilizing an available
software filter X86_BR_JCC.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Reviewed-by: Stephane Eranian <eranian@google.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: mpe@ellerman.id.au
Cc: benh@kernel.crashing.org
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1400743210-32289-3-git-send-email-khandual@linux.vnet.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_lbr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index d82d155..9dd2459 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -384,6 +384,9 @@ static void intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
 	if (br_type & PERF_SAMPLE_BRANCH_NO_TX)
 		mask |= X86_BR_NO_TX;
 
+	if (br_type & PERF_SAMPLE_BRANCH_COND)
+		mask |= X86_BR_JCC;
+
 	/*
 	 * stash actual user request into reg, it may
 	 * be used by fixup code for some CPU
@@ -678,6 +681,7 @@ static const int nhm_lbr_sel_map[PERF_SAMPLE_BRANCH_MAX] = {
 	 * NHM/WSM erratum: must include IND_JMP to capture IND_CALL
 	 */
 	[PERF_SAMPLE_BRANCH_IND_CALL] = LBR_IND_CALL | LBR_IND_JMP,
+	[PERF_SAMPLE_BRANCH_COND]     = LBR_JCC,
 };
 
 static const int snb_lbr_sel_map[PERF_SAMPLE_BRANCH_MAX] = {
@@ -689,6 +693,7 @@ static const int snb_lbr_sel_map[PERF_SAMPLE_BRANCH_MAX] = {
 	[PERF_SAMPLE_BRANCH_ANY_CALL]	= LBR_REL_CALL | LBR_IND_CALL
 					| LBR_FAR,
 	[PERF_SAMPLE_BRANCH_IND_CALL]	= LBR_IND_CALL,
+	[PERF_SAMPLE_BRANCH_COND]       = LBR_JCC,
 };
 
 /* core */
