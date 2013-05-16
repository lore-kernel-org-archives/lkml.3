Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338Ab3EQPyG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 11:54:06 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:41989 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab3EQPyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 11:54:03 -0400
From: Pavel Tikhomirov <snorcht@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>,
        Matthew Helsley <matt.helsley@gmail.com>, linux-api@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Pavel Tikhomirov <snorcht@gmail.com>
Subject: [PATCH 1/1] posix-timers: Show clock ID in proc file
Date: Fri, 17 May 2013 02:12:03 +0400
Message-Id: <1368742323-46949-2-git-send-email-snorcht@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1368742323-46949-1-git-send-email-snorcht@gmail.com>
References: <1368742323-46949-1-git-send-email-snorcht@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expand information about posix-timers in /proc/<pid>/timers by adding
info about clock, with which the timer was created. I.e. in the forth
line of timer info after "notify:" line go "ClockID: <clock_id>".

Signed-off-by: Pavel Tikhomirov <snorcht@gmail.com>
---
 fs/proc/base.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 2dad4a9..8a38eef 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2079,6 +2079,7 @@ static int show_timer(struct seq_file *m, void *v)
 		nstr[notify & ~SIGEV_THREAD_ID],
 		(notify & SIGEV_THREAD_ID) ? "tid" : "pid",
 		pid_nr_ns(timer->it_pid, tp->ns));
+	seq_printf(m, "ClockID: %d\n", timer->it_clock);
 
 	return 0;
 }
-- 
1.7.9.5

