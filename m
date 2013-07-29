Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab3G2TXi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 15:23:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20991 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab3G2TXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 15:23:35 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=UhU88GXn1CMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=cUV243qLiH8A:10 a=VwQbUJbxAAAA:8 a=1-b_R6CxSKIfnUpslXsA:9 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130729192133.143455334@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 29 Jul 2013 15:21:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/4] [GIT PULL][RCU][3.12] tracing/rcu: Export strings to userspace
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

-- Steve

Please pull the latest ftrace/rcu tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
ftrace/rcu

Head SHA1: b7c2caaa81e8ce2643db611a661d1ef7f9fe6db8
SHA1 of first patch: 102c9323c35a83789ad5ebd3c45fa8fb389add88

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
 kernel/rcutree_plugin.h           |   42 +++++++--------
 kernel/trace/trace.h              |    3 ++
 kernel/trace/trace_printk.c       |   19 +++++++
 14 files changed, 195 insertions(+), 119 deletions(-)
