Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804Ab3DSUMO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 16:12:14 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:6653 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab3DSUMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 16:12:13 -0400
Message-ID: <1366402328.5317.9.camel@buesod1.americas.hpqcorp.net>
Subject: Re: linux-next: Tree for Apr 18 [ call-trace: drm | x86 | smp | rcu
 related? ]
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Rik van Riel <riel@surriel.com>
Cc: sedat.dilek@gmail.com, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Paul McKenney <paul.mckenney@linaro.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Emmanuel Benisty <benisty.e@gmail.com>
Date: Fri, 19 Apr 2013 13:12:08 -0700
In-Reply-To: <517198A7.8020904@surriel.com>
References: <CA+icZUVWC+Rgd9wh4Z4CPZkEa9Pm2=2udnY5=UD1nnH0Wot1pQ@mail.gmail.com>
	 <CAKMK7uFEaiT_1siQBcp_-S0RwLvy3XSjqLn1ksq70VhNTZSfLw@mail.gmail.com>
	 <CA+icZUWQEiGecR8jgw4P-2YCKyqSDMMP0Ufwn8aBU_-AOf0a-Q@mail.gmail.com>
	 <CA+icZUWcwvFFVesJDoFNT3DbgRMXvDp7QLn+S5Ze_5d8gJRx1g@mail.gmail.com>
	 <CA+icZUXjTGSG+tejOAFgXr8EpKd7dL=-W41ha_-0N=roAxN3eg@mail.gmail.com>
	 <CA+icZUVE-ikxEp65bUHMp0WEPX_MDbA06ykzeSxygJv=9f45ig@mail.gmail.com>
	 <CA+icZUUp84vzF_0n77wsJ6dBOS26vSRCXaFUDbCQi-wG0b-Osg@mail.gmail.com>
	 <517198A7.8020904@surriel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-19 at 15:19 -0400, Rik van Riel wrote:
> On 04/19/2013 02:53 PM, Sedat Dilek wrote:
> > On Fri, Apr 19, 2013 at 6:43 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> >
> >> I tried to switch from SLUB to SLAB...
> >>
> >> ...and also from VIRT_CPU_ACCOUNTING_GEN to TICK_CPU_ACCOUNTING.
> >>
> >> 2x NOPE.
> >>
> >> In one kernel-build I saw in my console...
> >>
> >>       semop(1): encountered an error: Identifier removed

This looks like what Emmanuel was/is running into:
https://lkml.org/lkml/2013/3/30/1

> >>
> >> ...if this says sth. to you.
> >>
> > [ CC folks from below thread ]
> >
> > I have found a thread called "Re: ipc,sem: sysv semaphore scalability"
> > on LKML with a screenshot that shows the same call-trace.
> > I followed it a bit.
> > There is a patch in [3]... unconfirmed.
> >
> > Comments on the rcu read-lock and "sem_lock()" vs "sem_unlock()" from Linus.
> >
> > What's the status of this discussion?
> >
> > - Sedat -
> >
> > [1] https://lkml.org/lkml/2013/3/30/6
> > [2] http://i.imgur.com/uk6gmq1.jpg
> > [3] https://lkml.org/lkml/2013/3/31/12
> > [4] https://lkml.org/lkml/2013/3/31/77
> >
> I am at a conference right now, but when I get
> back I will check linux-next vs. all the fixes from
> the semaphore scalability email thread.

I'm back from the collab. summit, so AFAICT these still need to go in
linux-next:

ipc,sem: untangle RCU locking with find_alloc_undo:
https://lkml.org/lkml/2013/3/28/275

ipc,sem: fix lockdep false positive:
https://lkml.org/lkml/2013/3/29/119

ipc, sem: do not call sem_lock when bogus sma:
https://lkml.org/lkml/2013/3/31/12

Thanks,
Davidlohr

