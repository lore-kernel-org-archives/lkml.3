Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613AbaCRHxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 03:53:25 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:43157 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbaCRHxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 03:53:23 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] timer: use variable 'head' instead of '&work_list' in __run_timers()
Date: Tue, 18 Mar 2014 13:23:15 +0530
Message-Id: <0d8645a6efc8360c4196c9797d59343abbfdcc5e.1395129136.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already have a variable 'head' that points to '&work_list', and so we should
use that instead wherever possible.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 6394fb5..1ef3de1 100644
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
-- 
1.7.12.rc2.18.g61b472e

