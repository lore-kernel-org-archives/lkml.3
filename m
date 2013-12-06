Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763Ab3LFBUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 20:20:08 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:6900 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab3LFBUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 20:20:03 -0500
Message-ID: <52A1260B.2050007@huawei.com>
Date: Fri, 6 Dec 2013 09:19:07 +0800
From: Jianguo Wu <wujianguo@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, qiuxishi <qiuxishi@huawei.com>
Subject: Re: [PATCH] mm: do_mincore() cleanup
References: <52A03EE4.6030609@huawei.com> <1386254370-ui1ehq60-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1386254370-ui1ehq60-mutt-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.216]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/12/5 22:39, Naoya Horiguchi wrote:

> On Thu, Dec 05, 2013 at 04:52:52PM +0800, Jianguo Wu wrote:
>> Two cleanups:
>> 1. remove redundant codes for hugetlb pages.
>> 2. end = pmd_addr_end(addr, end) restricts [addr, end) within PMD_SIZE,
>>    this may increase do_mincore() calls, remove it.
>>
>> Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
> 
> Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

Hi Naoya, thanks for your review!

Jianguo Wu

> 
> Thanks!
> 
> Naoya
> 
>> ---
>>  mm/mincore.c |    7 -------
>>  1 files changed, 0 insertions(+), 7 deletions(-)
>>
>> diff --git a/mm/mincore.c b/mm/mincore.c
>> index da2be56..1016233 100644
>> --- a/mm/mincore.c
>> +++ b/mm/mincore.c
>> @@ -225,13 +225,6 @@ static long do_mincore(unsigned long addr, unsigned long pages, unsigned char *v
>>  
>>  	end = min(vma->vm_end, addr + (pages << PAGE_SHIFT));
>>  
>> -	if (is_vm_hugetlb_page(vma)) {
>> -		mincore_hugetlb_page_range(vma, addr, end, vec);
>> -		return (end - addr) >> PAGE_SHIFT;
>> -	}
>> -
>> -	end = pmd_addr_end(addr, end);
>> -
>>  	if (is_vm_hugetlb_page(vma))
>>  		mincore_hugetlb_page_range(vma, addr, end, vec);
>>  	else
>> -- 
>> 1.7.1
>>
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo@kvack.org.  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>>
> 
> .
> 



