Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab3A1S5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 13:57:11 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:38667 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752523Ab3A1S5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 13:57:08 -0500
Date: Mon, 28 Jan 2013 18:57:07 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Kent Overstreet <koverstreet@google.com>
cc: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk,
        tytso@mit.edu, Oleg Nesterov <oleg@redhat.com>,
        srivatsa.bhat@linux.vnet.ibm.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 23/32] Generic dynamic per cpu refcounting
In-Reply-To: <20130128183246.GB26407@google.com>
Message-ID: <0000013c82851c07-a8caedf9-3b1d-4399-83c1-dde95b0b1961-000000@email.amazonses.com>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com> <1356573611-18590-26-git-send-email-koverstreet@google.com> <20130125005136.GE2373@mtj.dyndns.org> <87libhpz4h.fsf@rustcorp.com.au> <20130128175304.GX26407@google.com>
 <20130128175951.GA22465@mtj.dyndns.org> <20130128183246.GB26407@google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2013, Kent Overstreet wrote:

> > It goes down to how we allocate page tables.  percpu depends on
> > vmalloc space allocation which in turn depends on page table
> > allocation which unfortunately assumes GFP_KERNEL and is spread all
> > across different architectures.  Adding @gfp to it came up a couple
> > times but the cases weren't strong enough to push it all the way
> > through.  There are some aspects that I like about forcing GFP_KERNEL
> > on all percpu allocations but if there are strong enough cases and
> > someone is willing enough to push it through, maybe.
>
> Ahh, thanks for explaining, was curious about that.

I think its good not to allocate percpu memory in hot paths. Otherwise the
percpu allocator would become much more complex due to locking constraints
of all those hot paths (tried that in the slab allocators once which
ended up in a multi year issue with locking). It is usually possible to
allocate the percpu areas when the struct they belong to is allocated.
