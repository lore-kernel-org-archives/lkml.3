Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab3HOFRj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 01:17:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:27203 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751851Ab3HOFRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 01:17:37 -0400
X-IronPort-AV: E=Sophos;i="4.89,882,1367942400"; 
   d="scan'208";a="8207199"
Message-ID: <520C63F7.1080505@cn.fujitsu.com>
Date: Thu, 15 Aug 2013 13:15:35 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: robert.moore@intel.com, lv.zheng@intel.com, rjw@sisk.pl, lenb@kernel.org,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH part5 5/7] memblock, mem_hotplug: Make memblock skip hotpluggable
 regions by default.
References: <1375956979-31877-1-git-send-email-tangchen@cn.fujitsu.com> <1375956979-31877-6-git-send-email-tangchen@cn.fujitsu.com> <1376517265-8yi1139t-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1376517265-8yi1139t-mutt-n-horiguchi@ah.jp.nec.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/15 13:15:20,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/15 13:15:25,
	Serialize complete at 2013/08/15 13:15:25
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2013 05:54 AM, Naoya Horiguchi wrote:
> On Thu, Aug 08, 2013 at 06:16:17PM +0800, Tang Chen wrote:
>> --- a/mm/memblock.c
>> +++ b/mm/memblock.c
> ...
>> @@ -719,6 +723,10 @@ void __init_memblock __next_free_mem_range_rev(u64 *idx, int nid,
>>   		if (nid != MAX_NUMNODES&&  nid != memblock_get_region_node(m))
>>   			continue;
>>
>> +		/* skip hotpluggable memory regions */
>> +		if (m->flags&  MEMBLOCK_HOTPLUG)
>> +			continue;
>> +
>>   		/* scan areas before each reservation for intersection */
>>   		for ( ; ri>= 0; ri--) {
>>   			struct memblock_region *r =&rsv->regions[ri];
>> -- 
> 
> Why don't you add this also in __next_free_mem_range()?

Hi Naoya,

__next_free_mem_range_rev() is for for_each_free_mem_range_reverse(),
which is
only called in memblock_find_in_range_node().

But I think __next_free_mem_range() is for for_each_free_mem_range,
which is
called by many others. These callers could has nothing to do with memory
hotplug.
So I didn't add.

Maybe adding the check here is not good. I'm trying to find somewhere to
check MEMBLOCK_HOTPLUG.

Thanks. :)
