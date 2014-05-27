Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbaE0UAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 16:00:20 -0400
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:60139
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753715AbaE0UAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 16:00:18 -0400
Date: Tue, 27 May 2014 15:00:15 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: Konstantin Khlebnikov <koct9i@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Mike Marciniszyn <infinipath@intel.com>
Subject: Re: [RFC][PATCH 0/5] VM_PINNED
In-Reply-To: <20140527172930.GE11074@laptop.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1405271454370.15990@gentwo.org>
References: <20140526203232.GC5444@laptop.programming.kicks-ass.net> <CALYGNiO8FNKjtETQMRSqgiArjfQ9nRAALUg9GGdNYbpKru=Sjw@mail.gmail.com> <20140527102909.GO30445@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1405270929550.13999@gentwo.org>
 <20140527144655.GC19143@laptop.programming.kicks-ass.net> <alpine.DEB.2.10.1405271011100.14466@gentwo.org> <20140527153143.GD19143@laptop.programming.kicks-ass.net> <alpine.DEB.2.10.1405271128530.14883@gentwo.org> <20140527164341.GD11074@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405271152400.14883@gentwo.org> <20140527172930.GE11074@laptop.programming.kicks-ass.net>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2014, Peter Zijlstra wrote:

> > What do you mean by shared pages that are not shmem pages? AnonPages that
> > are referenced from multiple processes?
>
> Regular files.. they get allocated through __page_cache_alloc(). AFAIK
> there is nothing stopping people from pinning file pages for RDMA or
> other purposes. Unusual maybe, but certainly not impossible, and
> therefore we must be able to handle it.

Typically structures for RDMA are allocated on the heap.

The main use case is pinnning the executable pages in the page cache?

Pinning mmapped pagecache pages may not have the desired effect
if those pages are modified and need updates on disk with corresponding
faults to track the dirty state etc. This may get more complicated.

> > Migration is expensive and the memory registration overhead already
> > causes lots of complaints.
>
> Sure, but first to the simple thing, then if its a problem do something
> else.

I thought the main issue here were the pinning of IB/RDMA buffers.
