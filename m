Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab3DVSdd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 14:33:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51421 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583Ab3DVSdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 14:33:31 -0400
Date: Mon, 22 Apr 2013 11:32:11 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-77c675ba18836802f6b73d2d773481d06ebc0f04@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        hpa@zytor.com, mingo@kernel.org, bp@alien8.de, jslaby@suse.cz,
        john.stultz@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, jslaby@suse.cz, bp@alien8.de,
        john.stultz@linaro.org, tglx@linutronix.de
In-Reply-To: <alpine.LFD.2.02.1304211648150.21884@ionos>
References: <alpine.LFD.2.02.1304211648150.21884@ionos>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] timekeeping: Update tk->cycle_last in resume
Git-Commit-ID: 77c675ba18836802f6b73d2d773481d06ebc0f04
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 22 Apr 2013 11:32:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  77c675ba18836802f6b73d2d773481d06ebc0f04
Gitweb:     http://git.kernel.org/tip/77c675ba18836802f6b73d2d773481d06ebc0f04
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 22 Apr 2013 09:37:04 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 22 Apr 2013 20:17:51 +0200

timekeeping: Update tk->cycle_last in resume

commit 7ec98e15aa (timekeeping: Delay update of clock->cycle_last)
forgot to update tk->cycle_last in the resume path. This results in a
stale value versus clock->cycle_last and prevents resume in the worst
case.

Reported-by: Jiri Slaby <jslaby@suse.cz>
Reported-and-tested-by: Borislav Petkov <bp@alien8.de>
Acked-by: John Stultz <john.stultz@linaro.org>
Cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Link: http://lkml.kernel.org/r/alpine.LFD.2.02.1304211648150.21884@ionos
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/timekeeping.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 675f720..98cd470 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -951,7 +951,7 @@ static void timekeeping_resume(void)
 		__timekeeping_inject_sleeptime(tk, &ts_delta);
 
 	/* Re-base the last cycle value */
-	clock->cycle_last = cycle_now;
+	tk->cycle_last = clock->cycle_last = cycle_now;
 	tk->ntp_error = 0;
 	timekeeping_suspended = 0;
 	timekeeping_update(tk, false, true);
