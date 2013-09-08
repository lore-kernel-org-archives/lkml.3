Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab3IHKqr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 06:46:47 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:40659 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab3IHKqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 06:46:45 -0400
Date: Sun, 8 Sep 2013 12:46:41 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        josh@joshtriplett.org, niv@us.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Howells <dhowells@redhat.com>, edumazet@google.com,
        darren@dvhart.com, sbw@mit.edu,
        Linux-Arch <linux-arch@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH tip/core/rcu 8/9] nohz_full: Add full-system-idle state
 machine
Message-ID: <20130908104639.GC4501@somewhere>
References: <20130820024700.GA31075@linux.vnet.ibm.com>
 <1376966841-31774-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1376966841-31774-8-git-send-email-paulmck@linux.vnet.ibm.com>
 <CAMuHMdWtZAD3G_miFOT9DPZpfTO3nJ9J4aG_zvHV_6eVf2jdQg@mail.gmail.com>
 <20130906173047.GT3966@linux.vnet.ibm.com>
 <20130907091348.GA3487@free.fr>
 <20130907185710.GF3966@linux.vnet.ibm.com>
 <20130908103250.GA3698@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130908103250.GA3698@free.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 08, 2013 at 12:32:50PM +0200, Yann E. MORIN wrote:
> Paul, All,
> 
> On 2013-09-07 11:57 -0700, Paul E. McKenney spake thusly:
> > On Sat, Sep 07, 2013 at 11:13:48AM +0200, Yann E. MORIN wrote:
> [--SNIP--]
> > > I'll see if I can come up with a meaningfull construct that fixes your
> > > use-case. Don't hold your breath, though! ;-)
> > 
> > If not, we need to add NR_CPUS to the architectures lacking them...
> 
> Unfortunately, I was not able to come up with anything suitable.
> 
> I think your proposal to always define NR_CPUS=1 for architectures
> without SMP support is a good solution.
> 
> After all, if !SMP because the architecture does not support it, I
> believe it makes sense that NR_CPUS be defined to 1.
> 
> Unless NR_CPUS carries with it a hidden meaning about SMP being
> possible, that is, which would probably be wrong anyway, since we have
> SMP for this.

Right, if possible, the best would be to define CONFIG_NR_CPUS to a single
central place, like arch/Kconfig:

	config NR_CPUS
	default 1 if !SMP

It's a single int after all. Specific arch constraints can probably be overriden
from the arch.

> 
> Regards,
> Yann E. MORIN.
> 
> -- 
> .-----------------.--------------------.------------------.--------------------.
> |  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
> | +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
> | +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
> | http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
> '------------------------------^-------^------------------^--------------------'
