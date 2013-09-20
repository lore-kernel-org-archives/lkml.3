Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab3ITNs3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 09:48:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44325 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936Ab3ITNs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 09:48:26 -0400
Date: Fri, 20 Sep 2013 06:47:49 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-92519bbc8af612975410def52bd462ca9af85cdb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/intel:
  Fix build warning in intel_pmu_drain_pebs_nhm()
Git-Commit-ID: 92519bbc8af612975410def52bd462ca9af85cdb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 20 Sep 2013 06:47:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  92519bbc8af612975410def52bd462ca9af85cdb
Gitweb:     http://git.kernel.org/tip/92519bbc8af612975410def52bd462ca9af85cdb
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 20 Sep 2013 13:08:50 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 20 Sep 2013 13:15:27 +0200

perf/x86/intel: Fix build warning in intel_pmu_drain_pebs_nhm()

Fengguang Wu reported this build warning:

    arch/x86/kernel/cpu/perf_event_intel_ds.c: In function 'intel_pmu_drain_pebs_nhm':
    arch/x86/kernel/cpu/perf_event_intel_ds.c:964:2: warning: format '%ld' expects argument of type 'long int', but argument 4 has type 'int'

Because pointer arithmetics result type is bitness dependent there's no natural
type to use here, cast it to long.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-jbpauwxJqtf24luewcsdFith@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 655d591..54ff6ce 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -963,7 +963,7 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 	 */
 	WARN_ONCE(top - at > x86_pmu.max_pebs_events * x86_pmu.pebs_record_size,
 		  "Unexpected number of pebs records %ld\n",
-		  (top - at) / x86_pmu.pebs_record_size);
+		  (long)(top - at) / x86_pmu.pebs_record_size);
 
 	for (; at < top; at += x86_pmu.pebs_record_size) {
 		struct pebs_record_nhm *p = at;
