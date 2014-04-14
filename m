Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbaDNOIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 10:08:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51161 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbaDNOIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 10:08:35 -0400
Date: Mon, 14 Apr 2014 16:08:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <williams@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC PATCH RT] rwsem: The return of multi-reader PI rwsems
Message-ID: <20140414140820.GK11096@twins.programming.kicks-ass.net>
References: <20140409151922.5fa5d999@gandalf.local.home>
 <20140414095554.GB731@gmail.com>
 <20140414093419.14d750fa@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140414093419.14d750fa@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 09:34:19AM -0400, Steven Rostedt wrote:
> On Mon, 14 Apr 2014 11:55:54 +0200
> Ingo Molnar <mingo@kernel.org> wrote:
> 
> > > Index: linux-rt.git/kernel/rtmutex.c  
> > 
> > Side note: could you please in general include diffstats with such 
> > patches, especially since you seem to be exporting it from a Git repo?
> 
> Sure, I'll try to remember to add them. I do my work in a git repo and
> then do:
> 
> git diff > mypatch.patch
> quilt import mypatch.patch
> patch -p1 -R < mypatch.patch
> rm mypatch.patch
> 
> and then I pull patches/mypatch.patch into my email to do the RFC.
> 
> > 
> > Newfangled patch summaries like:
> > 
> >  include/linux/rtmutex.h  |   29 ++
> >  include/linux/rwsem_rt.h |    8 
> >  include/linux/sched.h    |   20 +
> >  kernel/fork.c            |   20 +
> >  kernel/futex.c           |    2 
> >  kernel/rt.c              |   27 +
> >  kernel/rtmutex.c         |  645 +++++++++++++++++++++++++++++++++++++++++++++--
> >  kernel/rtmutex_common.h  |   19 +
> >  kernel/sysctl.c          |   13 
> >  9 files changed, 753 insertions(+), 30 deletions(-)
> > 
> > Really give a useful bird's eye view of forest Fangorn, before 
> > straying into it!
> 
> diffstat patches/mypatch.patch should also give the same. Hmm, I wonder
> if quilt has any commands to do this for me?

QUILT_REFRESH_ARGS="--no-timestamps --backup --diffstat --strip-trailing-whitespace --no-index --sort -p1 -p ab"


Note the --diffstat; you'll need to add 'quilt refresh' to your cmd-list
though.
