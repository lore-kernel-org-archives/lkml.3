Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932942AbaH0JVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 05:21:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41487 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180AbaH0JVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 05:21:51 -0400
Date: Wed, 27 Aug 2014 02:21:30 -0700
From: tip-bot for Dan Carpenter <tipbot@zytor.com>
Message-ID: <tip-88299c9bdb109e0d95abdca648065631ff91b2cb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        gorcunov@openvz.org, tglx@linutronix.de, viro@zeniv.linux.org.uk,
        dan.carpenter@oracle.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        gorcunov@openvz.org, tglx@linutronix.de, viro@zeniv.linux.org.uk,
        dan.carpenter@oracle.com
In-Reply-To: <20140801082848.GF28869@mwanda>
References: <20140801082848.GF28869@mwanda>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] timerfd: Remove an always true check
Git-Commit-ID: 88299c9bdb109e0d95abdca648065631ff91b2cb
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

Commit-ID:  88299c9bdb109e0d95abdca648065631ff91b2cb
Gitweb:     http://git.kernel.org/tip/88299c9bdb109e0d95abdca648065631ff91b2cb
Author:     Dan Carpenter <dan.carpenter@oracle.com>
AuthorDate: Fri, 1 Aug 2014 11:28:48 +0300
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 27 Aug 2014 11:17:48 +0200

timerfd: Remove an always true check

We would have returned -EINVAL earlier if ticks wasn't set.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Link: http://lkml.kernel.org/r/20140801082848.GF28869@mwanda
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 fs/timerfd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/timerfd.c b/fs/timerfd.c
index 80c3502..b46ffa9 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -333,8 +333,7 @@ static long timerfd_ioctl(struct file *file, unsigned int cmd, unsigned long arg
 		spin_lock_irq(&ctx->wqh.lock);
 		if (!timerfd_canceled(ctx)) {
 			ctx->ticks = ticks;
-			if (ticks)
-				wake_up_locked(&ctx->wqh);
+			wake_up_locked(&ctx->wqh);
 		} else
 			ret = -ECANCELED;
 		spin_unlock_irq(&ctx->wqh.lock);
