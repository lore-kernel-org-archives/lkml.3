Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaBKP1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 10:27:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875AbaBKP1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 10:27:19 -0500
Date: Tue, 11 Feb 2014 13:26:29 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>,
        Luiz Capitulino <lcapitulino@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 0/4] hugetlb: add hugepagesnid= command-line option
Message-ID: <20140211152629.GA28210@amt.cnet>
References: <1392053268-29239-1-git-send-email-lcapitulino@redhat.com>
 <alpine.DEB.2.02.1402101851190.3447@chino.kir.corp.google.com>
 <20140211092514.GH6732@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140211092514.GH6732@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 09:25:14AM +0000, Mel Gorman wrote:
> On Mon, Feb 10, 2014 at 06:54:20PM -0800, David Rientjes wrote:
> > On Mon, 10 Feb 2014, Luiz Capitulino wrote:
> > 
> > > HugeTLB command-line option hugepages= allows the user to specify how many
> > > huge pages should be allocated at boot. On NUMA systems, this argument
> > > automatically distributes huge pages allocation among nodes, which can
> > > be undesirable.
> > > 
> > 
> > And when hugepages can no longer be allocated on a node because it is too 
> > small, the remaining hugepages are distributed over nodes with memory 
> > available, correct?
> > 
> > > The hugepagesnid= option introduced by this commit allows the user
> > > to specify which NUMA nodes should be used to allocate boot-time HugeTLB
> > > pages. For example, hugepagesnid=0,2,2G will allocate two 2G huge pages
> > > from node 0 only. More details on patch 3/4 and patch 4/4.
> > > 
> > 
> > Strange, it would seem better to just reserve as many hugepages as you 
> > want so that you get the desired number on each node and then free the 
> > ones you don't need at runtime.

You have to know the behaviour of the allocator, and rely on that 
to allocate the exact number of 1G hugepages on a particular node.

Is that desired in constrast with specifying the exact number, and
location, of hugepages to allocated?

> Or take a stab at allocating 1G pages at runtime. It would require
> finding properly aligned 1Gs worth of contiguous MAX_ORDER_NR_PAGES at
> runtime. I would expect it would only work very early in the lifetime of
> the system but if the user is willing to use kernel parameters to
> allocate them then it should not be an issue.

Can be an improvement on top of the current patchset? Certain use-cases
require allocation guarantees (even if that requires kernel parameters).

