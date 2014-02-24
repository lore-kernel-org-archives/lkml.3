Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbaBXONj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 09:13:39 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:42732 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbaBXONi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 09:13:38 -0500
X-IronPort-AV: E=Sophos;i="4.97,535,1389715200"; 
   d="scan'208";a="9593914"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH Resend] trace: Replace hardcoding of 19 with MAX_NICE.
Date: Mon, 24 Feb 2014 22:12:01 +0800
Message-Id: <1393251121-25534-1-git-send-email-yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <eeb2a85d74c71e0d50c88789f99ad857a6b4b7b4.1392103744.git.yangds.fnst@cn.fujitsu.com>
References: <eeb2a85d74c71e0d50c88789f99ad857a6b4b7b4.1392103744.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/24 22:11:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/24 22:11:17,
	Serialize complete at 2014/02/24 22:11:17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
cc: Steven Rostedt <rostedt@goodmis.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@redhat.com>
cc: Peter Zijlstra <peterz@infradead.org>
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
-- 
1.8.2.1

