Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaBKCyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 21:54:24 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:49592 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbaBKCyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 21:54:22 -0500
Date: Mon, 10 Feb 2014 18:54:20 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Luiz Capitulino <lcapitulino@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, mtosatti@redhat.com,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 0/4] hugetlb: add hugepagesnid= command-line option
In-Reply-To: <1392053268-29239-1-git-send-email-lcapitulino@redhat.com>
Message-ID: <alpine.DEB.2.02.1402101851190.3447@chino.kir.corp.google.com>
References: <1392053268-29239-1-git-send-email-lcapitulino@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Feb 2014, Luiz Capitulino wrote:

> HugeTLB command-line option hugepages= allows the user to specify how many
> huge pages should be allocated at boot. On NUMA systems, this argument
> automatically distributes huge pages allocation among nodes, which can
> be undesirable.
> 

And when hugepages can no longer be allocated on a node because it is too 
small, the remaining hugepages are distributed over nodes with memory 
available, correct?

> The hugepagesnid= option introduced by this commit allows the user
> to specify which NUMA nodes should be used to allocate boot-time HugeTLB
> pages. For example, hugepagesnid=0,2,2G will allocate two 2G huge pages
> from node 0 only. More details on patch 3/4 and patch 4/4.
> 

Strange, it would seem better to just reserve as many hugepages as you 
want so that you get the desired number on each node and then free the 
ones you don't need at runtime.

That probably doesn't work because we can't free very large hugepages that 
are reserved at boot, would fixing that issue reduce the need for this 
patchset?
