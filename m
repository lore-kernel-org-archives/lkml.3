Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311AbaESNJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:09:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59331 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbaESNJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:09:15 -0400
Date: Mon, 19 May 2014 06:08:20 -0700
From: tip-bot for Michael Kerrisk <tipbot@zytor.com>
Message-ID: <tip-55854e657f9890a1f76105c698d1d52cf6c43661@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, mtk.manpages@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, mtk.manpages@gmail.com
In-Reply-To: <536CEC29.9090503@gmail.com>
References: <536CEC29.9090503@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Simplify return logic in sched_read_attr(
 )
Git-Commit-ID: 55854e657f9890a1f76105c698d1d52cf6c43661
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

Commit-ID:  55854e657f9890a1f76105c698d1d52cf6c43661
Gitweb:     http://git.kernel.org/tip/55854e657f9890a1f76105c698d1d52cf6c43661
Author:     Michael Kerrisk <mtk.manpages@gmail.com>
AuthorDate: Fri, 9 May 2014 16:54:33 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 19 May 2014 22:02:40 +0900

sched: Simplify return logic in sched_read_attr()

Gotos are chained pointlessly here, and the 'out' label
can be dispensed with.

Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/536CEC29.9090503@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/core.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 08b6355..29c542e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3821,7 +3821,7 @@ static int sched_read_attr(struct sched_attr __user *uattr,
 
 		for (; addr < end; addr++) {
 			if (*addr)
-				goto err_size;
+				return -EFBIG;
 		}
 
 		attr->size = usize;
@@ -3831,12 +3831,7 @@ static int sched_read_attr(struct sched_attr __user *uattr,
 	if (ret)
 		return -EFAULT;
 
-out:
-	return ret;
-
-err_size:
-	ret = -E2BIG;
-	goto out;
+	return 0;
 }
 
 /**
