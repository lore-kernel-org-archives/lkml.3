Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab3HBPvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 11:51:18 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:51017 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022Ab3HBPvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 11:51:17 -0400
Date: Fri, 2 Aug 2013 08:51:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/4 v2] [GIT PULL][RCU][3.12] tracing/rcu: Export strings
 to userspace
Message-ID: <20130802155111.GA3836@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130802023933.677590002@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130802023933.677590002@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080215-7606-0000-0000-00000DEB722F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 10:39:33PM -0400, Steven Rostedt wrote:
> Paul,
> 
> As we talked about earlier, I set up a branch based off of v3.11-rc2 which
> the first patch has my tracing patch I need for other updates, and
> the other three are RCU specific patches that you should take.
> 
> You can either just pull this branch from my tree, or you can pull
> just the first patch (to keep the same SHA1) and apply the other three
> patches any way you want.
> 
> I tested all these patches through my standard tests, but I did not run
> the RCU ones through any specific RCU tests (like rcutorture). They
> shouldn't affect the process of RCU in anyway and only should touch
> the way trace points export their strings. You may want to run them through
> other tests just to make sure there isn't some strange side effect I
> caused. :-)
> 
> Note the "-2" on the branch name.

I have merged these into v3.11-rc3 in my local tree like this:

# git log --pretty=oneline v3.11-rc3..
a6f8eb9e4c18ba0e9a2ed4d2dec888440da12549 Merge branch 'ftrace/rcu-2' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace into rostedt.2013.08.02a
f7f7bac9cb1c50783f15937a11743655a5756a36 rcu: Have the RCU tracepoints use the tracepoint_string infrastructure
a41bfeb2f8ed59410be7ca0f8fbc6138a758b746 rcu: Simplify RCU_STATE_INITIALIZER() macro
e66c33d579ea566d10e8c8695a7168aae3e02992 rcu: Add const annotation to char * for RCU tracepoints and functions
102c9323c35a83789ad5ebd3c45fa8fb389add88 tracing: Add __tracepoint_string() to export string pointers

Amazingly enough, there is only one trivial conflict with the current
3.12 RCU commits, so my plan is to treat these commits as a separate
topic branch for RCU.

							Thanx, Paul

> -- Steve
> 
> v2 changes:
> 
>   Remove const from char * in rcu_nocb_setup(), parse_rcu_nocb_poll(), and
>   print_cpu_stall_fast_no_hz(). I got a little to carried away with my
>   consts!
> 
> Please pull the latest ftrace/rcu-2 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> ftrace/rcu-2
> 
> Head SHA1: f7f7bac9cb1c50783f15937a11743655a5756a36
> 
> 
> Steven Rostedt (Red Hat) (4):
>       tracing: Add __tracepoint_string() to export string pointers
>       rcu: Add const annotation to char * for RCU tracepoints and functions
>       rcu: Simplify RCU_STATE_INITIALIZER() macro
>       rcu: Have the RCU tracepoints use the tracepoint_string infrastructure
> 
> ----
>  include/asm-generic/vmlinux.lds.h |    7 ++-
>  include/linux/ftrace_event.h      |   34 ++++++++++++
>  include/linux/rcupdate.h          |    4 +-
>  include/trace/events/rcu.h        |   82 ++++++++++++++---------------
>  kernel/rcu.h                      |    2 +-
>  kernel/rcupdate.c                 |    2 +-
>  kernel/rcutiny.c                  |    2 +-
>  kernel/rcutiny_plugin.h           |    2 +-
>  kernel/rcutorture.c               |    8 +--
>  kernel/rcutree.c                  |  105 +++++++++++++++++++++----------------
>  kernel/rcutree.h                  |    2 +-
>  kernel/rcutree_plugin.h           |   36 ++++++-------
>  kernel/trace/trace.h              |    3 ++
>  kernel/trace/trace_printk.c       |   19 +++++++
>  14 files changed, 192 insertions(+), 116 deletions(-)
> 

