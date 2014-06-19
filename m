Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933390AbaFSPET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 11:04:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933322AbaFSPEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:04:07 -0400
Date: Thu, 19 Jun 2014 17:03:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild-all@01.org,
        LKML <linux-kernel@vger.kernel.org>,
        Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org
Subject: Re: [trace:ftrace/core 1/3] include/trace/syscall.h:39:6: error:
	'TIF_SYSCALL_TRACEPOINT' undeclared
Message-ID: <20140619150300.GA7215@redhat.com>
References: <53a1e7ba.ZIiv6DbOB78b9RzY%fengguang.wu@intel.com> <20140618211559.76bdea15@gandalf.local.home> <20140618211737.719fcf49@gandalf.local.home> <20140618213833.731d5fc4@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140618213833.731d5fc4@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18, Steven Rostedt wrote:
>
> On Wed, 18 Jun 2014 21:17:37 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
> > On Wed, 18 Jun 2014 21:15:59 -0400
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > > On Thu, 19 Jun 2014 03:25:46 +0800
> > > kbuild test robot <fengguang.wu@intel.com> wrote:
> > >
> > > > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git ftrace/core
> > > > head:   72fa1a896d8ef355e81270667803ceb16a3dd13f
> > > > commit: 32def52ce8faec72c353b6304ca98176687e18f1 [1/3] tracing: Fix syscall_*regfunc() vs copy_process() race
> > > > config: make ARCH=xtensa allyesconfig
> > > >
> > > > All error/warnings:
> > > >
> > > >    In file included from include/linux/syscalls.h:80:0,
> > > >                     from fs/ecryptfs/keystore.c:29:
> > > >    include/trace/syscall.h: In function 'syscall_tracepoint_update':
> > > > >> include/trace/syscall.h:39:6: error: 'TIF_SYSCALL_TRACEPOINT' undeclared (first use in this function)
> > > >    include/trace/syscall.h:39:6: note: each undeclared identifier is reported only once for each function it appears in
> > > >
> > > > vim +/TIF_SYSCALL_TRACEPOINT +39 include/trace/syscall.h
> > > >
> > > >     33		struct ftrace_event_call *exit_event;
> > > >     34	};
> > > >     35
> > > >     36	#ifdef CONFIG_TRACEPOINTS
> > > >     37	static inline void syscall_tracepoint_update(struct task_struct *p)
> > > >     38	{
> > > >   > 39		if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
> > > >     40			set_tsk_thread_flag(p, TIF_SYSCALL_TRACEPOINT);
> > > >     41		else
> > > >     42			clear_tsk_thread_flag(p, TIF_SYSCALL_TRACEPOINT);
> > > >
> > > > ---
> > > > 0-DAY kernel build testing backend              Open Source Technology Center
> > > > http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
> > >
> > > My allyesconfig build passed with flying colors. Although we should
> >
> > I should elaborate. I was building against mainline, I noticed that the
> > kbuild test included linux-next.
>
> My entire test suite passed. I'm not going to bother with adding the
> header now, as it shouldn't affect mainline. I'm going to push my
> changes up to linux-next tonight and push to Linus tomorrow.

Argh... but it seems that that patch really needs a fix?

	- #ifdef CONFIG_TRACEPOINTS
	+ #ifdef CONFIG_HAVE_SYSCALL_TRACEPOINTS

or even
	- #ifdef CONFIG_TRACEPOINTS
	+ #if defined(CONFIG_TRACEPOINTS) && defined(CONFIG_HAVE_SYSCALL_TRACEPOINTS)

or I am totally confused?

Oleg.

