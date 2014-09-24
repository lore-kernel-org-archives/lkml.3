Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbaIXPAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:00:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59865 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaIXPAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:00:50 -0400
Date: Wed, 24 Sep 2014 07:59:56 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-fdda3c4aacec30bdf3c10904d0c32409145dc1b6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1409683455-29168-5-git-send-email-andi@firstfloor.org>
References: <1409683455-29168-5-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/intel:
  Use Broadwell cache event list for Haswell
Git-Commit-ID: fdda3c4aacec30bdf3c10904d0c32409145dc1b6
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

Commit-ID:  fdda3c4aacec30bdf3c10904d0c32409145dc1b6
Gitweb:     http://git.kernel.org/tip/fdda3c4aacec30bdf3c10904d0c32409145dc1b6
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Tue, 2 Sep 2014 11:44:15 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Sep 2014 14:48:20 +0200

perf/x86/intel: Use Broadwell cache event list for Haswell

Use the newly added Broadwell cache event list for Haswell too.
All Haswell and Broadwell events and offcore masks used in these lists
are identical.

However Haswell is very different from the Sandy Bridge
list that was used previously. That fixes a wide range of mis-counting
cache events.

The node events are now only for retired memory events, so prefetching
and speculative memory accesses are not included. They are PEBS
capable now, which makes it much easier to sample for them, plus it's
possible to create address maps with -d.

The prefetch events are gone now. They way the hardware counts
them is very misleading (some prefetches included, others not), so
it seemed best to leave them out.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: eranian@google.com
Link: http://lkml.kernel.org/r/1409683455-29168-5-git-send-email-andi@firstfloor.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index bbcd0d2..3851def 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2692,8 +2692,8 @@ __init int intel_pmu_init(void)
 	case 69: /* 22nm Haswell ULT */
 	case 70: /* 22nm Haswell + GT3e (Intel Iris Pro graphics) */
 		x86_pmu.late_ack = true;
-		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids, sizeof(hw_cache_event_ids));
-		memcpy(hw_cache_extra_regs, snb_hw_cache_extra_regs, sizeof(hw_cache_extra_regs));
+		memcpy(hw_cache_event_ids, hsw_hw_cache_event_ids, sizeof(hw_cache_event_ids));
+		memcpy(hw_cache_extra_regs, hsw_hw_cache_extra_regs, sizeof(hw_cache_extra_regs));
 
 		intel_pmu_lbr_init_snb();
 
