Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab3KTEXN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 23:23:13 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:60149 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab3KTEWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 23:22:50 -0500
Subject: [PATCH -tip v3 22/23] sched: Use NOKPROBE_SYMBOL macro in sched
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-arch@vger.kernel.org, Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        virtualization@lists.linux-foundation.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        systemtap@sourceware.org, "David S. Miller" <davem@davemloft.net>
Date: Wed, 20 Nov 2013 04:22:43 +0000
Message-ID: <20131120042243.15296.96194.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20131120042148.15296.88360.stgit@kbuild-fedora.novalocal>
References: <20131120042148.15296.88360.stgit@kbuild-fedora.novalocal>
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
index 504fdbd..fece2e3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2342,7 +2342,7 @@ notrace unsigned long get_parent_ip(unsigned long addr)
 #if defined(CONFIG_PREEMPT) && (defined(CONFIG_DEBUG_PREEMPT) || \
 				defined(CONFIG_PREEMPT_TRACER))
 
-void __kprobes preempt_count_add(int val)
+void preempt_count_add(int val)
 {
 #ifdef CONFIG_DEBUG_PREEMPT
 	/*
@@ -2363,8 +2363,9 @@ void __kprobes preempt_count_add(int val)
 		trace_preempt_off(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
 }
 EXPORT_SYMBOL(preempt_count_add);
+NOKPROBE_SYMBOL(preempt_count_add);
 
-void __kprobes preempt_count_sub(int val)
+void preempt_count_sub(int val)
 {
 #ifdef CONFIG_DEBUG_PREEMPT
 	/*
@@ -2385,6 +2386,7 @@ void __kprobes preempt_count_sub(int val)
 	__preempt_count_sub(val);
 }
 EXPORT_SYMBOL(preempt_count_sub);
+NOKPROBE_SYMBOL(preempt_count_sub);
 
 #endif
 


