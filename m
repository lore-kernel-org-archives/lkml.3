Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbaDQISz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 04:18:55 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:33563 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445AbaDQISu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 04:18:50 -0400
Subject: [PATCH -tip v9 18/26] sched: Use NOKPROBE_SYMBOL macro in sched
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, fche@redhat.com,
        mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 17 Apr 2014 17:18:42 +0900
Message-ID: <20140417081842.26341.83959.stgit@ltc230.yrl.intra.hitachi.co.jp>
In-Reply-To: <20140417081636.26341.87858.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140417081636.26341.87858.stgit@ltc230.yrl.intra.hitachi.co.jp>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use NOKPROBE_SYMBOL macro to protect functions from
kprobes instead of __kprobes annotation in sched/core.c.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ce9b306..86e5778 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2477,7 +2477,7 @@ notrace unsigned long get_parent_ip(unsigned long addr)
 #if defined(CONFIG_PREEMPT) && (defined(CONFIG_DEBUG_PREEMPT) || \
 				defined(CONFIG_PREEMPT_TRACER))
 
-void __kprobes preempt_count_add(int val)
+void preempt_count_add(int val)
 {
 #ifdef CONFIG_DEBUG_PREEMPT
 	/*
@@ -2503,8 +2503,9 @@ void __kprobes preempt_count_add(int val)
 	}
 }
 EXPORT_SYMBOL(preempt_count_add);
+NOKPROBE_SYMBOL(preempt_count_add);
 
-void __kprobes preempt_count_sub(int val)
+void preempt_count_sub(int val)
 {
 #ifdef CONFIG_DEBUG_PREEMPT
 	/*
@@ -2525,6 +2526,7 @@ void __kprobes preempt_count_sub(int val)
 	__preempt_count_sub(val);
 }
 EXPORT_SYMBOL(preempt_count_sub);
+NOKPROBE_SYMBOL(preempt_count_sub);
 
 #endif
 


