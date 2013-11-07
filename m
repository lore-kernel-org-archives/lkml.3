Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab3KGEBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 23:01:32 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:38742 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752862Ab3KGEAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 23:00:51 -0500
Message-Id: <20131107040050.218102297@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 06 Nov 2013 23:00:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Geyslan G. Bem" <geyslan@gmail.com>
Subject: [for-next][PATCH 2/5] tracing: Add helper function tracing_is_disabled()
References: <20131107040002.605895766@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Add-helper-function-tracing_is_disabled.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Geyslan G. Bem" <geyslan@gmail.com>

This patch creates the function 'tracing_is_disabled', which
can be used outside of trace.c.

Link: http://lkml.kernel.org/r/1382141754-12155-1-git-send-email-geyslan@gmail.com

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 5 +++++
 kernel/trace/trace.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index eaacd3a..2a595cf 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2987,6 +2987,11 @@ int tracing_open_generic(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+bool tracing_is_disabled(void)
+{
+	return (tracing_disabled) ? true: false;
+}
+
 /*
  * Open and update trace_array ref count.
  * Must have the current trace_array passed to it.
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 9c27cda..4388e16 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -514,6 +514,7 @@ void tracing_reset_online_cpus(struct trace_buffer *buf);
 void tracing_reset_current(int cpu);
 void tracing_reset_all_online_cpus(void);
 int tracing_open_generic(struct inode *inode, struct file *filp);
+bool tracing_is_disabled(void);
 struct dentry *trace_create_file(const char *name,
 				 umode_t mode,
 				 struct dentry *parent,
-- 
1.8.4.rc3


