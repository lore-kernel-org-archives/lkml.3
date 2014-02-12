Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbaBLK2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 05:28:46 -0500
Received: from relay.parallels.com ([195.214.232.42]:55889 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbaBLKTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 05:19:37 -0500
Subject: [PATCH] smpboot: Use preempt_enable_no_resched() before schedule()
To: <linux-kernel@vger.kernel.org>
From: Kirill Tkhai <ktkhai@parallels.com>
CC: <tglx@linutronix.de>
Date: Wed, 12 Feb 2014 14:19:56 +0400
Message-ID: <20140212101954.17530.53675.stgit@tkhai>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
CC: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/smpboot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/smpboot.c b/kernel/smpboot.c
index eb89e18..c6e1c56 100644
--- a/kernel/smpboot.c
+++ b/kernel/smpboot.c
@@ -152,7 +152,7 @@ static int smpboot_thread_fn(void *data)
 		}
 
 		if (!ht->thread_should_run(td->cpu)) {
-			preempt_enable();
+			preempt_enable_no_resched();
 			schedule();
 		} else {
 			set_current_state(TASK_RUNNING);

