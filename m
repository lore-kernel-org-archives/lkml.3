Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbaBUVPE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:15:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59039 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930AbaBUVO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:14:59 -0500
Date: Fri, 21 Feb 2014 13:14:29 -0800
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-337397f3afc911d94d1d71371a36a53ce218b41f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, zheng.z.yan@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, zheng.z.yan@intel.com,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20140219131018.GA24475@quad>
References: <20140219131018.GA24475@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86/uncore: Fix IVT/
 SNB-EP uncore CBOX NID filter table
Git-Commit-ID: 337397f3afc911d94d1d71371a36a53ce218b41f
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

Commit-ID:  337397f3afc911d94d1d71371a36a53ce218b41f
Gitweb:     http://git.kernel.org/tip/337397f3afc911d94d1d71371a36a53ce218b41f
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Wed, 19 Feb 2014 14:10:18 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 22:09:01 +0100

perf/x86/uncore: Fix IVT/SNB-EP uncore CBOX NID filter table

This patch updates the CBOX PMU filters mapping tables for SNB-EP
and IVT (model 45 and 62 respectively).

The NID umask always comes in addition to another umask.
When set, the NID filter is applied.

The current mapping tables were missing some code/umask
combinations to account for the NID umask. This patch
fixes that.

Cc: mingo@elte.hu
Cc: ak@linux.intel.com
Reviewed-by: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140219131018.GA24475@quad
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 29c2487..c88f7f4 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -501,8 +501,11 @@ static struct extra_reg snbep_uncore_cbox_extra_regs[] = {
 	SNBEP_CBO_EVENT_EXTRA_REG(SNBEP_CBO_PMON_CTL_TID_EN,
 				  SNBEP_CBO_PMON_CTL_TID_EN, 0x1),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0334, 0xffff, 0x4),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4334, 0xffff, 0x6),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0534, 0xffff, 0x4),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4534, 0xffff, 0x6),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0934, 0xffff, 0x4),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4934, 0xffff, 0x6),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x4134, 0xffff, 0x6),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0135, 0xffff, 0x8),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0335, 0xffff, 0x8),
@@ -1178,10 +1181,15 @@ static struct extra_reg ivt_uncore_cbox_extra_regs[] = {
 	SNBEP_CBO_EVENT_EXTRA_REG(SNBEP_CBO_PMON_CTL_TID_EN,
 				  SNBEP_CBO_PMON_CTL_TID_EN, 0x1),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x1031, 0x10ff, 0x2),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x1134, 0xffff, 0x4),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4134, 0xffff, 0xc),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x5134, 0xffff, 0xc),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0334, 0xffff, 0x4),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4334, 0xffff, 0xc),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0534, 0xffff, 0x4),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4534, 0xffff, 0xc),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0934, 0xffff, 0x4),
-	SNBEP_CBO_EVENT_EXTRA_REG(0x4134, 0xffff, 0xc),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4934, 0xffff, 0xc),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0135, 0xffff, 0x10),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0335, 0xffff, 0x10),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x2135, 0xffff, 0x10),
