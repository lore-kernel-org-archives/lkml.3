Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab3LWDNw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 22:13:52 -0500
Received: from mga11.intel.com ([192.55.52.93]:7675 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756497Ab3LWDN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 22:13:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,534,1384329600"; 
   d="scan'208";a="454342639"
Message-ID: <1387768382.14728.9.camel@empanada>
Subject: Re: [PATCH 0/2] tracing: Fixes to event_triggers patches found by
 Fengguang's test bot
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Sun, 22 Dec 2013 21:13:02 -0600
In-Reply-To: <20131222030759.339128630@goodmis.org>
References: <20131222030759.339128630@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

On Sat, 2013-12-21 at 22:07 -0500, Steven Rostedt wrote:
> Tom,
> 
> This is the changes I made to fix the reports that Fengguang's kbuild test bot
> found. I folded in your change that fixes the bug with -ENODEV used in kernel.h.
> 

These look fine to me, and I didn't see any problems after running
through my normal event trigger testing with them applied.

So you can add my Acked-by and/or Tested-by..

Thanks for writing these improved versions!

Tom

> Paul,
> 
> I've Cc'd you because the second patch is fixing up RCU notation. The filter
> is protect by rcu_sched, and the first hunk of the patch is performed
> within a rcu_read_lock_sched(), and the second hunk is done on the write
> side. The tmp variable holds the old value, the value is updated, and
> then the new value gets updated. I emailed you so that you can verify
> that this all works.
> 
> Thanks!
> 
> -- Steve
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> ftrace/core
> 
> Head SHA1: 05741e383228a79eeec83644181255d2171f9f7c
> 
> 
> Steven Rostedt (Red Hat) (2):
>       tracing: Add generic tracing_lseek() function
>       tracing: Fix rcu handling of event_trigger_data filter field
> 
> ----
>  include/linux/ftrace.h              |  2 --
>  kernel/trace/ftrace.c               | 25 ++++++-------------------
>  kernel/trace/trace.c                | 14 +++++++++-----
>  kernel/trace/trace.h                |  4 +++-
>  kernel/trace/trace_events_trigger.c | 10 ++++++----
>  kernel/trace/trace_stack.c          |  2 +-
>  6 files changed, 25 insertions(+), 32 deletions(-)


