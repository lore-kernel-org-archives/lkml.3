Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab3C2Qm2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 12:42:28 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:43373 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928Ab3C2Qm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 12:42:27 -0400
Message-ID: <5155C466.9040406@gmail.com>
Date: Sat, 30 Mar 2013 00:42:14 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Howells <dhowells@redhat.com>, Mark Salter <msalter@redhat.com>,
        Jianguo Wu <wujianguo@huawei.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH v3, part4 38/39] mm/hotplug: prepare for removing num_physpages
References: <1364313298-17336-1-git-send-email-jiang.liu@huawei.com> <1364313298-17336-39-git-send-email-jiang.liu@huawei.com> <20130329111856.GA3824@merkur.ravnborg.org> <5155B517.3040501@gmail.com> <20130329161700.GA6201@merkur.ravnborg.org> <5155C196.5020909@gmail.com> <20130329164014.GA6266@merkur.ravnborg.org>
In-Reply-To: <20130329164014.GA6266@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2013 12:40 AM, Sam Ravnborg wrote:
> On Sat, Mar 30, 2013 at 12:30:14AM +0800, Jiang Liu wrote:
>> On 03/30/2013 12:17 AM, Sam Ravnborg wrote:
>>>>>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>>>>>> index 97454b3..9b1b494 100644
>>>>>> --- a/mm/memory_hotplug.c
>>>>>> +++ b/mm/memory_hotplug.c
>>>>>> @@ -751,10 +751,6 @@ EXPORT_SYMBOL_GPL(restore_online_page_callback);
>>>>>>  
>>>>>>  void __online_page_set_limits(struct page *page)
>>>>>>  {
>>>>>> -	unsigned long pfn = page_to_pfn(page);
>>>>>> -
>>>>>> -	if (pfn >= num_physpages)
>>>>>> -		num_physpages = pfn + 1;
>>>>>>  }
>>>>>>  EXPORT_SYMBOL_GPL(__online_page_set_limits);
>>>>>
>>>>> How can this be correct?
>>>>> With this change __online_page_set_limits() is now a nop.
>>>> Hi Sam,
>>>> 	We will eventually remove the global variable num_physpages in the last patch.
>>>> I kept the nop __online_page_set_limits() because I have a plan to use it to fix other
>>>> bugs in memory hotplug, otherwise it may be killed too.
>>>
>>> The xen ballon driver uses __online_page_set_limits for memory
>>> hotplug - so this will break this driver afaics.
>> Hi Sam,
>> 	I haven't gotten your point yet here. 
>> 	Function __online_page_set_limits() was only used to update the global variable
>> num_physpages, and one of the goals of this patch set is to get rid of num_physpages.
>> So I think it won't break Xen balloon driver.
>> 	Please refer to the patch here, which eventually kills num_physpages.
>> http://marc.info/?l=linux-mm&m=136431387813309&w=2
> 
> I assumed that num_physpages was used run-time to check for the
> available number of pages. And __online_page_set_limits() were used
> to reduced the number of online pages.
> 
> But a quick grep did not reveal any such use.
> 
> So it looks OK - thanks for the clarification.
Yeah, we have a patch to replace num_physpages with totalram_pages for runtime access,
please refer to:
http://marc.info/?l=linux-mm&m=136431351413052&w=2

> 
> 	Sam
> 

