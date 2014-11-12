Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934605AbaKLDmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:42:42 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:44002 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932588AbaKLDml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 22:42:41 -0500
Message-ID: <5462D71C.4070600@huawei.com>
Date: Wed, 12 Nov 2014 11:42:20 +0800
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Linux MM <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <wangnan0@huawei.com>
Subject: Re: [PATCH] memory-hotplug: remove redundant call of page_to_pfn
References: <1415697184-26409-1-git-send-email-zhenzhang.zhang@huawei.com> <5461D343.60803@huawei.com> <5462D0F5.1050008@jp.fujitsu.com>
In-Reply-To: <5462D0F5.1050008@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.77]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/12 11:16, Yasuaki Ishimatsu wrote:
> (2014/11/11 18:13), Zhang Zhen wrote:
>> The start_pfn can be obtained directly by
>> phys_index << PFN_SECTION_SHIFT.
>>
>> Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
>> ---
> 
> The patch looks good to me but I want you to write a purpose of the patch
> to the description for other reviewer.
> 
> Thanks,
> Yasuaki Ishimatsu
> 

Ok, thanks for your review.

>>   drivers/base/memory.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
>> index 7c5d871..85be040 100644
>> --- a/drivers/base/memory.c
>> +++ b/drivers/base/memory.c
>> @@ -228,8 +228,8 @@ memory_block_action(unsigned long phys_index, unsigned long action, int online_t
>>       struct page *first_page;
>>       int ret;
>>
>> -    first_page = pfn_to_page(phys_index << PFN_SECTION_SHIFT);
>> -    start_pfn = page_to_pfn(first_page);
>> +    start_pfn = phys_index << PFN_SECTION_SHIFT;
>> +    first_page = pfn_to_page(start_pfn);
>>
>>       switch (action) {
>>           case MEM_ONLINE:
>>
> 
> 
> 
> 


