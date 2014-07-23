Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932959AbaGWSYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 14:24:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:38219 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932797AbaGWSYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 14:24:15 -0400
Date: Wed, 23 Jul 2014 20:24:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Random panic in load_balance() with 3.16-rc
Message-ID: <20140723182413.GC3935@laptop>
References: <53CF80EE.5050702@daenzer.net>
 <53CF844A.5050106@arm.com>
 <20140723111110.GT3935@laptop>
 <20140723113021.GP12054@laptop.lan>
 <20140723142454.GQ12054@laptop.lan>
 <CA+55aFwZ7kAqqhaE4g89CJLkpJOwGxcN4u+cc0ODfqjQ0rVMiA@mail.gmail.com>
 <20140723155526.GW3935@laptop>
 <CA+55aFzSU5u8MiGqRZ6BVojQPnxbd1hxmFY_BA=UuCAygxR8WQ@mail.gmail.com>
 <20140723170324.GZ3935@laptop>
 <CA+55aFwQSmBAs=QH9jAZz5JY7YFrDeuPH1RjFH+YKVr2NQM38g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwQSmBAs=QH9jAZz5JY7YFrDeuPH1RjFH+YKVr2NQM38g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 10:12:35AM -0700, Linus Torvalds wrote:
> On Wed, Jul 23, 2014 at 10:03 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Wed, Jul 23, 2014 at 09:54:23AM -0700, Linus Torvalds wrote:
> >>
> >> And I wonder if I have a clue. Look, load_balance_mask is a
> >> "cpumask_var_t", but I don't see a "alloc_cpumask_var()" for it.
> >> That's broken with CONFIG_CPUMASK_OFFSTACK.
> >
> > kernel/sched/core.c:sched_init()
> >
> > plays horrible allocation tricks..
> 
> No it does not. It allocates a cpumask. Nothing more. If you think it
> allocates a "cpumask_var()", you are wrong.

I was merely saying 'something' got allocated, but yes I'll agree its
not a cpumask_var_t thingy.

> I agree that the code is an unreadable mess, but that's what
> "cpumask_size()" is: the minimum required size of the bitmask in a
> cpumask.

Latest patch cures at least this part of that mess.
