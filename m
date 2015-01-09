Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780AbbAIMeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 07:34:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60249 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932710AbbAIMeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 07:34:07 -0500
Date: Fri, 9 Jan 2015 04:33:25 -0800
From: tip-bot for Yuyang Du <tipbot@zytor.com>
Message-ID: <tip-32a8df4e0b33fccc9715213b382160415b5c4008@git.kernel.org>
Cc: a.ryabinin@samsung.com, davej@redhat.com, mingo@kernel.org,
        peterz@infradead.org, hpa@zytor.com, sasha.levin@oracle.com,
        yuyang.du@intel.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
Reply-To: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, yuyang.du@intel.com,
        sasha.levin@oracle.com, hpa@zytor.com, peterz@infradead.org,
        mingo@kernel.org, a.ryabinin@samsung.com, davej@redhat.com
In-Reply-To: <20141219002956.GA25405@intel.com>
References: <20141219002956.GA25405@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix odd values in effective_load()
  calculations
Git-Commit-ID: 32a8df4e0b33fccc9715213b382160415b5c4008
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

Commit-ID:  32a8df4e0b33fccc9715213b382160415b5c4008
Gitweb:     http://git.kernel.org/tip/32a8df4e0b33fccc9715213b382160415b5c4008
Author:     Yuyang Du <yuyang.du@intel.com>
AuthorDate: Fri, 19 Dec 2014 08:29:56 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 9 Jan 2015 11:18:54 +0100

sched: Fix odd values in effective_load() calculations

In effective_load, we have (long w * unsigned long tg->shares) / long W,
when w is negative, it is cast to unsigned long and hence the product is
insanely large. Fix this by casting tg->shares to long.

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Yuyang Du <yuyang.du@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20141219002956.GA25405@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index df2cdf7..6b99659 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4424,7 +4424,7 @@ static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
 		 * wl = S * s'_i; see (2)
 		 */
 		if (W > 0 && w < W)
-			wl = (w * tg->shares) / W;
+			wl = (w * (long)tg->shares) / W;
 		else
 			wl = tg->shares;
 
