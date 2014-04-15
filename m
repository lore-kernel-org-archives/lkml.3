Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916AbaDOShZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 14:37:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754805AbaDOShV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 14:37:21 -0400
Date: Tue, 15 Apr 2014 20:36:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, David Woodhouse <dwmw2@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Richard Weinberger <richard@nod.at>,
        Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RESEND2 02/11] signals: s/siginitset/sigemptyset/ in
	do_sigtimedwait()
Message-ID: <20140415183641.GA13392@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140415183625.GA13371@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cosmetic, but siginitset(0) looks a bit strange, sigemptyset() is what
do_sigtimedwait() needs.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/signal.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 6ea13c0..a717749 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2854,7 +2854,7 @@ int do_sigtimedwait(const sigset_t *which, siginfo_t *info,
 
 		spin_lock_irq(&tsk->sighand->siglock);
 		__set_task_blocked(tsk, &tsk->real_blocked);
-		siginitset(&tsk->real_blocked, 0);
+		sigemptyset(&tsk->real_blocked);
 		sig = dequeue_signal(tsk, &mask, info);
 	}
 	spin_unlock_irq(&tsk->sighand->siglock);
-- 
1.5.5.1

