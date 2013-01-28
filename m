Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436Ab3A1Scv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 13:32:51 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:34444 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab3A1Sct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 13:32:49 -0500
Date: Mon, 28 Jan 2013 10:32:46 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, zab@redhat.com,
        bcrl@kvack.org, jmoyer@redhat.com, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, tytso@mit.edu,
        Oleg Nesterov <oleg@redhat.com>, srivatsa.bhat@linux.vnet.ibm.com,
        Christoph Lameter <cl@linux.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 23/32] Generic dynamic per cpu refcounting
Message-ID: <20130128183246.GB26407@google.com>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
 <1356573611-18590-26-git-send-email-koverstreet@google.com>
 <20130125005136.GE2373@mtj.dyndns.org>
 <87libhpz4h.fsf@rustcorp.com.au>
 <20130128175304.GX26407@google.com>
 <20130128175951.GA22465@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130128175951.GA22465@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 09:59:51AM -0800, Tejun Heo wrote:
> Hello, Kent.
> 
> On Mon, Jan 28, 2013 at 09:53:04AM -0800, Kent Overstreet wrote:
> > > Like Tejun, I'd prefer to see it always alloc up-front, because it
> > > avoids the _noalloc variant (which is backwards: please hand gfp_t, so
> > > you don't hide the alloc) and heuristics.
> > 
> > Problem with gfp_t is alloc_percpu() doesn't take it. I don't know why,
> > but this all goes away with Tejun's idea for allocating from a pool
> > refilled by workqueue.
> 
> It goes down to how we allocate page tables.  percpu depends on
> vmalloc space allocation which in turn depends on page table
> allocation which unfortunately assumes GFP_KERNEL and is spread all
> across different architectures.  Adding @gfp to it came up a couple
> times but the cases weren't strong enough to push it all the way
> through.  There are some aspects that I like about forcing GFP_KERNEL
> on all percpu allocations but if there are strong enough cases and
> someone is willing enough to push it through, maybe.

Ahh, thanks for explaining, was curious about that.
