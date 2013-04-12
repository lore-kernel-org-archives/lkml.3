Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab3DLPWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 11:22:41 -0400
Received: from one.firstfloor.org ([193.170.194.197]:48149 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab3DLPWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 11:22:39 -0400
Date: Fri, 12 Apr 2013 17:22:37 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Hillf Danton <dhillf@gmail.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] mm/hugetlb: gigantic hugetlb page pools shrink
 supporting
Message-ID: <20130412152237.GM16732@two.firstfloor.org>
References: <1365066554-29195-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <20130411232907.GC29398@hacker.(null)>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130411232907.GC29398@hacker.(null)>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 07:29:07AM +0800, Wanpeng Li wrote:
> Ping Andi,
> On Thu, Apr 04, 2013 at 05:09:08PM +0800, Wanpeng Li wrote:
> >order >= MAX_ORDER pages are only allocated at boot stage using the 
> >bootmem allocator with the "hugepages=xxx" option. These pages are never 
> >free after boot by default since it would be a one-way street(>= MAX_ORDER
> >pages cannot be allocated later), but if administrator confirm not to 
> >use these gigantic pages any more, these pinned pages will waste memory
> >since other users can't grab free pages from gigantic hugetlb pool even
> >if OOM, it's not flexible.  The patchset add hugetlb gigantic page pools
> >shrink supporting. Administrator can enable knob exported in sysctl to
> >permit to shrink gigantic hugetlb pool.


I originally didn't allow this because it's only one way and it seemed
dubious.  I've been recently working on a new patchkit to allocate
GB pages from CMA. With that freeing actually makes sense, as 
the pages can be reallocated.

-Andi
