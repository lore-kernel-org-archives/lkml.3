Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750944AbaGZEh1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 00:37:27 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:47709 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbaGZEhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 00:37:25 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] timekeeping: Fixup typo in update_vsyscall_old definition
Date: Fri, 25 Jul 2014 21:37:19 -0700
Message-Id: <1406349439-11785-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 4a0e637738f0 ("clocksource: Get rid of cycle_last"),
currently in the -tip tree, there was a small typo where cycles_t
was used intstead of cycle_t. This broke ppc64 builds.

Fix this by using the proper cycle_t type for this usage, in
both the definition and the ia64 implementation.

Now, having both cycle_t and cycles_t types seems like a very
bad idea just asking for these sorts of issues. But that
will be a cleanup for another day.

Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---

Note: This should be visibly correct, and I've test built on ppc64,
but I don't have an ia64 toolchain, so if anyone could give this a
build whirl on ia64, I'd appreciate it.

 arch/ia64/kernel/time.c             | 2 +-
 include/linux/timekeeper_internal.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 11dc42d..3e71ef8 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -441,7 +441,7 @@ void update_vsyscall_tz(void)
 }
 
 void update_vsyscall_old(struct timespec *wall, struct timespec *wtm,
-			 struct clocksource *c, u32 mult, cycles_t cycle_last)
+			 struct clocksource *c, u32 mult, cycle_t cycle_last)
 {
 	write_seqcount_begin(&fsyscall_gtod_data.seq);
 
diff --git a/include/linux/timekeeper_internal.h b/include/linux/timekeeper_internal.h
index e9660e5..95640dc 100644
--- a/include/linux/timekeeper_internal.h
+++ b/include/linux/timekeeper_internal.h
@@ -113,7 +113,7 @@ extern void update_vsyscall_tz(void);
 
 extern void update_vsyscall_old(struct timespec *ts, struct timespec *wtm,
 				struct clocksource *c, u32 mult,
-				cycles_t cycle_last);
+				cycle_t cycle_last);
 extern void update_vsyscall_tz(void);
 
 #else
-- 
1.9.1

