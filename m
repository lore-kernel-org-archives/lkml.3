Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbaEPROw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 13:14:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716AbaEPROv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 13:14:51 -0400
Date: Fri, 16 May 2014 12:14:30 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Seth Jennings <sjenning@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 0/2] kpatch: dynamic kernel patching
Message-ID: <20140516171430.GA15775@treble.redhat.com>
References: <cover.1398958771.git.jpoimboe@redhat.com>
 <20140505085537.GA32196@gmail.com>
 <20140505132638.GA14432@treble.redhat.com>
 <20140505141038.GA27403@localhost.localdomain>
 <20140505184304.GA15137@gmail.com>
 <5368CB6E.3090105@hitachi.com>
 <20140506082604.31928cb9@gandalf.local.home>
 <alpine.LNX.2.00.1405161822050.16459@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1405161822050.16459@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 06:27:27PM +0200, Jiri Kosina wrote:
> On Tue, 6 May 2014, Steven Rostedt wrote:
> 
> > > However, I also think if users can accept such freezing wait-time,
> > > it means they can also accept kexec based "checkpoint-restart" patching.
> > > So, I think the final goal of the kpatch will be live patching without
> > > stopping the machine. I'm discussing the issue on github #138, but that is
> > > off-topic. :)
> > 
> > I agree with Ingo too. Being conservative at first is the right
> > approach here. We should start out with a stop_machine making sure that
> > everything is sane before we continue. Sure, that's not much different
> > than a kexec, but lets take things one step at a time.
> > 
> > ftrace did the stop_machine (and still does for some archs), and slowly
> > moved to a more efficient method. kpatch/kgraft should follow suit.
> 
> I don't really agree here.
> 
> I actually believe that "lazy" switching kgraft is doing provides a little 
> bit more in the sense of consistency than stop_machine()-based aproach.
> 
> Consider this scenario:
> 
> 	void foo()
> 	{
> 		for (i=0; i<10000; i++) {
> 			bar(i);
> 			something_else(i);
> 		}
> 	}
> 
> Let's say you want to live-patch bar(). With stop_machine()-based aproach, 
> you can easily end-up with old bar() and new bar() being called in two 
> consecutive iterations before the loop is even exited, right? (especially 
> on preemptible kernel, or if something_else() goes to sleep).

Can you clarify why this would be a problem?  Is it because the new
bar() changed some data semantics which confused foo() or
something_else()?

> 
> With lazy-switching implemented in kgraft, this can never happen.
> 
> So I'd like to ask for a little bit more explanation why you think the 
> stop_machine()-based patching provides more sanity/consistency assurance 
> than the lazy switching we're doing.
> 
> Thanks a lot,
> 
> -- 
> Jiri Kosina
> SUSE Labs

-- 
Josh
