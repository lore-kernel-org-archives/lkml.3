Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbaBNMNM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 07:13:12 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:63177 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbaBNMMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 07:12:50 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/2] nohz: ensure users are aware boot CPU is not NO_HZ_FULL
Date: Fri, 14 Feb 2014 13:12:40 +0100
Message-Id: <1392379960-4758-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1392379960-4758-1-git-send-email-fweisbec@gmail.com>
References: <1392379960-4758-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Gortmaker <paul.gortmaker@windriver.com>

This bit of information is in the Kconfig help text:

  "Note the boot CPU will still be kept outside the range to
  handle the timekeeping duty."

However neither the variable NO_HZ_FULL_ALL, or the prompt
convey this important detail, so lets add it to the prompt
to make it more explicitly obvious to the average user.

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1391711781-7466-1-git-send-email-paul.gortmaker@windriver.com
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/time/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 3ce6e8c..f448513 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -124,7 +124,7 @@ config NO_HZ_FULL
 endchoice
 
 config NO_HZ_FULL_ALL
-       bool "Full dynticks system on all CPUs by default"
+       bool "Full dynticks system on all CPUs by default (except CPU 0)"
        depends on NO_HZ_FULL
        help
          If the user doesn't pass the nohz_full boot option to
-- 
1.8.3.1

