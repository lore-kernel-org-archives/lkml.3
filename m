Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab3LKRuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 12:50:44 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:39019 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab3LKRum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 12:50:42 -0500
Date: Wed, 11 Dec 2013 18:50:37 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>, Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Eder <jeder@redhat.com>, x86@kernel.org
Subject: Re: 50 Watt idle power regression bisected to Linux-3.10
Message-ID: <20131211175036.GC12431@gmail.com>
References: <alpine.DEB.2.02.1312110030330.28330@ionos.tec.linutronix.de>
 <1386732093.5964.6.camel@marge.simpson.net>
 <alpine.DEB.2.02.1312111206200.28330@ionos.tec.linutronix.de>
 <20131211113839.GF21683@pd.tnic>
 <20131211115239.GA21999@twins.programming.kicks-ass.net>
 <1386764955.12005.60.camel@marge.simpson.net>
 <20131211124352.GB21999@twins.programming.kicks-ass.net>
 <20131211134048.GH21683@pd.tnic>
 <20131211145655.GB4510@gmail.com>
 <20131211164318.GA2480@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131211164318.GA2480@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Dec 11, 2013 at 03:56:55PM +0100, Ingo Molnar wrote:
> > 
> > * Borislav Petkov <bp@alien8.de> wrote:
> > 
> > > On Wed, Dec 11, 2013 at 01:43:52PM +0100, Peter Zijlstra wrote:
> > > > Something like the below.. someone needs to double check and possibly
> > > > add SNB/IVB EX parts if they're already available.
> > > 
> > > Right, our friends at Intel would need to tell us which 
> > > families/models does AAI65 span... if, this is actually the 
> > > case.
> > 
> > I think CLFLUSH should be pretty universally available, IIRC 
> > graphics drivers were using it rather heavily in combination with 
> > write-combining MTRRs, both on Linux and on Windows.
> 
> The availability isn't the problem; the cost is. We shouldn't issue 
> one if its not required. Only 'broken' EX hardware needs it.

Well, availability could be a problem too, if some CPU (real or 
virtual) implements MWAIT but not CLFLUSH.

In theory we could make mwait an alternatives variant and patch in the 
right combination of instructions? The CLFLUSH goes to the same 
address as on which the monitoring happens, so it could be considered 
one meta-instruction.

Thansk,

	Ingo
