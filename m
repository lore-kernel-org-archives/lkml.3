Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbaB0NeP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:34:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55052 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbaB0NeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:34:11 -0500
Date: Thu, 27 Feb 2014 05:33:15 -0800
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-2b3942e4bb20ef8ef26515bd958c2df83d9a6210@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
In-Reply-To: <1393251121-25534-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1393251121-25534-1-git-send-email-yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] trace: Replace hardcoding of 19 with MAX_NICE
Git-Commit-ID: 2b3942e4bb20ef8ef26515bd958c2df83d9a6210
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

Commit-ID:  2b3942e4bb20ef8ef26515bd958c2df83d9a6210
Gitweb:     http://git.kernel.org/tip/2b3942e4bb20ef8ef26515bd958c2df83d9a6210
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Mon, 24 Feb 2014 22:12:01 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 27 Feb 2014 12:41:03 +0100

trace: Replace hardcoding of 19 with MAX_NICE

Use MAX_NICE instead of the value 19 for ring_buffer_benchmark.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1393251121-25534-1-git-send-email-yangds.fnst@cn.fujitsu.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/trace/ring_buffer_benchmark.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
index a5457d5..0434ff1 100644
--- a/kernel/trace/ring_buffer_benchmark.c
+++ b/kernel/trace/ring_buffer_benchmark.c
@@ -40,8 +40,8 @@ static int write_iteration = 50;
 module_param(write_iteration, uint, 0644);
 MODULE_PARM_DESC(write_iteration, "# of writes between timestamp readings");
 
-static int producer_nice = 19;
-static int consumer_nice = 19;
+static int producer_nice = MAX_NICE;
+static int consumer_nice = MAX_NICE;
 
 static int producer_fifo = -1;
 static int consumer_fifo = -1;
@@ -308,7 +308,7 @@ static void ring_buffer_producer(void)
 
 	/* Let the user know that the test is running at low priority */
 	if (producer_fifo < 0 && consumer_fifo < 0 &&
-	    producer_nice == 19 && consumer_nice == 19)
+	    producer_nice == MAX_NICE && consumer_nice == MAX_NICE)
 		trace_printk("WARNING!!! This test is running at lowest priority.\n");
 
 	trace_printk("Time:     %lld (usecs)\n", time);
