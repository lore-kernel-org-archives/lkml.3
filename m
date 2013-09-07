Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860Ab3IGS5b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 14:57:31 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:57610 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab3IGS52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 14:57:28 -0400
Date: Sat, 7 Sep 2013 11:57:10 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        josh@joshtriplett.org, niv@us.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Howells <dhowells@redhat.com>, edumazet@google.com,
        darren@dvhart.com,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        sbw@mit.edu, Linux-Arch <linux-arch@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH tip/core/rcu 8/9] nohz_full: Add full-system-idle state
 machine
Message-ID: <20130907185710.GF3966@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130820024700.GA31075@linux.vnet.ibm.com>
 <1376966841-31774-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1376966841-31774-8-git-send-email-paulmck@linux.vnet.ibm.com>
 <CAMuHMdWtZAD3G_miFOT9DPZpfTO3nJ9J4aG_zvHV_6eVf2jdQg@mail.gmail.com>
 <20130906173047.GT3966@linux.vnet.ibm.com>
 <20130907091348.GA3487@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130907091348.GA3487@free.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090718-0928-0000-0000-0000017832CF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 07, 2013 at 11:13:48AM +0200, Yann E. MORIN wrote:
> Paul, All,
> 
> On 2013-09-06 10:30 -0700, Paul E. McKenney spake thusly:
> [--SNIP--]
> > I also tried using Kconfig "if":
> > 
> > if SMP
> > config NR_CPUS_REALLY
> > 	int "Fixed version of NR_CPUS"
> > 	default NR_CPUS
> > endif
> > if !SMP
> > config NR_CPUS_REALLY
> > 	int "Fixed version of NR_CPUS"
> > 	default 1 if !SMP
> 
> The 'if !SMP' here is unneeded, you're already in a 'if !SMP' if-block.

Agreed, though I get the same result even without the !SMP.

> > endif
> > 
> > However, Kconfig complained about the use of NR_CPUS even though this
> > was under an "if" whose condition was not set.  Perhaps someone with
> > better Kconfig-fu than I have can come up with something.
> 
> That's because the 'if' condition is added to the dependency list of the
> symbol(s) that is(are) enclosed in the if.
> 
> 'if' in Kconfig behaves the same way as an 'if' in C. What you expected
> (I believe) was the behaviour of '#ifdef', which is not the case. From
> Documentation/kbuild/kconfig-language.txt:
> 
>     ---8<---
>     if:
> 
>             "if" <expr>
>             <if block>
>             "endif"
> 
>     This defines an if block. The dependency expression <expr> is appended
>     to all enclosed menu entries.
>     ---8<---

OK, I did read this, but misunderstood it.

> There's no equivlaent to '#ifdef' in Kconfig.
> 
> I'll see if I can come up with a meaningfull construct that fixes your
> use-case. Don't hold your breath, though! ;-)

If not, we need to add NR_CPUS to the architectures lacking them...

								Thanx, Paul

