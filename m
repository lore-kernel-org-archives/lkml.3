Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbaDRRPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 13:15:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59495 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaDRRP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 13:15:29 -0400
Date: Fri, 18 Apr 2014 19:15:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
Message-ID: <20140418171516.GR13658@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1404161326380.19325@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1404161337350.19325@vincent-weaver-1.um.maine.edu>
 <20140417094815.GA9348@gmail.com>
 <20140417114533.GJ11096@twins.programming.kicks-ass.net>
 <20140417142213.GA29338@gmail.com>
 <alpine.DEB.2.10.1404171037590.22226@vincent-weaver-1.um.maine.edu>
 <20140417145418.GM11096@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1404181042320.26918@vincent-weaver-1.um.maine.edu>
 <20140418152314.GY11182@twins.programming.kicks-ass.net>
 <20140418165958.GQ13658@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140418165958.GQ13658@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 06:59:58PM +0200, Peter Zijlstra wrote:
> On Fri, Apr 18, 2014 at 05:23:14PM +0200, Peter Zijlstra wrote:
> > OK, that's a good clue. That looks like we're freeing events that still
> > are on the owner list, which would indicate we're freeing events that
> > have a refcount.
> > 
> > I added a WARN in free_event() to check the refcount, along with a
> > number of false positives (through the perf_event_open() fail path) I do
> > appear to be getting actual fails here.
> > 
> > At least I can 'reproduce' this. Earlier attempts, even based on your
> > .config only got me very mysterious lockups -- I suspect the corruption
> > happens on a slightly different spot or so and completely messes up the
> > machine.
> 
> The below should have only made the false positives go away, but my
> machine has magically stopped going all funny on me. Could you give it a
> go?
> 

Hmm the fuzzer task seems stuck in kernel space, can't kill it anymore.

So its likely it just didn't get around to doing enough to wreck the
system or so.

/me goes stab it in the eye.
