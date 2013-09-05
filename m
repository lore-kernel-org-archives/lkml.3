Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab3IEPdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 11:33:41 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38077 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab3IEPdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 11:33:36 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@au1.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
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
Subject: [PATCH 3/3] irq: Comment on the use of inline stack for ksoftirq
Date: Thu,  5 Sep 2013 17:33:24 +0200
Message-Id: <1378395204-25342-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1378395204-25342-1-git-send-email-fweisbec@gmail.com>
References: <1378330796.4321.50.camel@pasglop>
 <1378395204-25342-1-git-send-email-fweisbec@gmail.com>
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
 kernel/softirq.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 657e047..1de0322 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -759,6 +759,7 @@ static void run_ksoftirqd(unsigned int cpu)
 {
 	local_irq_disable();
 	if (local_softirq_pending()) {
+		/* No need to use softirq stack here */
 		__do_softirq();
 		rcu_note_context_switch(cpu);
 		local_irq_enable();
-- 
1.7.5.4

