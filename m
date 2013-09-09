Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab3IIGZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 02:25:49 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:40521 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab3IIGZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 02:25:48 -0400
Message-ID: <522D69D9.4020403@huawei.com>
Date: Mon, 9 Sep 2013 14:25:29 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        <kosaki.motohiro@gmail.com>
Subject: Re: [PATCH 1/2] mm/hotplug: rename the function is_memblock_offlined_cb()
References: <522D4038.7010609@huawei.com> <522D65F3.2030400@jp.fujitsu.com>
In-Reply-To: <522D65F3.2030400@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/9/9 14:08, Yasuaki Ishimatsu wrote:

> [CCing Kosaki since he maintains mm/memory_hotplug.c]
> 
> (2013/09/09 12:27), Xishi Qiu wrote:
>> Function is_memblock_offlined() return 1 means memory block is offlined,
>> but is_memblock_offlined_cb() return 1 means memory block is not offlined,
>> this will confuse somebody, so rename the function.
>>
> 
>> Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
>> Acked-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>> ---
> 
> I have not acked your previous patch yet. But this patch seems good to me.
> So I acked the patch.
> 

Sorry, I mistakenly thought "seems good to me" was the same as acked, I'll pay 
attention next time.

Thanks,
Xishi Qiu

> Thanks,
> Yasuaki Ishimatsu
> 
>>   mm/memory_hotplug.c |    4 ++--
>>   1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index ca1dd3a..85f80b7 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -1657,7 +1657,7 @@ int walk_memory_range(unsigned long start_pfn, unsigned long end_pfn,
>>   }
>>
>>   #ifdef CONFIG_MEMORY_HOTREMOVE
>> -static int is_memblock_offlined_cb(struct memory_block *mem, void *arg)
>> +static int check_memblock_offlined_cb(struct memory_block *mem, void *arg)
>>   {
>>       int ret = !is_memblock_offlined(mem);
>>
>> @@ -1794,7 +1794,7 @@ void __ref remove_memory(int nid, u64 start, u64 size)
>>        * if this is not the case.
>>        */
>>       ret = walk_memory_range(PFN_DOWN(start), PFN_UP(start + size - 1), NULL,
>> -                is_memblock_offlined_cb);
>> +                check_memblock_offlined_cb);
>>       if (ret) {
>>           unlock_memory_hotplug();
>>           BUG();
>>
> 
> 
> 
> 



