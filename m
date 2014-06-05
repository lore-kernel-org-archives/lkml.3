Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431AbaFEOfm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:35:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48366 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbaFEOfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:35:39 -0400
Date: Thu, 5 Jun 2014 07:34:46 -0700
From: "=?UTF-8?B?dGlwLWJvdCBmb3IgTWFudWVsIFNjaMO2bGxpbmc=?=" 
	<tipbot@zytor.com>
Message-ID: <tip-2538d960d0c74cdc639f05723e04a67aed1efdf9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de, manuel.schoelling@gmx.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de, manuel.schoelling@gmx.de
In-Reply-To: <1400780723-24626-1-git-send-email-manuel.schoelling@gmx.de>
References: <1400780723-24626-1-git-send-email-manuel.schoelling@gmx.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair: Use time_after() in record_wakee()
Git-Commit-ID: 2538d960d0c74cdc639f05723e04a67aed1efdf9
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

Commit-ID:  2538d960d0c74cdc639f05723e04a67aed1efdf9
Gitweb:     http://git.kernel.org/tip/2538d960d0c74cdc639f05723e04a67aed1efdf9
Author:     Manuel Schölling <manuel.schoelling@gmx.de>
AuthorDate: Thu, 22 May 2014 19:45:23 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jun 2014 11:52:02 +0200

sched/fair: Use time_after() in record_wakee()

To be future-proof and for better readability the time comparisons are modified
to use time_after() instead of plain, error-prone math.

Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1400780723-24626-1-git-send-email-manuel.schoelling@gmx.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7a0c000..c63dde9 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4066,7 +4066,7 @@ static void record_wakee(struct task_struct *p)
 	 * about the boundary, really active task won't care
 	 * about the loss.
 	 */
-	if (jiffies > current->wakee_flip_decay_ts + HZ) {
+	if (time_after(jiffies, current->wakee_flip_decay_ts + HZ)) {
 		current->wakee_flips >>= 1;
 		current->wakee_flip_decay_ts = jiffies;
 	}
