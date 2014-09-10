Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbaIJOdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:33:25 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54636 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaIJOdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:33:23 -0400
Date: Wed, 10 Sep 2014 16:33:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Sasha Levin <sasha.levin@oracle.com>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: perf: perf_fuzzer triggers instant reboot
Message-ID: <20140910143306.GD4783@worktop.ger.corp.intel.com>
References: <alpine.DEB.2.11.1409081343270.29974@vincent-weaver-1.umelst.maine.edu>
 <20140908185115.GI6758@twins.programming.kicks-ass.net>
 <alpine.DEB.2.11.1409091203500.14857@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.11.1409091317550.15651@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.11.1409091352260.15874@vincent-weaver-1.umelst.maine.edu>
 <20140910083136.GP6758@twins.programming.kicks-ass.net>
 <alpine.DEB.2.11.1409100914410.8981@vincent-weaver-1.umelst.maine.edu>
 <541059C9.1040200@oracle.com>
 <alpine.DEB.2.11.1409101027250.8981@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1409101027250.8981@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 10:30:31AM -0400, Vince Weaver wrote:
> On Wed, 10 Sep 2014, Sasha Levin wrote:
> 
> > On 09/10/2014 09:18 AM, Vince Weaver wrote:
> > > that's what got me looking at things again, the trinity reports.  Though I 
> > > think those involve CPU hotplugging which my fuzzer shouldn't trigger.
> > > 
> > > I do think this is the same memory corruption/reboot bug that I reported 
> > > back in February (the thread is "perf_fuzzer compiled for x32 causes 
> > > reboot" but I wasn't able to isolate the problem then either.
> > > 
> > > Somehow something is stomping over memory with a forking workload (likely 
> > > an improper free with RCU like we've seen before) but the fact that it 
> > > causes a reboot immediately makes it *really* hard to debug this.
> > 
> > Could this be http://permalink.gmane.org/gmane.linux.kernel/1779436 which
> > I saw couple days ago?
> 
> It could be.
> 
> I have about 10 open bugs with similar symptoms found with my perf_fuzzer 
> here (and a few more that are possibly the same memory corruption bug that 
> "fixes" went into the kernel but it's unclear if it actually fixed things
> or just altered the locking enough to make it harder to hit).
> 
> 	http://web.eece.maine.edu/~vweaver/projects/perf_events/fuzzer/bugs_found.html
> 
> I've been trying for months now to make progress on these but this type of 
> bug is really hard to debug.

Did we actually fix some at least? I had the idea we did get a few
sorted. But yes, this is tedious and hard going :/
