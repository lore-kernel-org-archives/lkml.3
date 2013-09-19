Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab3ISTvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 15:51:25 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:35749 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab3ISTvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 15:51:23 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@au1.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/3] irq: Comment on the use of inline stack for ksoftirqd
Date: Thu, 19 Sep 2013 14:51:07 -0500
Message-Id: <1379620267-25191-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1379620267-25191-1-git-send-email-fweisbec@gmail.com>
References: <1379620267-25191-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ksoftirqd shouldn't need softirq stack since it's executing
in a kernel thread with a callstack that is only beginning at
this stage.

Lets comment about that for clarity.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@au1.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mackerras <paulus@au1.ibm.com>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: James E.J. Bottomley <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/softirq.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 8c8f08b..1b0f48e 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -759,6 +759,10 @@ static void run_ksoftirqd(unsigned int cpu)
 {
 	local_irq_disable();
 	if (local_softirq_pending()) {
+		/*
+		 * Execute softirq on inline stack, as we are not deep in
+		 * the task stack here.
+		 */
 		__do_softirq();
 		rcu_note_context_switch(cpu);
 		local_irq_enable();
-- 
1.8.3.1

