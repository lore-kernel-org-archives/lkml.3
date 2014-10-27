Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666AbaJ0S3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 14:29:51 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:3872 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750855AbaJ0S3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:29:50 -0400
Message-Id: <20141027182702.778680710@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 27 Oct 2014 14:27:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jiri Kosina <jkosina@suse.cz>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [for-next][PATCH 0/4] ftrace: Add dynamic trampoline support
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the allocation of dynamic trampolines. It still does not
allow for dynamic ftrace_ops to use them on CONFIG_PREEMPT systems.
That will come in 3.20, as I want to test out call_rcu_tasks() for
a bit first on my own boxes.

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: 9fd7caf67913fbf35d834beaa8f9764d733a9236


Steven Rostedt (Red Hat) (4):
      ftrace/x86: Add dynamic allocated trampoline for ftrace_ops
      ftrace/x86: Show trampoline call function in enabled_functions
      ftrace/x86: Allow !CONFIG_PREEMPT dynamic ops to use allocated trampolines
      ftrace: Add more information to ftrace_bug() output

----
 arch/powerpc/kernel/ftrace.c |   2 +-
 arch/x86/kernel/ftrace.c     | 281 +++++++++++++++++++++++++++++++++++++++++--
 arch/x86/kernel/mcount_64.S  |  25 +++-
 include/linux/ftrace.h       |  12 +-
 kernel/trace/ftrace.c        | 118 +++++++++++++++---
 5 files changed, 409 insertions(+), 29 deletions(-)
