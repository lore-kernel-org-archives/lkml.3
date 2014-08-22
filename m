Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbaHVBgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 21:36:22 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:33279 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755514AbaHVBgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 21:36:21 -0400
X-IronPort-AV: E=Sophos;i="5.04,377,1406563200"; 
   d="scan'208";a="34922644"
Message-ID: <53F69E26.1090408@cn.fujitsu.com>
Date: Fri, 22 Aug 2014 09:34:30 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131030 Thunderbird/17.0.10
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>
CC: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Hillf Danton <dhillf@gmail.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] mm/hugetlb: gigantic hugetlb page pools shrink supporting
References: <1365066554-29195-1-git-send-email-liwanp@linux.vnet.ibm.com> <20130411232907.GC29398@hacker.(null)> <20130412152237.GM16732@two.firstfloor.org> <20140821233729.GB2420@kernel>
In-Reply-To: <20140821233729.GB2420@kernel>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.225.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Wanpeng

On 08/22/2014 07:37 AM, Wanpeng Li wrote:
> Hi Andi,
> On Fri, Apr 12, 2013 at 05:22:37PM +0200, Andi Kleen wrote:
>> On Fri, Apr 12, 2013 at 07:29:07AM +0800, Wanpeng Li wrote:
>>> Ping Andi,
>>> On Thu, Apr 04, 2013 at 05:09:08PM +0800, Wanpeng Li wrote:
>>>> order >= MAX_ORDER pages are only allocated at boot stage using the 
>>>> bootmem allocator with the "hugepages=xxx" option. These pages are never 
>>>> free after boot by default since it would be a one-way street(>= MAX_ORDER
>>>> pages cannot be allocated later), but if administrator confirm not to 
>>>> use these gigantic pages any more, these pinned pages will waste memory
>>>> since other users can't grab free pages from gigantic hugetlb pool even
>>>> if OOM, it's not flexible.  The patchset add hugetlb gigantic page pools
>>>> shrink supporting. Administrator can enable knob exported in sysctl to
>>>> permit to shrink gigantic hugetlb pool.
>>
>>
>> I originally didn't allow this because it's only one way and it seemed
>> dubious.  I've been recently working on a new patchkit to allocate
>> GB pages from CMA. With that freeing actually makes sense, as 
>> the pages can be reallocated.
>>
> 
> More than one year past, If your allocate GB pages from CMA merged? 

commit 944d9fec8d7aee3f2e16573e9b6a16634b33f403
Author: Luiz Capitulino <lcapitulino@redhat.com>
Date:   Wed Jun 4 16:07:13 2014 -0700

    hugetlb: add support for gigantic page allocation at runtime


> 
> Regards,
> Wanpeng Li 
> 
>> -Andi
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo@kvack.org.  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> .
> 


-- 
Thanks.
Zhang Yanfei
