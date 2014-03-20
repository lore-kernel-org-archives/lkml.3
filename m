Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993AbaCTLjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 07:39:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49085 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757878AbaCTLji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 07:39:38 -0400
Date: Thu, 20 Mar 2014 04:39:26 -0700
From: tip-bot for Viresh Kumar <tipbot@zytor.com>
Message-ID: <tip-c41eba7de133e43ea2c998ccd484059feab200f6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        viresh.kumar@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        viresh.kumar@linaro.org, tglx@linutronix.de
In-Reply-To: <0d8645a6efc8360c4196c9797d59343abbfdcc5e.1395129136.git.viresh.kumar@linaro.org>
References: <0d8645a6efc8360c4196c9797d59343abbfdcc5e.1395129136.git.viresh.kumar@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] timer:
  Use variable head instead of &work_list in __run_timers()
Git-Commit-ID: c41eba7de133e43ea2c998ccd484059feab200f6
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

Commit-ID:  c41eba7de133e43ea2c998ccd484059feab200f6
Gitweb:     http://git.kernel.org/tip/c41eba7de133e43ea2c998ccd484059feab200f6
Author:     Viresh Kumar <viresh.kumar@linaro.org>
AuthorDate: Tue, 18 Mar 2014 13:23:15 +0530
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 20 Mar 2014 12:35:45 +0100

timer: Use variable head instead of &work_list in __run_timers()

We already have a variable 'head' that points to '&work_list', and so
we should use that instead wherever possible.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org
Link: http://lkml.kernel.org/r/0d8645a6efc8360c4196c9797d59343abbfdcc5e.1395129136.git.viresh.kumar@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 949d74e..8e503fe 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1192,7 +1192,7 @@ static inline void __run_timers(struct tvec_base *base)
 					!cascade(base, &base->tv4, INDEX(2)))
 			cascade(base, &base->tv5, INDEX(3));
 		++base->timer_jiffies;
-		list_replace_init(base->tv1.vec + index, &work_list);
+		list_replace_init(base->tv1.vec + index, head);
 		while (!list_empty(head)) {
 			void (*fn)(unsigned long);
 			unsigned long data;
