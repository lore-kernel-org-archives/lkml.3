Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbaAUSn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 13:43:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754934AbaAUSn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 13:43:26 -0500
Date: Tue, 21 Jan 2014 19:43:10 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Dave Jones <davej@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] lockdep: pack subclass/trylock/read/check into a
	single argument
Message-ID: <20140121184310.GA24702@redhat.com>
References: <20140120181942.GA20783@redhat.com> <20140120182019.GA26515@redhat.com> <20140121141022.GX31570@twins.programming.kicks-ass.net> <20140121173534.GA25642@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140121173534.GA25642@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21, Dave Jones wrote:
>
> On Tue, Jan 21, 2014 at 03:10:22PM +0100, Peter Zijlstra wrote:
>  >
>  > I tried the below but filed to see my vmlinux shrink, maybe I'm just not
>  > building the right kernel, or otherwise GCC is stupid.
>  >
>  > -extern void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
>  > -			 int trylock, int read, int check,
>  > -			 struct lockdep_map *nest_lock, unsigned long ip);
>  > +struct lockdep_acquire_flags {
>  > +	unsigned long subclass : 3;
>  > +	unsigned long trylock  : 1;
>  > +	unsigned long read     : 2;
>  > +	unsigned long check    : 1;
>  > +};
>
> As it's only 7 bits here, could we pack them into a char ?

Do you mean __attribute__((packed)) ?

Suprizingly it helps a bit. Still "size vmlinux" is worse than with
bitmasks.

But I agreed that the code looks simpler with bitfields, so perhaps
this patch is better.

Oleg.

