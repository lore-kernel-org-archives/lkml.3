Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbaHUXgC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 19:36:02 -0400
Received: from mga02.intel.com ([134.134.136.20]:14944 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449AbaHUXgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 19:36:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,376,1406617200"; 
   d="scan'208";a="561883074"
Date: Fri, 22 Aug 2014 07:37:29 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@linux.intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Hillf Danton <dhillf@gmail.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] mm/hugetlb: gigantic hugetlb page pools shrink
 supporting
Message-ID: <20140821233729.GB2420@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1365066554-29195-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <20130411232907.GC29398@hacker.(null)>
 <20130412152237.GM16732@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130412152237.GM16732@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,
On Fri, Apr 12, 2013 at 05:22:37PM +0200, Andi Kleen wrote:
>On Fri, Apr 12, 2013 at 07:29:07AM +0800, Wanpeng Li wrote:
>> Ping Andi,
>> On Thu, Apr 04, 2013 at 05:09:08PM +0800, Wanpeng Li wrote:
>> >order >= MAX_ORDER pages are only allocated at boot stage using the 
>> >bootmem allocator with the "hugepages=xxx" option. These pages are never 
>> >free after boot by default since it would be a one-way street(>= MAX_ORDER
>> >pages cannot be allocated later), but if administrator confirm not to 
>> >use these gigantic pages any more, these pinned pages will waste memory
>> >since other users can't grab free pages from gigantic hugetlb pool even
>> >if OOM, it's not flexible.  The patchset add hugetlb gigantic page pools
>> >shrink supporting. Administrator can enable knob exported in sysctl to
>> >permit to shrink gigantic hugetlb pool.
>
>
>I originally didn't allow this because it's only one way and it seemed
>dubious.  I've been recently working on a new patchkit to allocate
>GB pages from CMA. With that freeing actually makes sense, as 
>the pages can be reallocated.
>

More than one year past, If your allocate GB pages from CMA merged? 

Regards,
Wanpeng Li 

>-Andi
>
>--
>To unsubscribe, send a message with 'unsubscribe linux-mm' in
>the body to majordomo@kvack.org.  For more info on Linux MM,
>see: http://www.linux-mm.org/ .
>Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
