Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab3E0Gm3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 02:42:29 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:58619 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756499Ab3E0Gm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 02:42:27 -0400
Message-ID: <51A30052.5090206@gmail.com>
Date: Mon, 27 May 2013 02:42:26 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3 1/6] mm/memory-hotplug: fix lowmem count overflow when
 offline pages
References: <1369547921-24264-1-git-send-email-liwanp@linux.vnet.ibm.com> <CAHGf_=rOLAYrpkLQiM53jn-bHAuxw=rRZP0+pNV-8EUinJzP7w@mail.gmail.com> <51a2a2ab.a2f6420a.33bb.ffffda23SMTPIN_ADDED_BROKEN@mx.google.com>
In-Reply-To: <51a2a2ab.a2f6420a.33bb.ffffda23SMTPIN_ADDED_BROKEN@mx.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(5/26/13 8:02 PM), Wanpeng Li wrote:
> On Sun, May 26, 2013 at 07:49:33AM -0400, KOSAKI Motohiro wrote:
>> On Sun, May 26, 2013 at 1:58 AM, Wanpeng Li <liwanp@linux.vnet.ibm.com> wrote:
>>> Changelog:
>>>  v1 -> v2:
>>>         * show number of HighTotal before hotremove
>>>         * remove CONFIG_HIGHMEM
>>>         * cc stable kernels
>>>         * add Michal reviewed-by
>>>
>>> Logic memory-remove code fails to correctly account the Total High Memory
>>> when a memory block which contains High Memory is offlined as shown in the
>>> example below. The following patch fixes it.
>>>
>>> Stable for 2.6.24+.
>>>
>>> Before logic memory remove:
>>>
>>> MemTotal:        7603740 kB
>>> MemFree:         6329612 kB
>>> Buffers:           94352 kB
>>> Cached:           872008 kB
>>> SwapCached:            0 kB
>>> Active:           626932 kB
>>> Inactive:         519216 kB
>>> Active(anon):     180776 kB
>>> Inactive(anon):   222944 kB
>>> Active(file):     446156 kB
>>> Inactive(file):   296272 kB
>>> Unevictable:           0 kB
>>> Mlocked:               0 kB
>>> HighTotal:       7294672 kB
>>> HighFree:        5704696 kB
>>> LowTotal:         309068 kB
>>> LowFree:          624916 kB
>>>
>>> After logic memory remove:
>>>
>>> MemTotal:        7079452 kB
>>> MemFree:         5805976 kB
>>> Buffers:           94372 kB
>>> Cached:           872000 kB
>>> SwapCached:            0 kB
>>> Active:           626936 kB
>>> Inactive:         519236 kB
>>> Active(anon):     180780 kB
>>> Inactive(anon):   222944 kB
>>> Active(file):     446156 kB
>>> Inactive(file):   296292 kB
>>> Unevictable:           0 kB
>>> Mlocked:               0 kB
>>> HighTotal:       7294672 kB
>>> HighFree:        5181024 kB
>>> LowTotal:       4294752076 kB
>>> LowFree:          624952 kB
>>>
>>> Reviewed-by: Michal Hocko <mhocko@suse.cz>
>>> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
>>> ---
>>>  mm/page_alloc.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>> index 98cbdf6..23b921f 100644
>>> --- a/mm/page_alloc.c
>>> +++ b/mm/page_alloc.c
>>> @@ -6140,6 +6140,8 @@ __offline_isolated_pages(unsigned long start_pfn, unsigned long end_pfn)
>>>                 list_del(&page->lru);
>>>                 rmv_page_order(page);
>>>                 zone->free_area[order].nr_free--;
>>> +               if (PageHighMem(page))
>>> +                       totalhigh_pages -= 1 << order;
>>>                 for (i = 0; i < (1 << order); i++)
>>>                         SetPageReserved((page+i));
>>>                 pfn += (1 << order);
>>
>> Hm. I already NAKed and you didn't answered my question. isn't it?
> 
> Jiang makes his effort to support highmem for memory hotremove, he also
> fix this bug, http://marc.info/?l=linux-mm&m=136957578620221&w=2

OK, go ahead.





