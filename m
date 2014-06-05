Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbaFEWf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 18:35:27 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:41935 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbaFEWfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 18:35:23 -0400
X-AuditID: 85900ec0-d452db9000001514-cf-5390f0a82b49
Subject: [PATCH ftrace/core 2/3] trace/kprobes: Avoid self tests if tracing
 is disabled on boot up
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, yrl.pp-manager.tt@hitachi.com
Date: Fri, 06 Jun 2014 07:35:20 +0900
Message-ID: <20140605223520.32311.56097.stgit@yunodevel>
In-Reply-To: <20140605223515.32311.71203.stgit@yunodevel>
References: <20140605223515.32311.71203.stgit@yunodevel>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If tracing is disabled on boot up, the kernel should not execute self tests.
In this patch, the kernel checks whether tracing is disabled or not
before executing self tests.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org
---
 kernel/trace/trace_kprobe.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 903ae28..ef2fba1 100644
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

