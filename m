Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933726AbaFQUox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 16:44:53 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:58011 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933275AbaFQUow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 16:44:52 -0400
Date: Tue, 17 Jun 2014 16:44:48 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH RFC] percpu: add data dependency barrier in percpu
 accessors and operations
Message-ID: <20140617204448.GQ31819@htj.dyndns.org>
References: <20140612135630.GA23606@htj.dyndns.org>
 <20140612153426.GV4581@linux.vnet.ibm.com>
 <20140612155227.GB23606@htj.dyndns.org>
 <20140617144151.GD4669@linux.vnet.ibm.com>
 <20140617152752.GC31819@htj.dyndns.org>
 <20140617165702.GF4669@linux.vnet.ibm.com>
 <20140617185605.GL31819@htj.dyndns.org>
 <alpine.DEB.2.11.1406171440050.22064@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1406171440050.22064@gentwo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Christoph.

On Tue, Jun 17, 2014 at 02:42:48PM -0500, Christoph Lameter wrote:
> > > I much prefer the model where the thing that -published- the pointer is
> > > responsible for memory ordering.  After all, if a task allocates some
> > > zeroed memory, uses it locally, then frees it, there is no ordering
> > > to worry about in the first place.  The memory allocator doing the
> > > initialization cannot tell how the memory is to be used, after all.
> >
> > Yeah, "publish" is a nice verb to put on it.  No objection.
> 
> Well that "publishing" of the structure that contains the per cpu offset
> is actually what most of the current code does. So we do not need any
> additional synchronization. Clarifying the responsibility for
> synchronization being with the code which does the alloc_percpu would be
> good.

Sure, we can declare that it follows the same rules as normal memory
allocations - that is, the zeroing belongs to the allocating cpu and
propagation is fully the responsbility of users including data dep
barrier when necessary.

It seems a lot more confusing to me than normal memory allocations
mostly because the ownership isn't immediately clear; however, it
could be that we just need to clarify.

I'll think more about it.

Thanks.

-- 
tejun
