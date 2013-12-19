Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab3LSJOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 04:14:35 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:59244 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab3LSJKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 04:10:19 -0500
Subject: [PATCH -tip v6 16/22] sched: Use NOKPROBE_SYMBOL macro in sched
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-arch@vger.kernel.org, Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        systemtap@sourceware.org, "David S. Miller" <davem@davemloft.net>
Date: Thu, 19 Dec 2013 09:04:33 +0000
Message-ID: <20131219090433.14309.84911.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20131219090353.14309.15496.stgit@kbuild-fedora.novalocal>
References: <20131219090353.14309.15496.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use NOKPROBE_SYMBOL macro to protect functions from
kprobes instead of __kprobes annotation in sched/core.c.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7db3a84..285a380 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2345,7 +2345,7 @@ notrace unsigned long get_parent_ip(unsigned long addr)
 #if defined(CONFIG_PREEMPT) && (defined(CONFIG_DEBUG_PREEMPT) || \
 				defined(CONFIG_PREEMPT_TRACER))
 
-void __kprobes preempt_count_add(int val)
+void preempt_count_add(int val)
 {
 #ifdef CONFIG_DEBUG_PREEMPT
 	/*
@@ -2366,8 +2366,9 @@ void __kprobes preempt_count_add(int val)
 		trace_preempt_off(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
 }
 EXPORT_SYMBOL(preempt_count_add);
+NOKPROBE_SYMBOL(preempt_count_add);
 
-void __kprobes preempt_count_sub(int val)
+void preempt_count_sub(int val)
 {
 #ifdef CONFIG_DEBUG_PREEMPT
 	/*
@@ -2388,6 +2389,7 @@ void __kprobes preempt_count_sub(int val)
 	__preempt_count_sub(val);
 }
 EXPORT_SYMBOL(preempt_count_sub);
+NOKPROBE_SYMBOL(preempt_count_sub);
 
 #endif
 


