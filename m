Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857Ab3EZBoG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 21:44:06 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:33631 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758789Ab3EZBoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 21:44:04 -0400
Message-ID: <51A168E0.3020305@gmail.com>
Date: Sat, 25 May 2013 21:44:00 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Tang Chen <tangchen@cn.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH v2 1/4] mm/memory-hotplug: fix lowmem count overflow when
 offline pages
References: <1369298568-20094-1-git-send-email-liwanp@linux.vnet.ibm.com> <51A16268.4000401@gmail.com> <51a1642b.077c320a.3884.161cSMTPIN_ADDED_BROKEN@mx.google.com>
In-Reply-To: <51a1642b.077c320a.3884.161cSMTPIN_ADDED_BROKEN@mx.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(5/25/13 9:23 PM), Wanpeng Li wrote:
> Hi KOSAKI,
> On Sat, May 25, 2013 at 09:16:24PM -0400, KOSAKI Motohiro wrote:
>>> ---
>>>  mm/page_alloc.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>> index 98cbdf6..23b921f 100644
>>> --- a/mm/page_alloc.c
>>> +++ b/mm/page_alloc.c
>>> @@ -6140,6 +6140,8 @@ __offline_isolated_pages(unsigned long start_pfn, unsigned long end_pfn)
>>>  		list_del(&page->lru);
>>>  		rmv_page_order(page);
>>>  		zone->free_area[order].nr_free--;
>>> +		if (PageHighMem(page))
>>> +			totalhigh_pages -= 1 << order;
>>>  		for (i = 0; i < (1 << order); i++)
>>>  			SetPageReserved((page+i));
>>>  		pfn += (1 << order);
>>
>> memory hotplug don't support 32bit since it was born, at least, when the system has highmem. 
>> Why can't we disable memory hotremove when 32bit at compile time?
> 
> Here is logic memory remove instead of ACPI based memory remove. ;-)

I know.

