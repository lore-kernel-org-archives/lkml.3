Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498AbaBUVev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:34:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59435 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756473AbaBUVet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:34:49 -0500
Date: Fri, 21 Feb 2014 13:34:15 -0800
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-dbebf7f826e1b3935f8bcd5d9681bf97708a7ddb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tj@kernel.org, tglx@linutronix.de,
        yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tj@kernel.org, tglx@linutronix.de,
        yangds.fnst@cn.fujitsu.com
In-Reply-To: <6d85138180c00ce86975addab6e34b24b84f00a5.1392103744.git.yangds.fnst@cn.fujitsu.com>
References: <6d85138180c00ce86975addab6e34b24b84f00a5.1392103744.git.yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] workqueue:
  Replace hardcoding of -20 and 19 with MIN_NICE and MAX_NICE.
Git-Commit-ID: dbebf7f826e1b3935f8bcd5d9681bf97708a7ddb
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

Commit-ID:  dbebf7f826e1b3935f8bcd5d9681bf97708a7ddb
Gitweb:     http://git.kernel.org/tip/dbebf7f826e1b3935f8bcd5d9681bf97708a7ddb
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Tue, 11 Feb 2014 15:34:52 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 21:43:21 +0100

workqueue: Replace hardcoding of -20 and 19 with MIN_NICE and MAX_NICE.

Cc: Ingo Molnar <mingo@kernel.org>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/6d85138180c00ce86975addab6e34b24b84f00a5.1392103744.git.yangds.fnst@cn.fujitsu.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/workqueue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 193e977..3fa5b8f 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3225,7 +3225,7 @@ static ssize_t wq_nice_store(struct device *dev, struct device_attribute *attr,
 		return -ENOMEM;
 
 	if (sscanf(buf, "%d", &attrs->nice) == 1 &&
-	    attrs->nice >= -20 && attrs->nice <= 19)
+	    attrs->nice >= MIN_NICE && attrs->nice <= MAX_NICE)
 		ret = apply_workqueue_attrs(wq, attrs);
 	else
 		ret = -EINVAL;
