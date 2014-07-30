Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbaG3Hd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 03:33:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41044 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195AbaG3Hd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 03:33:58 -0400
Date: Wed, 30 Jul 2014 00:31:36 -0700
From: tip-bot for John Stultz <tipbot@zytor.com>
Message-ID: <tip-953dec21aed4038464fec02f96a2f1b8701a5bce@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, sfr@canb.auug.org.au,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        sfr@canb.auug.org.au
In-Reply-To: <1406349439-11785-1-git-send-email-john.stultz@linaro.org>
References: <1406349439-11785-1-git-send-email-john.stultz@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] timekeeping:
  Fixup typo in update_vsyscall_old definition
Git-Commit-ID: 953dec21aed4038464fec02f96a2f1b8701a5bce
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

Commit-ID:  953dec21aed4038464fec02f96a2f1b8701a5bce
Gitweb:     http://git.kernel.org/tip/953dec21aed4038464fec02f96a2f1b8701a5bce
Author:     John Stultz <john.stultz@linaro.org>
AuthorDate: Fri, 25 Jul 2014 21:37:19 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 30 Jul 2014 09:26:25 +0200

timekeeping: Fixup typo in update_vsyscall_old definition

In commit 4a0e637738f0 ("clocksource: Get rid of cycle_last"),
currently in the -tip tree, there was a small typo where cycles_t
was used intstead of cycle_t. This broke ppc64 builds.

Fix this by using the proper cycle_t type for this usage, in
both the definition and the ia64 implementation.

Now, having both cycle_t and cycles_t types seems like a very
bad idea just asking for these sorts of issues. But that
will be a cleanup for another day.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1406349439-11785-1-git-send-email-john.stultz@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
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
