Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbaBUNTL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:19:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47705 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933101AbaBUNCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 08:02:10 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guillaume Morin <guillaume@morinfr.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 27/60] printk: Fix scheduling-while-atomic problem in console_cpu_notify()
Date: Fri, 21 Feb 2014 13:00:54 +0000
Message-Id: <1392987687-15367-28-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
References: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.31 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

commit 85eae82a0855d49852b87deac8653e4ebc8b291f upstream.

The console_cpu_notify() function runs with interrupts disabled in the
CPU_DYING case.  It therefore cannot block, for example, as will happen
when it calls console_lock().  Therefore, remove the CPU_DYING leg of
the switch statement to avoid this problem.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Guillaume Morin <guillaume@morinfr.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/printk.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index e959512..0d430b1 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1827,7 +1827,6 @@ static int __cpuinit console_cpu_notify(struct notifier_block *self,
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_DEAD:
-	case CPU_DYING:
 	case CPU_DOWN_FAILED:
 	case CPU_UP_CANCELED:
 		console_lock();
-- 
1.9.0

