Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454Ab3KFOqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 09:46:55 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:19440 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932113Ab3KFOqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 09:46:54 -0500
Date: Wed, 6 Nov 2013 09:46:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        stable <stable@vger.kernel.org>, Kees Cook <keescook@google.com>
Subject: Re: [GIT PULL][PATCH] perf/ftrace: Fix paranoid level for enabling
 function tracer
Message-ID: <20131106094649.4abc704f@gandalf.local.home>
In-Reply-To: <20131105162407.59393ee1@gandalf.local.home>
References: <20131105162407.59393ee1@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Nov 2013 16:24:07 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Linus,
> 
> Please pull the latest ftrace/urgent tree, which can be found at:
> 

As I usually send you signed tag pull releases, I made one of those too:



Linus,

Please pull the latest ftrace-urgent-3.12 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
ftrace-urgent-3.12

Tag SHA1: f54bbe2bc77806bf4d544652a2987dd9f784a5ba
Head SHA1: d1356abac98cce8e7765186f8093da1442d74d1d


Steven Rostedt (1):
      perf/ftrace: Fix paranoid level for enabling function tracer

----
 kernel/trace/trace_event_perf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
---------------------------
commit d1356abac98cce8e7765186f8093da1442d74d1d
Author: Steven Rostedt <rostedt@goodmis.org>
Date:   Tue Nov 5 12:51:11 2013 -0500

    perf/ftrace: Fix paranoid level for enabling function tracer
    
    The current default perf paranoid level is "1" which has
    "perf_paranoid_kernel()" return false, and giving any operations that
    use it, access to normal users. Unfortunately, this includes function
    tracing and normal users should not be allowed to enable function
    tracing by default.
    
    The proper level is defined at "-1" (full perf access), which
    "perf_paranoid_tracepoint_raw()" will only give access to. Use that
    check instead for enabling function tracing.
    
    Reported-by: Dave Jones <davej@redhat.com>
    Reported-by: Vince Weaver <vincent.weaver@maine.edu>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: Ingo Molnar <mingo@kernel.org>
    Cc: Jiri Olsa <jolsa@redhat.com>
    Cc: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: stable@vger.kernel.org # 3.4+
    CVE: CVE-2013-2930
    Fixes: ced39002f5ea ("ftrace, perf: Add support to use function tracepoint in perf")
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 80c36bc..78e27e3 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -26,7 +26,7 @@ static int perf_trace_event_perm(struct ftrace_event_call *tp_event,
 {
 	/* The ftrace function trace is allowed only for root. */
 	if (ftrace_event_is_function(tp_event) &&
-	    perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
+	    perf_paranoid_tracepoint_raw() && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
 	/* No tracing, just counting, so no obvious leak */

