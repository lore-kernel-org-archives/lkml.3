Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbaLNDOp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 22:14:45 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:59566 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbaLNDOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 22:14:44 -0500
Date: Sun, 14 Dec 2014 03:14:29 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141214031429.GR22149@ZenIV.linux.org.uk>
References: <20141213223616.GA22559@redhat.com>
 <CA+55aFwCa1+cBGxt-v487K-QBvxGyB9bL4u34zgMep9uFW+Mgw@mail.gmail.com>
 <CA+55aFydeGFQs+HZkqC1ecyh=MxOow-hw817e1q4DUrAX7uqWw@mail.gmail.com>
 <CA+55aFzuRCJDWQcBBET6x1OHThLrtJmnn=hS40tE7hNXfmfm6g@mail.gmail.com>
 <20141213233508.GN22149@ZenIV.linux.org.uk>
 <CA+55aFw5pb7g+k1EOGj6t2xqibGGUBmZMuA_YAgtyejiv76omg@mail.gmail.com>
 <20141213234730.GP22149@ZenIV.linux.org.uk>
 <CA+55aFxZWPP+wCDbwB-n=z5z_8isqdJ_4Ka6+P+KaBAY4ihw1Q@mail.gmail.com>
 <20141214003332.GQ22149@ZenIV.linux.org.uk>
 <CA+55aFxdsYMuUzdEhGThdtDJA+f1jeKn-rEH+Zrxk5=-KnsSRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxdsYMuUzdEhGThdtDJA+f1jeKn-rEH+Zrxk5=-KnsSRw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2014 at 05:35:17PM -0800, Linus Torvalds wrote:
> On Sat, Dec 13, 2014 at 4:33 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > So does SMP - this_cpu_dec() relies on preemption being disabled.
> 
> No. really. It very much does not. Not on x86, not elsewhere. It's
> part of the whole point of "this_cpu_p()". They are preemption and
> interrupt safe.
> 
> It's the "__this_cpu_op()" ones that need external protection.

Right you are - I really need to get some coffee...  Sorry...

FWIW, do we need to disable interrupts there?  After all, mnt_want_write()
and mnt_drop_write() shouldn't be done from interrupt context - they can
happen via schedule_delayed_work(), but that's it...
