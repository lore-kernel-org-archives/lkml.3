Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab3IBHmN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 03:42:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52449 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082Ab3IBHmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 03:42:10 -0400
Date: Mon, 2 Sep 2013 00:41:37 -0700
From: "tip-bot for Yan, Zheng" <tipbot@zytor.com>
Message-ID: <tip-53ad0447208d3f5897f673ca0b16c776583eedba@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, zheng.z.yan@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        zheng.z.yan@intel.com, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1374138144-17278-1-git-send-email-zheng.z.yan@intel.com>
References: <1374138144-17278-1-git-send-email-zheng.z.yan@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86:
  use INTEL_UEVENT_EXTRA_REG to define MSR_OFFCORE_RSP_X
Git-Commit-ID: 53ad0447208d3f5897f673ca0b16c776583eedba
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 02 Sep 2013 00:41:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  53ad0447208d3f5897f673ca0b16c776583eedba
Gitweb:     http://git.kernel.org/tip/53ad0447208d3f5897f673ca0b16c776583eedba
Author:     Yan, Zheng <zheng.z.yan@intel.com>
AuthorDate: Thu, 18 Jul 2013 17:02:23 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 2 Sep 2013 08:42:47 +0200

perf/x86: use INTEL_UEVENT_EXTRA_REG to define MSR_OFFCORE_RSP_X

Silvermont (22nm Atom) has two offcore response configuration MSRs,
unlike other Intel CPU, its event code for MSR_OFFCORE_RSP_1 is 0x02b7.

To avoid complicating intel_fixup_er(), use INTEL_UEVENT_EXTRA_REG to
define MSR_OFFCORE_RSP_X. So intel_fixup_er() can find the event code
for OFFCORE_RSP_N by x86_pmu.extra_regs[N].event.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1374138144-17278-1-git-send-email-zheng.z.yan@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index a45d8d4..0d59a42 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -81,7 +81,8 @@ static struct event_constraint intel_nehalem_event_constraints[] __read_mostly =
 
 static struct extra_reg intel_nehalem_extra_regs[] __read_mostly =
 {
-	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0xffff, RSP_0),
+	/* must define OFFCORE_RSP_X first, see intel_fixup_er() */
+	INTEL_UEVENT_EXTRA_REG(0x01b7, MSR_OFFCORE_RSP_0, 0xffff, RSP_0),
 	INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG(0x100b),
 	EVENT_EXTRA_END
 };
@@ -143,8 +144,9 @@ static struct event_constraint intel_ivb_event_constraints[] __read_mostly =
 
 static struct extra_reg intel_westmere_extra_regs[] __read_mostly =
 {
-	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0xffff, RSP_0),
-	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0xffff, RSP_1),
+	/* must define OFFCORE_RSP_X first, see intel_fixup_er() */
+	INTEL_UEVENT_EXTRA_REG(0x01b7, MSR_OFFCORE_RSP_0, 0xffff, RSP_0),
+	INTEL_UEVENT_EXTRA_REG(0x01bb, MSR_OFFCORE_RSP_1, 0xffff, RSP_1),
 	INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG(0x100b),
 	EVENT_EXTRA_END
 };
@@ -163,15 +165,17 @@ static struct event_constraint intel_gen_event_constraints[] __read_mostly =
 };
 
 static struct extra_reg intel_snb_extra_regs[] __read_mostly = {
-	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0x3f807f8fffull, RSP_0),
-	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0x3f807f8fffull, RSP_1),
+	/* must define OFFCORE_RSP_X first, see intel_fixup_er() */
+	INTEL_UEVENT_EXTRA_REG(0x01b7, MSR_OFFCORE_RSP_0, 0x3f807f8fffull, RSP_0),
+	INTEL_UEVENT_EXTRA_REG(0x01bb, MSR_OFFCORE_RSP_1, 0x3f807f8fffull, RSP_1),
 	INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG(0x01cd),
 	EVENT_EXTRA_END
 };
 
 static struct extra_reg intel_snbep_extra_regs[] __read_mostly = {
-	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0x3fffff8fffull, RSP_0),
-	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0x3fffff8fffull, RSP_1),
+	/* must define OFFCORE_RSP_X first, see intel_fixup_er() */
+	INTEL_UEVENT_EXTRA_REG(0x01b7, MSR_OFFCORE_RSP_0, 0x3fffff8fffull, RSP_0),
+	INTEL_UEVENT_EXTRA_REG(0x01bb, MSR_OFFCORE_RSP_1, 0x3fffff8fffull, RSP_1),
 	INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG(0x01cd),
 	EVENT_EXTRA_END
 };
@@ -1301,11 +1305,11 @@ static void intel_fixup_er(struct perf_event *event, int idx)
 
 	if (idx == EXTRA_REG_RSP_0) {
 		event->hw.config &= ~INTEL_ARCH_EVENT_MASK;
-		event->hw.config |= 0x01b7;
+		event->hw.config |= x86_pmu.extra_regs[EXTRA_REG_RSP_0].event;
 		event->hw.extra_reg.reg = MSR_OFFCORE_RSP_0;
 	} else if (idx == EXTRA_REG_RSP_1) {
 		event->hw.config &= ~INTEL_ARCH_EVENT_MASK;
-		event->hw.config |= 0x01bb;
+		event->hw.config |= x86_pmu.extra_regs[EXTRA_REG_RSP_1].event;
 		event->hw.extra_reg.reg = MSR_OFFCORE_RSP_1;
 	}
 }
