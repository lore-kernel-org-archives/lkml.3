Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415AbaBKJZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 04:25:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38010 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbaBKJZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 04:25:21 -0500
Date: Tue, 11 Feb 2014 09:25:14 +0000
From: Mel Gorman <mgorman@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Luiz Capitulino <lcapitulino@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, mtosatti@redhat.com,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 0/4] hugetlb: add hugepagesnid= command-line option
Message-ID: <20140211092514.GH6732@suse.de>
References: <1392053268-29239-1-git-send-email-lcapitulino@redhat.com>
 <alpine.DEB.2.02.1402101851190.3447@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402101851190.3447@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 06:54:20PM -0800, David Rientjes wrote:
> On Mon, 10 Feb 2014, Luiz Capitulino wrote:
> 
> > HugeTLB command-line option hugepages= allows the user to specify how many
> > huge pages should be allocated at boot. On NUMA systems, this argument
> > automatically distributes huge pages allocation among nodes, which can
> > be undesirable.
> > 
> 
> And when hugepages can no longer be allocated on a node because it is too 
> small, the remaining hugepages are distributed over nodes with memory 
> available, correct?
> 
> > The hugepagesnid= option introduced by this commit allows the user
> > to specify which NUMA nodes should be used to allocate boot-time HugeTLB
> > pages. For example, hugepagesnid=0,2,2G will allocate two 2G huge pages
> > from node 0 only. More details on patch 3/4 and patch 4/4.
> > 
> 
> Strange, it would seem better to just reserve as many hugepages as you 
> want so that you get the desired number on each node and then free the 
> ones you don't need at runtime.
> 

Or take a stab at allocating 1G pages at runtime. It would require
finding properly aligned 1Gs worth of contiguous MAX_ORDER_NR_PAGES at
runtime. I would expect it would only work very early in the lifetime of
the system but if the user is willing to use kernel parameters to
allocate them then it should not be an issue.

-- 
Mel Gorman
SUSE Labs
