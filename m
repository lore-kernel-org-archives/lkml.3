Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617Ab3GQQos (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:44:48 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:53331 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816Ab3GQQon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:44:43 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>, Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Mike Galbraith <efault@gmx.de>, Kevin Hilman <khilman@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 02/18] nohz: fix compile warning in tick_nohz_init()
Date: Wed, 17 Jul 2013 18:44:15 +0200
Message-Id: <1374079471-3129-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1374079471-3129-1-git-send-email-fweisbec@gmail.com>
References: <1374079471-3129-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zhong <zhong@linux.vnet.ibm.com>

cpu is not used after commit 5b8621a68fdcd2baf1d3b413726f913a5254d46a

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/time/tick-sched.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 6f47049..088c411 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -344,8 +344,6 @@ static int tick_nohz_init_all(void)
 
 void __init tick_nohz_init(void)
 {
-	int cpu;
-
 	if (!have_nohz_full_mask) {
 		if (tick_nohz_init_all() < 0)
 			return;
-- 
1.7.5.4

