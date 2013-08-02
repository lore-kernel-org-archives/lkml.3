Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab3HBCm0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 22:42:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21733 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab3HBCmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 22:42:24 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=pejE-yLFeWcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=D9deyScab2UA:10 a=VwQbUJbxAAAA:8 a=ornm1ghUKSdw4W3e3bAA:9 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130802023933.677590002@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 01 Aug 2013 22:39:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/4 v2] [GIT PULL][RCU][3.12] tracing/rcu: Export strings to userspace
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

As we talked about earlier, I set up a branch based off of v3.11-rc2 which
the first patch has my tracing patch I need for other updates, and
the other three are RCU specific patches that you should take.

You can either just pull this branch from my tree, or you can pull
just the first patch (to keep the same SHA1) and apply the other three
patches any way you want.

I tested all these patches through my standard tests, but I did not run
the RCU ones through any specific RCU tests (like rcutorture). They
shouldn't affect the process of RCU in anyway and only should touch
the way trace points export their strings. You may want to run them through
other tests just to make sure there isn't some strange side effect I
caused. :-)

Note the "-2" on the branch name.

-- Steve

v2 changes:

  Remove const from char * in rcu_nocb_setup(), parse_rcu_nocb_poll(), and
  print_cpu_stall_fast_no_hz(). I got a little to carried away with my
  consts!

Please pull the latest ftrace/rcu-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
ftrace/rcu-2

Head SHA1: f7f7bac9cb1c50783f15937a11743655a5756a36


Steven Rostedt (Red Hat) (4):
      tracing: Add __tracepoint_string() to export string pointers
      rcu: Add const annotation to char * for RCU tracepoints and functions
      rcu: Simplify RCU_STATE_INITIALIZER() macro
      rcu: Have the RCU tracepoints use the tracepoint_string infrastructure

----
 include/asm-generic/vmlinux.lds.h |    7 ++-
 include/linux/ftrace_event.h      |   34 ++++++++++++
 include/linux/rcupdate.h          |    4 +-
 include/trace/events/rcu.h        |   82 ++++++++++++++---------------
 kernel/rcu.h                      |    2 +-
 kernel/rcupdate.c                 |    2 +-
 kernel/rcutiny.c                  |    2 +-
 kernel/rcutiny_plugin.h           |    2 +-
 kernel/rcutorture.c               |    8 +--
 kernel/rcutree.c                  |  105 +++++++++++++++++++++----------------
 kernel/rcutree.h                  |    2 +-
 kernel/rcutree_plugin.h           |   36 ++++++-------
 kernel/trace/trace.h              |    3 ++
 kernel/trace/trace_printk.c       |   19 +++++++
 14 files changed, 192 insertions(+), 116 deletions(-)
