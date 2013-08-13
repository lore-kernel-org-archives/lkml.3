Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260Ab3HMLpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 07:45:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756899Ab3HMLpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 07:45:22 -0400
Date: Tue, 13 Aug 2013 07:45:03 -0400
From: Dave Jones <davej@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [GIT PULL] tracing: final fixes for events and some
Message-ID: <20130813114503.GA31585@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ingo Molnar <mingo@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <1375712355.22073.45.camel@gandalf.local.home>
 <20130805143257.GA32639@gmail.com>
 <1375714329.22073.63.camel@gandalf.local.home>
 <20130812181325.GA19405@gmail.com>
 <20130813023922.GA1042@redhat.com>
 <20130812231443.52563398@gandalf.local.home>
 <20130813110618.GA3300@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130813110618.GA3300@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 01:06:18PM +0200, Ingo Molnar wrote:
 > 
 > * Steven Rostedt <rostedt@goodmis.org> wrote:
 > 
 > > On Mon, 12 Aug 2013 22:39:22 -0400
 > > Dave Jones <davej@redhat.com> wrote:
 > > 
 > > 
 > > > I'm not sure why I got cc'd on this, but for my part, the perf/tracing 
 > > > related bugs I've found recently may have been there for ages, but 
 > > > they were triggerable as non-root users.
 > > 
 > > Which bug was able to trigger with non-root? The hash one that you 
 > > reported? That is something with the function tracer. Are you able to 
 > > enable function tracing as non-root?
 > > 
 > > Or is it because you gave more permissions for non-root to use extra 
 > > perf commands. Because no one but root should be able to enable function 
 > > tracing, as that can add a large overhead to the system.
 > 
 > Hm, also, tracepoints should in general only be accessible to root - all 
 > sorts of random privileged info leaks through tracepoints, a thorough 
 > review and sanitizing is needed to expose that to users. (and that does 
 > not consider the complication caused by exposing timing info.)

With the benefit of sleep, I might take that back, though I'm working
from memory of a bug that I've not seen in over a month.

I may have been chasing a user-triggerable bug, and used tracing (as root)
to diagnose and then walked into one of these.  

But the recent fix where you had a test-case that did module unloads
didn't really seem to fit the profile of what I was seeing.
It's feasible that my fuzzer can trigger module _loads_, but I
don't think there's any way we can trigger an rmmod.

	Dave

