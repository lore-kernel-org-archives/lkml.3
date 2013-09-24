Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab3IXJcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:32:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:55048 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753868Ab3IXJcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:32:46 -0400
Message-ID: <1380015099.5443.43.camel@pasglop>
Subject: Re: [RFC GIT PULL] softirq: Consolidation and stack overrun fix
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <peterz@infradead.org>
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
Date: Tue, 24 Sep 2013 19:31:39 +1000
In-Reply-To: <20130924082128.GJ9326@twins.programming.kicks-ass.net>
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
	 <20130924082128.GJ9326@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-24 at 10:21 +0200, Peter Zijlstra wrote:
> > I don't see how that relates to the above though...
> 
> It was a comment on the increase of per-cpu usage in generic code.

Oh I see. Ok, but some things are intrinsically per-task so if you use
per-cpu in that case you end up context switching, at least that's what
Linus alluded to. It would be nice if such construct we design so that
we still access them via the task struct on arch where such accesses are
cheap.

I think if/when we get rid of using r13 for our arch specific "PACA", it
becomes easy for me to experiment with using it for either per-cpu or
current and do some measurements. It also means I can easily switch "the
other way" if I need to. I'll dig into that, it will probably take some
time before I sanitize our code enough anyway.

Cheers,
Ben.
 

