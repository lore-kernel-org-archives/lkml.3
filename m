Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759397Ab3ICFEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 01:04:47 -0400
Received: from intranet.asianux.com ([58.214.24.6]:26000 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab3ICFEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 01:04:46 -0400
X-Spam-Score: -100.9
Message-ID: <52256DAD.4090908@asianux.com>
Date: Tue, 03 Sep 2013 13:03:41 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, bsingharora@gmail.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel/delayacct.c: remove redundancy checking in __delayacct_add_tsk()
References: <5212D703.5080405@asianux.com> <20130821151025.77673f0f3cad748a80086a16@linux-foundation.org> <521574A5.30308@asianux.com>
In-Reply-To: <521574A5.30308@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wrapper function delayacct_add_tsk() already checked 'tsk->delays',
and __delayacct_add_tsk() has no another direct callers, so can remove
the redundancy checking code.

And the label 'done' is also useless, so remove it, too.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/delayacct.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/kernel/delayacct.c b/kernel/delayacct.c
index d473988..54996b7 100644
--- a/kernel/delayacct.c
+++ b/kernel/delayacct.c
@@ -108,12 +108,6 @@ int __delayacct_add_tsk(struct taskstats *d, struct task_struct *tsk)
 	struct timespec ts;
 	cputime_t utime, stime, stimescaled, utimescaled;
 
-	/* Though tsk->delays accessed later, early exit avoids
-	 * unnecessary returning of other data
-	 */
-	if (!tsk->delays)
-		goto done;
-
 	tmp = (s64)d->cpu_run_real_total;
 	task_cputime(tsk, &utime, &stime);
 	cputime_to_timespec(utime + stime, &ts);
@@ -158,7 +152,6 @@ int __delayacct_add_tsk(struct taskstats *d, struct task_struct *tsk)
 	d->freepages_count += tsk->delays->freepages_count;
 	spin_unlock_irqrestore(&tsk->delays->lock, flags);
 
-done:
 	return 0;
 }
 
-- 
1.7.7.6
