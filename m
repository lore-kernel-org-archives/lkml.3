Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab3FNNue (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 09:50:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463Ab3FNNuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 09:50:32 -0400
Date: Fri, 14 Jun 2013 09:49:47 -0400
From: Don Zickus <dzickus@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Anish Singh <anish198519851985@gmail.com>
Subject: Re: [PATCH 4/6] watchdog: Boot-disable by default on full dynticks
Message-ID: <20130614134947.GB133453@redhat.com>
References: <1371045758-5296-1-git-send-email-fweisbec@gmail.com>
 <1371045758-5296-5-git-send-email-fweisbec@gmail.com>
 <20130612170316.GO133453@redhat.com>
 <20130613131057.GA15997@somewhere>
 <20130613140207.GW133453@redhat.com>
 <20130613142210.GD16339@somewhere>
 <20130613144515.GX133453@redhat.com>
 <20130613145601.GE16339@somewhere>
 <20130613152059.GA133453@redhat.com>
 <1371138491.9844.288.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371138491.9844.288.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 11:48:11AM -0400, Steven Rostedt wrote:
> On Thu, 2013-06-13 at 11:20 -0400, Don Zickus wrote:
> 
> > I don't know enough about how full dynticks work to even present a
> > solution.  But currently I was working with the Red Hat performance team
> > to enhance perf to help our customers diagnose performance problems
> > easier.
> > 
> > My fear is anyone who uses full dynticks and has issues, can't use perf to
> > help diagnose their problems because it will change the dynamics of the
> > problem.  And with the current huge drop in performance in cpu_idle (as
> > compared to RHEL-6's 2.6.32 kernel) due to what seems to be miscalculated
> > c-states, one might have a hard time evaluating if full dynticks is doing
> > the right thing or not.
> 
> This needs to be fixed, but not for 3.11. Although, you can still use
> ftrace to diagnose it.

Ok.  At least we both agree it shouldn't stay like this and needs fixing.

> 
> > 
> > Then again perhaps full dynticks isn't useful for distros like RHEL.
> 
> It will be very useful for RHEL. But its still very new, and I wouldn't
> recommend using it in a production environment yet. There's still a few
> issues that need to be worked out, including this one. When the issues
> are fixed, then RHEL and other distributions will definitely want to
> enable this.
> 
> > 
> > That's why I was hoping to solve the underlying problem as opposed to
> > accepting patches like this which work around the symptoms.
> 
> For now it's just to get things working as people expect it to. First
> impressions are very important, and if someone enables it and sees it
> makes no difference, they may from then on never trust it. The way to
> handle that is to make sure it works when enabled, even if it disables
> some other cool features. But as I said, it shouldn't be used in
> production quite yet.
> 
> > 
> > Again, my knowledge of full dynticks is poor, so I have almost no idea of
> > the complexities surrounding the problem and how hard it is to even solve
> > it.
> 
> The concept behind full dynamic ticks is very easy. When you set a given
> CPU(s) to dynamic tick, when it only has a single task scheduled on that
> CPU, it disables the periodic tick. This removes essentially *all*
> latency from the kernel! That is, if the task is doing some complex

Including SMMi latency? ;-)

> calculations, it wont be interrupted for kernel maintenance. A lot of
> Red Hat customers would love to have this feature. It allows for
> extremely low latency actions even without a real-time kernel. Heck, it
> works without even kernel preemption.

Interesting.

> 
> Now removing the periodic tick is not a trivial task, and this is where
> all our issues come from. In fact, we can not even completely remove the
> tick yet, we just move it to 1 HZ instead of whatever the CONFIG_HZ is
> set to. We have to handle everything that depends on that tick, which
> includes perf, among other things.

Which part of perf is dependent on the tick?  Just curious.

Cheers,
Don
