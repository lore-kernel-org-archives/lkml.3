Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582Ab3K0OIN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:08:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47607 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab3K0OIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:08:11 -0500
Date: Wed, 27 Nov 2013 06:07:14 -0800
From: tip-bot for Shigeru Yoshida <tipbot@zytor.com>
Message-ID: <tip-39e24d8ffbb6aa90222527dbd5991ec49fbbf323@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        trivial@kernel.org, peterz@infradead.org, shigeru.yoshida@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        trivial@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        shigeru.yoshida@gmail.com
In-Reply-To: <20131123.183801.769652906919404319.shigeru.yoshida@gmail.com>
References: <20131123.183801.769652906919404319.shigeru.yoshida@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix a trivial syntax misuse
Git-Commit-ID: 39e24d8ffbb6aa90222527dbd5991ec49fbbf323
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 27 Nov 2013 06:07:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  39e24d8ffbb6aa90222527dbd5991ec49fbbf323
Gitweb:     http://git.kernel.org/tip/39e24d8ffbb6aa90222527dbd5991ec49fbbf323
Author:     Shigeru Yoshida <shigeru.yoshida@gmail.com>
AuthorDate: Sat, 23 Nov 2013 18:38:01 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 26 Nov 2013 18:37:55 +0100

sched: Fix a trivial syntax misuse

Use if statement instead of while loop.

Signed-off-by: Shigeru Yoshida <shigeru.yoshida@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Kosina <trivial@kernel.org>
Link: http://lkml.kernel.org/r/20131123.183801.769652906919404319.shigeru.yoshida@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c180860..687985b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3654,7 +3654,7 @@ again:
 	}
 
 	double_rq_lock(rq, p_rq);
-	while (task_rq(p) != p_rq) {
+	if (task_rq(p) != p_rq) {
 		double_rq_unlock(rq, p_rq);
 		goto again;
 	}
