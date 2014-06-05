Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbaFEPVR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:21:17 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:63203 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751419AbaFEPVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:21:15 -0400
Message-Id: <20140605151540.672365024@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 05 Jun 2014 11:15:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 0/5] tracing: More stuff for this merge window
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I know the merge window has opened early (strange), but I'm still
sorting out patches to get into 3.16 before I do any pushes.

I also just discovered that I'm not getting emails from Fengguang Wu's
kbuild bot tests. I haven't been since March. All this time I thought
I was good enough not to trigger those bugs, but I was naive. I'm still
working the issue with Fengguang, but from my SMTP error message, I had:

Sender address rejected: need fully-qualified address; from=<kbuild@bee>

That "kbuild@bee" seems to be causing it to be rejected. I wonder
how many others are not getting these emails.

Anyway, I'm pushing this out because they passed my tests. Now I
need to look at all the error reports that Fengguang's test reported
and fix them up (he gave me a link to where reports are).

Enjoy.

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: 64b8e48a72f45eedfdddfc62c25691d6c96ac919


Minchan Kim (1)
      tracing: Print max callstack on stacktrace bug

Petr Mladek (1)
      ftrace/x86: Call text_ip_addr() instead of the duplicated code

Steven Rostedt (Red Hat) (2)
      tracing: Remove unused variable in trace_benchmark
      tracing: Add __get_dynamic_array_len() macro for trace events

Yoshihiro YUNOMAE (1)
      tracing: Eliminate double free on failure of allocation on boot up

----
 arch/x86/kernel/ftrace.c       |   11 +----------
 include/trace/ftrace.h         |   11 ++++++++++-
 kernel/trace/trace.c           |    4 ----
 kernel/trace/trace_benchmark.c |    1 -
 kernel/trace/trace_stack.c     |   34 ++++++++++++++++++++++++++++++----
 5 files changed, 41 insertions(+), 20 deletions(-)
