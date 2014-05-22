Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbaEVM1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:27:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51244 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777AbaEVM1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:27:45 -0400
Date: Thu, 22 May 2014 05:27:00 -0700
From: tip-bot for Michael Kerrisk <tipbot@zytor.com>
Message-ID: <tip-22400674945c562cf3c176d6c4178cd545e2dec9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, mtk.manpages@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, mtk.manpages@gmail.com
In-Reply-To: <536CEC29.9090503@gmail.com>
References: <536CEC29.9090503@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Simplify return logic in sched_read_attr(
 )
Git-Commit-ID: 22400674945c562cf3c176d6c4178cd545e2dec9
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

Commit-ID:  22400674945c562cf3c176d6c4178cd545e2dec9
Gitweb:     http://git.kernel.org/tip/22400674945c562cf3c176d6c4178cd545e2dec9
Author:     Michael Kerrisk <mtk.manpages@gmail.com>
AuthorDate: Fri, 9 May 2014 16:54:33 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 22 May 2014 11:16:27 +0200

sched: Simplify return logic in sched_read_attr()

Gotos are chained pointlessly here, and the 'out' label
can be dispensed with.

Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/536CEC29.9090503@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2318fc4..a78c5b6 100644
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
