Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992426AbaEQHKW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 03:10:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57237 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756615AbaEQHKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 03:10:21 -0400
Date: Sat, 17 May 2014 09:10:17 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Seth Jennings <sjenning@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 0/2] kpatch: dynamic kernel patching
In-Reply-To: <20140516202709.6e345117@gandalf.local.home>
Message-ID: <alpine.LNX.2.00.1405170852120.1615@pobox.suse.cz>
References: <cover.1398958771.git.jpoimboe@redhat.com> <20140505085537.GA32196@gmail.com> <20140505132638.GA14432@treble.redhat.com> <20140505141038.GA27403@localhost.localdomain> <20140505184304.GA15137@gmail.com> <5368CB6E.3090105@hitachi.com>
 <20140506082604.31928cb9@gandalf.local.home> <alpine.LNX.2.00.1405161822050.16459@pobox.suse.cz> <20140516145533.4ef7bc22@gandalf.local.home> <alpine.LNX.2.00.1405170002180.1615@pobox.suse.cz> <20140516202709.6e345117@gandalf.local.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2014, Steven Rostedt wrote:

> Why I still favor the stop_machine approach, is because the method of
> patching is a bit simpler that way. A "lazy" approach will be more
> complex and more likely to be buggy. The thing I'm arguing here is not
> the end result being a problem, but the implementation of the patching
> itself causing bugs.

Well, what can I say to this.

	21 files changed, 594 insertions(+), 10 deletions(-)

that's a complete implementation, including comments and some 
documentation.

Yes, it still has TODOs (such as patching modules as they are modprobed, 
we're working on multi-arch support, etc), but it's more or less complete 
working x86 skeleton.

> I rather have a "lazy" approach, 

I'm glad to hear that, thanks :)

> but like ftrace and its breakpoint method, the stop_machine approach is 
> the simpler way to make sure the patching works before we try to 
> optimize it.

I am still not convinced that it's more complex. It's actually lazy both 
in the way it performs patching and in implementation -- we basically set 
a flag, flip the switch, and let the universe converge to a new state by 
itself.

It's basically hard to argue about level of bugginess when no actual bugs 
are being pointed out :) (well, yes, the kthreads stuff needs to be taken 
care of, but both kgraft and kpatch have similar issues there).

Thanks,

-- 
Jiri Kosina
SUSE Labs
