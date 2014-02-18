Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbaBRX3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:29:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50833 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbaBRWqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:46:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guillaume Morin <guillaume@morinfr.org>
Subject: [PATCH 3.4 05/24] printk: Fix scheduling-while-atomic problem in console_cpu_notify()
Date: Tue, 18 Feb 2014 14:46:52 -0800
Message-Id: <20140218224550.376307762@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224550.221535225@linuxfoundation.org>
References: <20140218224550.221535225@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/printk.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1172,7 +1172,6 @@ static int __cpuinit console_cpu_notify(
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_DEAD:
-	case CPU_DYING:
 	case CPU_DOWN_FAILED:
 	case CPU_UP_CANCELED:
 		console_lock();


