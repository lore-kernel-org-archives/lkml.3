Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613Ab3JSNkz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 09:40:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219Ab3JSNky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 09:40:54 -0400
Date: Sat, 19 Oct 2013 15:34:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Geyslan G. Bem" <geyslan@gmail.com>, kernel-br@googlegroups.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        open list <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH] tracing: fix referencing after memory freeing and
	refactors code
Message-ID: <20131019133401.GA27798@redhat.com>
References: <1382060696-30746-1-git-send-email-geyslan@gmail.com> <20131017224605.2e1d4bab@gandalf.local.home> <20131019124312.GA23872@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131019124312.GA23872@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven, et all, sorry for off-topic...

You probably know that kernel/trace/ is not trivial ;) and the fact
that cscope doesn't shows the callers in kernel/trace/trace_events.c
doesn't really help.

Fixed by the patch below, but I am not sure it is fine to uglify the
code to help the buggy tools. Is there any other way?

Oleg.
---

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 368a4d5..087fff1 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -68,6 +68,9 @@ static int system_refcount_dec(struct event_subsystem *system)
 		struct ftrace_event_file *___n;				\
 		list_for_each_entry_safe(file, ___n, &tr->events, list)
 
+/* Yes. Twice to not confuse csope */
+#define while_for_each_event_file()		\
+	}
 #define while_for_each_event_file()		\
 	}
 

