Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbaIXPBa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:01:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59901 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaIXPB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:01:27 -0400
Date: Wed, 24 Sep 2014 08:00:53 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-b10fc1c3e30c44033d1cb1d2900cc2ab06dff342@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1409872109-31645-5-git-send-email-andi@firstfloor.org>
References: <1409872109-31645-5-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/intel/uncore:
  Fix PCU filter setup for Sandy/Ivy/Haswell EP
Git-Commit-ID: b10fc1c3e30c44033d1cb1d2900cc2ab06dff342
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

Commit-ID:  b10fc1c3e30c44033d1cb1d2900cc2ab06dff342
Gitweb:     http://git.kernel.org/tip/b10fc1c3e30c44033d1cb1d2900cc2ab06dff342
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Thu, 4 Sep 2014 16:08:29 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Sep 2014 14:48:24 +0200

perf/x86/intel/uncore: Fix PCU filter setup for Sandy/Ivy/Haswell EP

The PCU frequency band filters use 8 bit each in a register.
When setting up the value the shift value was not correctly
scaled, which resulted in all filters except for band 0 to
be zero. Fix the scaling.

This allows to correctly monitor multiple uncore frequency bands.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: eranian@google.com
Link: http://lkml.kernel.org/r/1409872109-31645-5-git-send-email-andi@firstfloor.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
index b237abc..adf138e 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
@@ -841,7 +841,7 @@ static int snbep_pcu_hw_config(struct intel_uncore_box *box, struct perf_event *
 	if (ev_sel >= 0xb && ev_sel <= 0xe) {
 		reg1->reg = SNBEP_PCU_MSR_PMON_BOX_FILTER;
 		reg1->idx = ev_sel - 0xb;
-		reg1->config = event->attr.config1 & (0xff << reg1->idx);
+		reg1->config = event->attr.config1 & (0xff << (reg1->idx * 8));
 	}
 	return 0;
 }
