Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662AbbA1VQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:16:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760244AbbA1Uue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:50:34 -0500
Date: Wed, 28 Jan 2015 06:29:02 -0800
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-98b008dff8452653909d9263efda925873e8d8bb@git.kernel.org>
Cc: peterz@infradead.org, eranian@google.com, torvalds@linux-foundation.org,
        mingo@kernel.org, tglx@linutronix.de, acme@kernel.org,
        vincent.weaver@maine.edu, hpa@zytor.com, linux-kernel@vger.kernel.org
Reply-To: peterz@infradead.org, eranian@google.com, mingo@kernel.org,
        tglx@linutronix.de, torvalds@linux-foundation.org, acme@kernel.org,
        vincent.weaver@maine.edu, hpa@zytor.com, linux-kernel@vger.kernel.org
In-Reply-To: <20150122203834.GA10228@thinkpad>
References: <20150122203834.GA10228@thinkpad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/rapl: Fix crash in rapl_scale()
Git-Commit-ID: 98b008dff8452653909d9263efda925873e8d8bb
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

Commit-ID:  98b008dff8452653909d9263efda925873e8d8bb
Gitweb:     http://git.kernel.org/tip/98b008dff8452653909d9263efda925873e8d8bb
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 22 Jan 2015 21:38:34 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 28 Jan 2015 13:04:35 +0100

perf/rapl: Fix crash in rapl_scale()

This patch fixes a systematic crash in rapl_scale()
due to an invalid pointer.

The bug was introduced by commit:

  89cbc76768c2 ("x86: Replace __get_cpu_var uses")

The fix is simple. Just put the parenthesis where it needs
to be, i.e., around rapl_pmu. To my surprise, the compiler
was not complaining about passing an integer instead of a
pointer.

Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Tested-by: Vince Weaver <vincent.weaver@maine.edu>
Fixes: 89cbc76768c2 ("x86: Replace __get_cpu_var uses")
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: cl@linux.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20150122203834.GA10228@thinkpad
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_rapl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_rapl.c b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
index 6e434f8..c4bb8b8 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_rapl.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
@@ -142,7 +142,7 @@ static inline u64 rapl_scale(u64 v)
 	 * or use ldexp(count, -32).
 	 * Watts = Joules/Time delta
 	 */
-	return v << (32 - __this_cpu_read(rapl_pmu->hw_unit));
+	return v << (32 - __this_cpu_read(rapl_pmu)->hw_unit);
 }
 
 static u64 rapl_event_update(struct perf_event *event)
