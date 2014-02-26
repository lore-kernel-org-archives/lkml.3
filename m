Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbaBZUKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 15:10:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45046 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbaBZUKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 15:10:17 -0500
Date: Wed, 26 Feb 2014 12:07:34 -0800
From: tip-bot for Paul Gortmaker <tipbot@zytor.com>
Message-ID: <tip-f96a34e27df19335155394a235ea3a096bc52a71@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de, paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de, paul.gortmaker@windriver.com
In-Reply-To: <1391711781-7466-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391711781-7466-1-git-send-email-paul.gortmaker@windriver.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] nohz:
  ensure users are aware boot CPU is not NO_HZ_FULL
Git-Commit-ID: f96a34e27df19335155394a235ea3a096bc52a71
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

Commit-ID:  f96a34e27df19335155394a235ea3a096bc52a71
Gitweb:     http://git.kernel.org/tip/f96a34e27df19335155394a235ea3a096bc52a71
Author:     Paul Gortmaker <paul.gortmaker@windriver.com>
AuthorDate: Thu, 6 Feb 2014 13:36:21 -0500
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Fri, 14 Feb 2014 17:59:17 +0100

nohz: ensure users are aware boot CPU is not NO_HZ_FULL

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
