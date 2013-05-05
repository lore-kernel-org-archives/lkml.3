Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454Ab3EEVZV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 17:25:21 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:38034 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab3EEVZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 17:25:19 -0400
Date: Sun, 5 May 2013 14:25:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL, RFC] Full dynticks, CONFIG_NO_HZ_FULL feature
Message-ID: <20130505212511.GC3659@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130505110351.GA4768@gmail.com>
 <CA+55aFzPHkCH7CVZ4tkaF91+=GLZAxxncTq0J9d6AKpSPqovZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzPHkCH7CVZ4tkaF91+=GLZAxxncTq0J9d6AKpSPqovZw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050521-7606-0000-0000-00000B187FE2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 05, 2013 at 01:33:45PM -0700, Linus Torvalds wrote:
> On Sun, May 5, 2013 at 4:03 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > Please consider pulling the latest timers-nohz-for-linus git tree from:
> 
> Ok, it seems to work for me, so pulled.
> 
> However, by "work for me" I mean "doesn't actually seem to make any
> difference for me". Maybe I'm odd, but the most common situation is
> either a fairly idle machine (in which case the old NOHZ did fine) or
> a fairly over-crowded one when I'm running something sufficiently
> threaded (in which case the new NOHZ_FULL doesn't do anything either).
> 
> So I really hope the "cpu has more than one running thread" case is
> getting a lot of attention. Not for 3.10, but right now it seems to
> still result in the same old 1kHz timer interrupts..
> 
> So I haven't actually found a real load where any of this makes a
> noticeable *difference*.

The workloads where we expect the most noticeable differences are
HPC workloads with short iterations and a HPC-style barrier between
each interation on the one hand and real-time workloads on the other.
My guess is that you aren't doing too much of either.

We do have some measurements taken on an early prototype of this patchset,
which are on slides 5 and 6 of:

http://linuxplumbersconf.org/2009/slides/Josh-Triplett-painless-kernel.pdf

This is for an HPC workload with a 100-microsecond iteration time.

							Thanx, Paul

