Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933838Ab3E1Jpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 05:45:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48447 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933792Ab3E1Jpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 05:45:31 -0400
Date: Tue, 28 May 2013 02:44:16 -0700
From: tip-bot for Pavel Tikhomirov <tipbot@zytor.com>
Message-ID: <tip-15ef0298deb3929eb6ad6d2334fd2059fd53807c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        matt.helsley@gmail.com, xemul@parallels.com, snorcht@gmail.com,
        tglx@linutronix.de, mtk.manpages@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        matt.helsley@gmail.com, xemul@parallels.com, snorcht@gmail.com,
        tglx@linutronix.de, mtk.manpages@gmail.com
In-Reply-To: <1368742323-46949-2-git-send-email-snorcht@gmail.com>
References: <1368742323-46949-2-git-send-email-snorcht@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] posix-timers: Show clock ID in proc file
Git-Commit-ID: 15ef0298deb3929eb6ad6d2334fd2059fd53807c
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

Commit-ID:  15ef0298deb3929eb6ad6d2334fd2059fd53807c
Gitweb:     http://git.kernel.org/tip/15ef0298deb3929eb6ad6d2334fd2059fd53807c
Author:     Pavel Tikhomirov <snorcht@gmail.com>
AuthorDate: Fri, 17 May 2013 02:12:03 +0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 28 May 2013 11:41:14 +0200

posix-timers: Show clock ID in proc file

Expand information about posix-timers in /proc/<pid>/timers by adding
info about clock, with which the timer was created. I.e. in the forth
line of timer info after "notify:" line go "ClockID: <clock_id>".

Signed-off-by: Pavel Tikhomirov <snorcht@gmail.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Matthew Helsley <matt.helsley@gmail.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Link: http://lkml.kernel.org/r/1368742323-46949-2-git-send-email-snorcht@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 fs/proc/base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index dd51e50..c3834da 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2118,6 +2118,7 @@ static int show_timer(struct seq_file *m, void *v)
 		nstr[notify & ~SIGEV_THREAD_ID],
 		(notify & SIGEV_THREAD_ID) ? "tid" : "pid",
 		pid_nr_ns(timer->it_pid, tp->ns));
+	seq_printf(m, "ClockID: %d\n", timer->it_clock);
 
 	return 0;
 }
