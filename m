Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701AbaCWTiu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 15:38:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627AbaCWTir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 15:38:47 -0400
Date: Sun, 23 Mar 2014 20:37:48 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, David Woodhouse <dwmw2@infradead.org>,
        Richard Weinberger <richard@nod.at>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/11] signals: s/siginitset/sigemptyset/ in
	do_sigtimedwait()
Message-ID: <20140323193748.GA10485@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140323193730.GA10464@redhat.com>
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
index 52f881d..bb938ad 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2852,7 +2852,7 @@ int do_sigtimedwait(const sigset_t *which, siginfo_t *info,
 
 		spin_lock_irq(&tsk->sighand->siglock);
 		__set_task_blocked(tsk, &tsk->real_blocked);
-		siginitset(&tsk->real_blocked, 0);
+		sigemptyset(&tsk->real_blocked);
 		sig = dequeue_signal(tsk, &mask, info);
 	}
 	spin_unlock_irq(&tsk->sighand->siglock);
-- 
1.5.5.1

