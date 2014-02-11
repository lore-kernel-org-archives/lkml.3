Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750807AbaBKIaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 03:30:11 -0500
Received: from mga03.intel.com ([143.182.124.21]:3668 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbaBKIaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 03:30:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,824,1384329600"; 
   d="scan'208";a="409989864"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH] kernel/trace: fix compiler warning
Date: Tue, 11 Feb 2014 23:41:41 +0800
Message-Id: <1392133301-17974-1-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch fixes the following compiler warning:
    CC      kernel/trace/trace_events.o
  kernel/trace/trace_events.c: In function 'event_enable_read'
  kernel/trace/trace_events.c:693: warning: 'flags' may be used \
  uninitialized in this function

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
---
 kernel/trace/trace_events.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index e71ffd4..b7915f2 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -690,7 +690,7 @@ event_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
 		  loff_t *ppos)
 {
 	struct ftrace_event_file *file;
-	unsigned long flags;
+	unsigned long flags = 0;
 	char buf[4] = "0";
 
 	mutex_lock(&event_mutex);
-- 
1.7.1

