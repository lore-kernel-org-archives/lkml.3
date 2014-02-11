Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbaBKPgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 10:36:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614AbaBKPgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 10:36:45 -0500
Date: Tue, 11 Feb 2014 10:36:24 -0500
From: Luiz Capitulino <lcapitulino@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, mtosatti@redhat.com,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 0/4] hugetlb: add hugepagesnid= command-line option
Message-ID: <20140211103624.7edf1423@redhat.com>
In-Reply-To: <alpine.DEB.2.02.1402101851190.3447@chino.kir.corp.google.com>
References: <1392053268-29239-1-git-send-email-lcapitulino@redhat.com>
	<alpine.DEB.2.02.1402101851190.3447@chino.kir.corp.google.com>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Feb 2014 18:54:20 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

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

No. hugepagesnid= tries to obey what was specified by the uses as much as
possible. So, if you specify that 10 1G huge pages should be allocated from
node0 but only 7 1G pages can actually be allocated, then hugepagesnid= will
do just that.

> > The hugepagesnid= option introduced by this commit allows the user
> > to specify which NUMA nodes should be used to allocate boot-time HugeTLB
> > pages. For example, hugepagesnid=0,2,2G will allocate two 2G huge pages
> > from node 0 only. More details on patch 3/4 and patch 4/4.
> > 
> 
> Strange, it would seem better to just reserve as many hugepages as you 
> want so that you get the desired number on each node and then free the 
> ones you don't need at runtime.

You mean, for example, if I have a 2 node system and want 2 1G huge pages
from node 1, then I have to allocate 4 1G huge pages and then free 2 pages
on node 0 after boot? That seems very cumbersome to me. Besides, what if
node0 needs this memory during boot?

> That probably doesn't work because we can't free very large hugepages that 
> are reserved at boot, would fixing that issue reduce the need for this 
> patchset?

I don't think so.
