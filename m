Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab3C2PhL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 11:37:11 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:38478 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755910Ab3C2PhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 11:37:09 -0400
Message-ID: <5155B517.3040501@gmail.com>
Date: Fri, 29 Mar 2013 23:36:55 +0800
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
References: <1364313298-17336-1-git-send-email-jiang.liu@huawei.com> <1364313298-17336-39-git-send-email-jiang.liu@huawei.com> <20130329111856.GA3824@merkur.ravnborg.org>
In-Reply-To: <20130329111856.GA3824@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2013 07:18 PM, Sam Ravnborg wrote:
> On Tue, Mar 26, 2013 at 11:54:57PM +0800, Jiang Liu wrote:
>> Prepare for removing num_physpages.
>>
>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>> Cc: Wen Congyang <wency@cn.fujitsu.com>
>> Cc: Tang Chen <tangchen@cn.fujitsu.com>
>> Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>> Cc: linux-mm@kvack.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>> Hi all,
>> 	Sorry for my mistake that my previous patch series has been screwed up.
>> So I regenerate a third version and also set up a git tree at:
>> 	git://github.com/jiangliu/linux.git mem_init
>> 	Any help to review and test are welcomed!
>>
>> 	Regards!
>> 	Gerry
>> ---
>>  mm/memory_hotplug.c |    4 ----
>>  1 file changed, 4 deletions(-)
>>
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index 97454b3..9b1b494 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -751,10 +751,6 @@ EXPORT_SYMBOL_GPL(restore_online_page_callback);
>>  
>>  void __online_page_set_limits(struct page *page)
>>  {
>> -	unsigned long pfn = page_to_pfn(page);
>> -
>> -	if (pfn >= num_physpages)
>> -		num_physpages = pfn + 1;
>>  }
>>  EXPORT_SYMBOL_GPL(__online_page_set_limits);
> 
> How can this be correct?
> With this change __online_page_set_limits() is now a nop.
Hi Sam,
	We will eventually remove the global variable num_physpages in the last patch.
I kept the nop __online_page_set_limits() because I have a plan to use it to fix other
bugs in memory hotplug, otherwise it may be killed too.
	Regards!
	Gerry

> 
> 	Sam
> 

