Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaETJhV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 05:37:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47810 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbaETJhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 05:37:19 -0400
Date: Tue, 20 May 2014 11:37:16 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Josh Poimboeuf <jpoimboe@redhat.com>
cc: Steven Rostedt <rostedt@goodmis.org>,
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
In-Reply-To: <20140516171430.GA15775@treble.redhat.com>
Message-ID: <alpine.LNX.2.00.1405201134100.1615@pobox.suse.cz>
References: <cover.1398958771.git.jpoimboe@redhat.com> <20140505085537.GA32196@gmail.com> <20140505132638.GA14432@treble.redhat.com> <20140505141038.GA27403@localhost.localdomain> <20140505184304.GA15137@gmail.com> <5368CB6E.3090105@hitachi.com>
 <20140506082604.31928cb9@gandalf.local.home> <alpine.LNX.2.00.1405161822050.16459@pobox.suse.cz> <20140516171430.GA15775@treble.redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2014, Josh Poimboeuf wrote:

> > Consider this scenario:
> > 
> > 	void foo()
> > 	{
> > 		for (i=0; i<10000; i++) {
> > 			bar(i);
> > 			something_else(i);
> > 		}
> > 	}
> > 
> > Let's say you want to live-patch bar(). With stop_machine()-based aproach, 
> > you can easily end-up with old bar() and new bar() being called in two 
> > consecutive iterations before the loop is even exited, right? (especially 
> > on preemptible kernel, or if something_else() goes to sleep).
> 
> Can you clarify why this would be a problem?  Is it because the new
> bar() changed some data semantics which confused foo() or
> something_else()?

I guess the example I used wasn't really completely illustrative, sorry 
for that. But I guess this has been answered later in the thread already; 
the thing is that you don't have a complete callgraph available (at least 
I believe you don't ...?), so you don't really know where your patched 
function will be called from, and thus you can't change function arguments 
or return value semantics; with lazy aproach, you can do that.

Thanks,

-- 
Jiri Kosina
SUSE Labs
