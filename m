Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab3IXIVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 04:21:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41103 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab3IXIVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 04:21:44 -0400
Date: Tue, 24 Sep 2013 10:21:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@au1.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>
Subject: Re: [RFC GIT PULL] softirq: Consolidation and stack overrun fix
Message-ID: <20130924082128.GJ9326@twins.programming.kicks-ass.net>
References: <1379824754.24090.11.camel@pasglop>
 <1379824861.24090.12.camel@pasglop>
 <20130922162410.GA10649@laptop.programming.kicks-ass.net>
 <1379887000.24090.19.camel@pasglop>
 <CA+55aFwaf_Wst=AS75ydBJVQ6aJxPfAzXdt-UXj3qC9WeUt7kw@mail.gmail.com>
 <1379981427.5443.8.camel@pasglop>
 <CA+55aFwyVG4DXOEvaVTp0gE-H2Zy0Kx7Mg7RWzpxzwm_RSWEYQ@mail.gmail.com>
 <1379987527.5443.20.camel@pasglop>
 <20130924080436.GH9326@twins.programming.kicks-ass.net>
 <1380010613.5443.40.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380010613.5443.40.camel@pasglop>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 06:16:53PM +1000, Benjamin Herrenschmidt wrote:
> On Tue, 2013-09-24 at 10:04 +0200, Peter Zijlstra wrote:
> > On Tue, Sep 24, 2013 at 11:52:07AM +1000, Benjamin Herrenschmidt wrote:
> > > So if that holds, we have a solid way to do per-cpu. On one side, I tend
> > > to think that r13 being task/thread/thread_info is probably a better
> > > overall choice, I'm worried that going in a different direction than x86
> > > means generic code will get "tuned" to use per-cpu for performance
> > > critical stuff rather than task/thread/thread_info in inflexible ways.
> > 
> > The plus side of per-cpu over per-task is that one typically has a lot
> > less cpus than tasks. Also, its far easier/cheaper to iterate cpus than
> > it is to iterate tasks.
> 
> I don't see how that relates to the above though...

It was a comment on the increase of per-cpu usage in generic code.
