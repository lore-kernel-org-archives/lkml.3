Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab3KKPyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 10:54:23 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37241 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab3KKPyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 10:54:17 -0500
Date: Mon, 11 Nov 2013 16:53:47 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: perf/tracepoint: another fuzzer generated lockup
Message-ID: <20131111155347.GK19203@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1311081440440.7281@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1311081504400.7281@vincent-weaver-1.um.maine.edu>
 <20131108200244.GB14606@localhost.localdomain>
 <alpine.DEB.2.10.1311081515210.16519@vincent-weaver-1.um.maine.edu>
 <20131108204839.GD14606@localhost.localdomain>
 <alpine.DEB.2.10.1311081612190.16519@vincent-weaver-1.um.maine.edu>
 <20131108223657.GF14606@localhost.localdomain>
 <20131109141039.GM16117@laptop.programming.kicks-ass.net>
 <20131109142056.GA26079@localhost.localdomain>
 <20131111124419.GA6740@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131111124419.GA6740@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 01:44:19PM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > > That said, I'm not sure what kernel you're running, but there were 
> > > some issues with time-keeping hereabouts, but more importantly that 
> > > second timing includes the printk() call of the first -- so that's 
> > > always going to be fucked.
> > 
> > It's a recent tip:master. So the delta debug printout is certainly 
> > buggy, meanwhile these lockup only happen with Vince selftests, and they 
> > trigger a lot of these NMI-too-long issues, or may be that's the other 
> > way round :)...
> > 
> > I'm trying to narrow down the issue, lets hope the lockup is not 
> > actually due to printk itself.
> 
> I'd _very_ strongly suggest to not include the printk() overhead in the 
> execution time delta! What that function wants to report is pure NMI 
> execution overhead, not problem reporting overhead.
> 
> That way any large number reported there is always a bug somewhere, 
> somehow.

-ENOPATCH :-)

You'll find that there's two levels of measuring NMI latency and the
outer will invariably include the reporting of the inner one; fixing
that is going to be hideously ugly.

That said, I would very strongly suggest to tear that printk() from the
NMI path, its just waiting to wreck someone's machine :-)
