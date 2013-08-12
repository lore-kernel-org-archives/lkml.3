Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab3HLSNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 14:13:37 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:41027 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab3HLSNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 14:13:30 -0400
Date: Mon, 12 Aug 2013 20:13:25 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: [GIT PULL] tracing: final fixes for events and some
Message-ID: <20130812181325.GA19405@gmail.com>
References: <1375712355.22073.45.camel@gandalf.local.home>
 <20130805143257.GA32639@gmail.com>
 <1375714329.22073.63.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375714329.22073.63.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 2013-08-05 at 16:32 +0200, Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > Linus,
> > > 
> > > Oleg Nesterov has been working hard in closing all the holes that can 
> > > lead to race conditions between deleting an event and accessing an event 
> > > debugfs file. This included a fix to the debugfs system (acked by Greg 
> > > Kroah-Hartman). We think that all the holes have been patched and 
> > > hopefully we don't find more. I haven't marked all of them for stable 
> > > because I need to examine them more to figure out how far back some of 
> > > the changes need to go.
> > 
> > Sigh, that's quite some churn still - unless these bugs were introduced in 
> > the v3.11 merge window (i.e. are genuine _regressions_), shouldn't such 
> > invasive fixes really go into v3.12 instead?
> 
> Some of these changes I could have pushed out in an earlier -rc, but we
> were still discussing exactly how to fix these races, and I wanted the
> right fix not the quickest fix. Not to mention, I wanted to heavily test
> a lot of these changes which meant taking time to do so. We have a good
> idea what the problem was, we wanted the best fix for the issue.
> 
> Now are these regressions? For 3.11, probably not. I think some of these
> bugs can cause crashes back to at least 3.4, perhaps even 3.0. If I can
> crash 3.0 which means it's not a regression, does that mean I should
> wait for 3.12 and then push everything to stable? Is that what we
> decided to do in that "when to use stable tag" discussion we had?
> 
> > 
> > I see that some of the fixes here fix issues that your earlier 
> > post-rc1 rounds of non-regression fixes introduced to begin with. 
> > That's really not a good pattern either IMO.
> 
> Not really. The earlier fixes closed some of the holes but were not good 
> enough. They didn't cause more regressions, but the method use to fix 
> the regressions it was trying to solve wasn't going to work when we saw 
> the extent of the regressions that had to be fixed. Oleg came up with a 
> better method, which meant that we had to undo the original fix, for a 
> even better fix.

My point is that _neither_ should have gone in after the merge window. 
-rc1 and onwards are to fix regressions caused in the merge window, full 
stop. Yet there was a steady stream of tracing changes in kernel/ that at 
best fixed ancient bugs that are only root triggerable and which nobody 
actually triggered all that much. Followed by fixes to the fixes.

I.e. the very definition and exemplifaction of stuff that should have gone 
to v3.12 ...

Anyway, this isn't a NAK or anything drastic, just for future reference
:-)

Thanks,

	Ingo
