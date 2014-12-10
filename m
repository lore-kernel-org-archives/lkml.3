Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbaLJBkQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 20:40:16 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:32410 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbaLJBkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 20:40:14 -0500
Message-ID: <5487A471.30005@huawei.com>
Date: Wed, 10 Dec 2014 09:40:01 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>, <dave@sr71.net>,
        Rik van Riel <riel@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        <linux-tip-commits@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH V2] x86/mm: Fix zone ranges boot printout
References: <54866C18.1050203@huawei.com> <20141209145038.6253a2b99379bfb1255fa95e@linux-foundation.org>
In-Reply-To: <20141209145038.6253a2b99379bfb1255fa95e@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.25.179]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A010201.5487A479.0464,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 157f894069c51c7bb90ee27efb632ab1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/10 6:50, Andrew Morton wrote:

> On Tue, 9 Dec 2014 11:27:20 +0800 Xishi Qiu <qiuxishi@huawei.com> wrote:
> 
>> Changelog:
>> V2:
>> 	-fix building warnings of min(...).
>>
>> ...
>>
>> --- a/arch/x86/mm/init.c
>> +++ b/arch/x86/mm/init.c
>> @@ -674,10 +674,12 @@ void __init zone_sizes_init(void)
>>  	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
>>  
>>  #ifdef CONFIG_ZONE_DMA
>> -	max_zone_pfns[ZONE_DMA]		= MAX_DMA_PFN;
>> +	max_zone_pfns[ZONE_DMA]		= min_t(unsigned long,
>> +						max_low_pfn, MAX_DMA_PFN);
> 
> MAX_DMA_PFN has type int.
> 
>>  #endif
>>  #ifdef CONFIG_ZONE_DMA32
>> -	max_zone_pfns[ZONE_DMA32]	= MAX_DMA32_PFN;
>> +	max_zone_pfns[ZONE_DMA32]	= min_t(unsigned long,
>> +						max_low_pfn, MAX_DMA32_PFN);
> 
> MAX_DMA32_PFN has type UL (I think?) so there's no need for min_t here.
> 
>>  #endif
>>  	max_zone_pfns[ZONE_NORMAL]	= max_low_pfn;
>>  #ifdef CONFIG_HIGHMEM
> 
> 
> Let's try to get the types correct, rather than hacking around fixing
> up fallout from earlier incorrect type choices?
> 
> What is the type of a pfn?  Unsigned long, generally, when we bother
> thinking about it.
> 
> So how about we make MAX_DMA_PFN have type UL?  I assume that fixes the
> warning?
> 
> If we do this, we should also be able to undo the min_t hackery in
> arch/x86/kernel/e820.c:memblock_find_dma_reserve().
> 

Hi Andrew,

Thanks for your suggestion, I'll resend V3.

Thanks,
Xishi Qiu

> 
> .
> 



