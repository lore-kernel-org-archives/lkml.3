Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751014AbaAUSxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 13:53:10 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:58138 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750773AbaAUSxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 13:53:09 -0500
Date: Tue, 21 Jan 2014 13:53:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Dave Jones <davej@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] lockdep: pack subclass/trylock/read/check into a
 single argument
Message-ID: <20140121135306.7c01892c@gandalf.local.home>
In-Reply-To: <20140121184310.GA24702@redhat.com>
References: <20140120181942.GA20783@redhat.com>
	<20140120182019.GA26515@redhat.com>
	<20140121141022.GX31570@twins.programming.kicks-ass.net>
	<20140121173534.GA25642@redhat.com>
	<20140121184310.GA24702@redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jan 2014 19:43:10 +0100
Oleg Nesterov <oleg@redhat.com> wrote:

> On 01/21, Dave Jones wrote:
> >
> > On Tue, Jan 21, 2014 at 03:10:22PM +0100, Peter Zijlstra wrote:
> >  >
> >  > I tried the below but filed to see my vmlinux shrink, maybe I'm just not
> >  > building the right kernel, or otherwise GCC is stupid.
> >  >
> >  > -extern void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
> >  > -			 int trylock, int read, int check,
> >  > -			 struct lockdep_map *nest_lock, unsigned long ip);
> >  > +struct lockdep_acquire_flags {
> >  > +	unsigned long subclass : 3;
> >  > +	unsigned long trylock  : 1;
> >  > +	unsigned long read     : 2;
> >  > +	unsigned long check    : 1;
> >  > +};
> >
> > As it's only 7 bits here, could we pack them into a char ?
> 
> Do you mean __attribute__((packed)) ?
> 

I think Dave means:

	unsigned char subclass	: 3;
	unsigned char trylock	: 1;
	unsigned char read	: 2;
	unsigned char check	: 1;

-- Steve
