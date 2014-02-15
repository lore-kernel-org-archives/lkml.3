Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbaBOMw6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 07:52:58 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:62513 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068AbaBOMw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 07:52:57 -0500
Date: Sat, 15 Feb 2014 13:52:51 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Dario Faggioli <raistlin@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        rostedt@goodmis.org, Oleg Nesterov <oleg@redhat.com>,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, Linux Kernel <linux-kernel@vger.kernel.org>,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com
Subject: Re: [PATCH 01/13] sched: Add 3 new scheduler syscalls to support an
 extended scheduling parameters ABI
Message-ID: <20140215125251.GA5333@gmail.com>
References: <20131217122720.950475833@infradead.org>
 <20131217123352.692059839@infradead.org>
 <CAHO5Pa3=+Zhg72tVfddSUvgirUyObir6atJVo4_16bVWB2Osgw@mail.gmail.com>
 <20140121153851.GZ31570@twins.programming.kicks-ass.net>
 <CAKgNAkgw+U44SH0wd_06ZMXaCC9nCX4NZxZHkMKUdC7E7YxBhQ@mail.gmail.com>
 <20140214161929.GL27965@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140214161929.GL27965@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> > > SYNOPSIS
> > >         #include <sched.h>
> > >
> > >         struct sched_attr {
> > >                 u32 size;
> > >
> > >                 u32 sched_policy;
> > >                 u64 sched_flags;
> > [...]
> > >         };
> > >
> > >         int sched_setattr(pid_t pid, const struct sched_attr *attr);
> > >
> > >         int sched_getattr(pid_t pid, const struct sched_attr *attr, unsigned int size);
> > 
> > So, I that there's a flags field in the structure, which allows for
> > some extensibility for these calls in the future. However, is it
> > worthwhile to consider adding a 'flags' argument in the base signature
> > of either of these calls, to allow for some possible extensions in the
> > future. (See http://lwn.net/SubscriberLink/585415/7b905c0248a158a2/ ).
> 
> Sure why not.. I picked 'unsigned long' for the flags argument; I 
> don't think there's a real standard for this, I've seen: 'int' 
> 'unsigned int' and 'unsigned long' flags.
> 
> Please holler if there is indeed a preference and I picked the wrong
> one.

Yo!

So, since this is an ABI, if it's a true 64-bit flags value then 
please make it u64 - and 'unsigned int' or u32 otherwise. I don't 
think we have many (any?) 'long' argument syscall ABIs.

'unsigned long' is generally a bad choice because it's u32 on 32-bit 
platforms and u64 on 64-bit platforms.

Now, for syscall argument ABIs it's not a lethal mistake to make (as 
compared to say ABI data structures), because syscall arguments have 
their own types and width anyway, so any definition mistake can 
usually be fixed after the fact.

Thanks,

	Ingo
