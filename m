Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299AbaESNJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:09:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59319 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249AbaESNJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:09:00 -0400
Date: Mon, 19 May 2014 06:08:08 -0700
From: tip-bot for Michael Kerrisk <tipbot@zytor.com>
Message-ID: <tip-814927325e815b667a133d9dcdf2286f88b78328@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, mtk.manpages@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, mtk.manpages@gmail.com
In-Reply-To: <536CEC24.9080201@gmail.com>
References: <536CEC24.9080201@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Simplify return logic in sched_copy_attr(
 )
Git-Commit-ID: 814927325e815b667a133d9dcdf2286f88b78328
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

Commit-ID:  814927325e815b667a133d9dcdf2286f88b78328
Gitweb:     http://git.kernel.org/tip/814927325e815b667a133d9dcdf2286f88b78328
Author:     Michael Kerrisk <mtk.manpages@gmail.com>
AuthorDate: Fri, 9 May 2014 16:54:28 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 19 May 2014 22:02:39 +0900

sched: Simplify return logic in sched_copy_attr()

The logic in this function is a little contorted:
* Rather than having chained gotos for the -EFBIG case, just
  return -EFBIG directly.
* Now, the label 'out' is no longer needed, and 'ret' must be zero
  zero by the time we fall through to this point, so just return 0.

Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/536CEC24.9080201@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9e1a3e0..08b6355 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3657,13 +3657,11 @@ static int sched_copy_attr(struct sched_attr __user *uattr,
 	 */
 	attr->sched_nice = clamp(attr->sched_nice, MIN_NICE, MAX_NICE);
 
-out:
-	return ret;
+	return 0;
 
 err_size:
 	put_user(sizeof(*attr), &uattr->size);
-	ret = -E2BIG;
-	goto out;
+	return -E2BIG;
 }
 
 /**
