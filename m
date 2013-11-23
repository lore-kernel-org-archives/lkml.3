Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab3KWJiL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 04:38:11 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:61260 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab3KWJiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 04:38:08 -0500
Date: Sat, 23 Nov 2013 18:38:01 +0900 (JST)
Message-Id: <20131123.183801.769652906919404319.shigeru.yoshida@gmail.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] sched: fix a trivial syntax misuse
From: Shigeru Yoshida <shigeru.yoshida@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use if statement instead of while loop.

Signed-off-by: Shigeru Yoshida <shigeru.yoshida@gmail.com>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5ac63c9..49028db 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3924,7 +3924,7 @@ again:
 	}
 
 	double_rq_lock(rq, p_rq);
-	while (task_rq(p) != p_rq) {
+	if (task_rq(p) != p_rq) {
 		double_rq_unlock(rq, p_rq);
 		goto again;
 	}
-- 
1.8.3.2

