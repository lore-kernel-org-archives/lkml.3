Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748AbaJXPQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:16:37 -0400
Received: from resqmta-po-04v.sys.comcast.net ([96.114.154.163]:56176 "EHLO
	resqmta-po-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932374AbaJXPQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:16:34 -0400
Date: Fri, 24 Oct 2014 10:16:24 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Peter Zijlstra <peterz@infradead.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH 4/6] SRCU free VMAs
In-Reply-To: <20141021080740.GJ23531@worktop.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.11.1410241003430.29419@gentwo.org>
References: <20141020215633.717315139@infradead.org> <20141020222841.419869904@infradead.org> <CA+55aFwd04q+O5ejbmDL-H7_GB6DEBMiiHkn+2R1u4uWxfDO9w@mail.gmail.com> <20141021080740.GJ23531@worktop.programming.kicks-ass.net>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2014, Peter Zijlstra wrote:

> On Mon, Oct 20, 2014 at 04:41:45PM -0700, Linus Torvalds wrote:
> > On Mon, Oct 20, 2014 at 2:56 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > > Manage the VMAs with SRCU such that we can do a lockless VMA lookup.
> >
> > Can you explain why srcu, and not plain regular rcu?
> >
> > Especially as you then *note* some of the problems srcu can have.
> > Making it regular rcu would also seem to make it possible to make the
> > seqlock be just a seqcount, no?
>
> Because we need to hold onto the RCU read side lock across the entire
> fault, which can involve IO and all kinds of other blocking ops.

Hmmm... One optimization to do before we get into these changes is to work
on allowing the dropping of mmap_sem before we get to sleeping and I/O and
then reevaluate when I/O etc is complete? This is probably the longest
hold on mmap_sem that is also frequent. Then it may be easier to use
standard RCU later.





