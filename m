Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530Ab3ILSEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:04:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37836 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056Ab3ILSEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:04:35 -0400
Date: Thu, 12 Sep 2013 11:03:55 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-06c939c1f41b1c28bb17fae074ad610e22a01db8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20130909112636.GQ31370@twins.programming.kicks-ass.net>
References: <20130909112636.GQ31370@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/intel: Fix Silvermont offcore masks
Git-Commit-ID: 06c939c1f41b1c28bb17fae074ad610e22a01db8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 12 Sep 2013 11:04:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  06c939c1f41b1c28bb17fae074ad610e22a01db8
Gitweb:     http://git.kernel.org/tip/06c939c1f41b1c28bb17fae074ad610e22a01db8
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 9 Sep 2013 13:26:36 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 12 Sep 2013 19:12:27 +0200

perf/x86/intel: Fix Silvermont offcore masks

Fengguang Wu reported:

> sparse warnings: (new ones prefixed by >>)
>
> >> arch/x86/kernel/cpu/perf_event_intel.c:901:9: sparse: constant 0x768005ffff is so big it is long
> >> arch/x86/kernel/cpu/perf_event_intel.c:902:9: sparse: constant 0x768005ffff is so big it is long
>
> vim +901 arch/x86/kernel/cpu/perf_event_intel.c
>
>    895	 },
>    896	};
>    897
>    898	static struct extra_reg intel_slm_extra_regs[] __read_mostly =
>    899	{
>    900		/* must define OFFCORE_RSP_X first, see intel_fixup_er() */
>  > 901		INTEL_UEVENT_EXTRA_REG(0x01b7, MSR_OFFCORE_RSP_0, 0x768005ffff, RSP_0),
>  > 902		INTEL_UEVENT_EXTRA_REG(0x02b7, MSR_OFFCORE_RSP_1, 0x768005ffff, RSP_1),
>    903		EVENT_EXTRA_END
>    904	};
>    905

Extend those constants to 64 bits.

Reported-by: fengguang.wu@intel.com
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20130909112636.GQ31370@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index c62d883..9db76c3 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -899,8 +899,8 @@ static __initconst const u64 atom_hw_cache_event_ids
 static struct extra_reg intel_slm_extra_regs[] __read_mostly =
 {
 	/* must define OFFCORE_RSP_X first, see intel_fixup_er() */
-	INTEL_UEVENT_EXTRA_REG(0x01b7, MSR_OFFCORE_RSP_0, 0x768005ffff, RSP_0),
-	INTEL_UEVENT_EXTRA_REG(0x02b7, MSR_OFFCORE_RSP_1, 0x768005ffff, RSP_1),
+	INTEL_UEVENT_EXTRA_REG(0x01b7, MSR_OFFCORE_RSP_0, 0x768005ffffull, RSP_0),
+	INTEL_UEVENT_EXTRA_REG(0x02b7, MSR_OFFCORE_RSP_1, 0x768005ffffull, RSP_1),
 	EVENT_EXTRA_END
 };
 
