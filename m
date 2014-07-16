Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935085AbaGPTUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:20:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44296 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934925AbaGPTUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:20:30 -0400
Date: Wed, 16 Jul 2014 12:19:25 -0700
From: tip-bot for Vince Weaver <tipbot@zytor.com>
Message-ID: <tip-1996388e9f4e3444db8273bc08d25164d2967c21@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, acme@kernel.org,
        vincent.weaver@maine.edu, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, acme@kernel.org,
        vincent.weaver@maine.edu, tglx@linutronix.de
In-Reply-To: <alpine.DEB.2.11.1407141528200.17214@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.11.1407141528200.17214@vincent-weaver-1.umelst.maine.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86/intel:
  Use proper dTLB-load-misses event on IvyBridge
Git-Commit-ID: 1996388e9f4e3444db8273bc08d25164d2967c21
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

Commit-ID:  1996388e9f4e3444db8273bc08d25164d2967c21
Gitweb:     http://git.kernel.org/tip/1996388e9f4e3444db8273bc08d25164d2967c21
Author:     Vince Weaver <vincent.weaver@maine.edu>
AuthorDate: Mon, 14 Jul 2014 15:33:25 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 16 Jul 2014 13:18:40 +0200

perf/x86/intel: Use proper dTLB-load-misses event on IvyBridge

This was discussed back in February:

	https://lkml.org/lkml/2014/2/18/956

But I never saw a patch come out of it.

On IvyBridge we share the SandyBridge cache event tables, but the
dTLB-load-miss event is not compatible.  Patch it up after
the fact to the proper DTLB_LOAD_MISSES.DEMAND_LD_MISS_CAUSES_A_WALK

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/alpine.DEB.2.11.1407141528200.17214@vincent-weaver-1.umelst.maine.edu
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 07846d7..c206815 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2474,6 +2474,9 @@ __init int intel_pmu_init(void)
 	case 62: /* IvyBridge EP */
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
+		/* dTLB-load-misses on IVB is different than SNB */
+		hw_cache_event_ids[C(DTLB)][C(OP_READ)][C(RESULT_MISS)] = 0x8108; /* DTLB_LOAD_MISSES.DEMAND_LD_MISS_CAUSES_A_WALK */
+
 		memcpy(hw_cache_extra_regs, snb_hw_cache_extra_regs,
 		       sizeof(hw_cache_extra_regs));
 
