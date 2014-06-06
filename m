Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaFFRVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:21:10 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:30858 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752652AbaFFRVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 13:21:06 -0400
Message-Id: <20140606172104.860348596@goodmis.org>
User-Agent: quilt/0.63-1
Date: Fri, 06 Jun 2014 12:30:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: [for-next][PATCH 5/6] tracing/kprobes: Avoid self tests if tracing is disabled on boot up
References: <20140606163034.516780857@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0004-tracing-kprobes-Avoid-self-tests-if-tracing-is-disab.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>

If tracing is disabled on boot up, the kernel should not execute tracing
self tests. The kernel should check whether tracing is disabled or not
before executing any of the tracing self tests.

Link: http://lkml.kernel.org/p/20140605223520.32311.56097.stgit@yunodevel

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_kprobe.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 903ae28962be..ef2fba1f46b5 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1377,6 +1377,9 @@ static __init int kprobe_trace_self_tests_init(void)
 	struct trace_kprobe *tk;
 	struct ftrace_event_file *file;
 
+	if (tracing_is_disabled())
+		return -ENODEV;
+
 	target = kprobe_trace_selftest_target;
 
 	pr_info("Testing kprobe tracing: ");
-- 
2.0.0.rc2


