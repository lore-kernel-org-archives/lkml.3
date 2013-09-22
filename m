Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539Ab3IVAzM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 20:55:12 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:47636 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab3IVAzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 20:55:10 -0400
Message-ID: <523E3FC6.7020009@huawei.com>
Date: Sun, 22 Sep 2013 08:54:30 +0800
From: Jianguo Wu <wujianguo@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Petr Holasek <pholasek@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/ksm: return NULL when doesn't get mergeable page
References: <5236FC88.6050409@huawei.com> <20130919083329.GA1620@thinkpad-work.brq.redhat.com>
In-Reply-To: <20130919083329.GA1620@thinkpad-work.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.216]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/9/19 16:33, Petr Holasek wrote:

> On Mon, 16 Sep 2013, Jianguo Wu wrote:
>> In get_mergeable_page() local variable page is not initialized,
>> it may hold a garbage value, when find_mergeable_vma() return NULL,
>> get_mergeable_page() may return a garbage value to the caller.
>>
>> So initialize page as NULL.
>>
>> Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
>> ---
>>  mm/ksm.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/mm/ksm.c b/mm/ksm.c
>> index b6afe0c..87efbae 100644
>> --- a/mm/ksm.c
>> +++ b/mm/ksm.c
>> @@ -460,7 +460,7 @@ static struct page *get_mergeable_page(struct rmap_item *rmap_item)
>>  	struct mm_struct *mm = rmap_item->mm;
>>  	unsigned long addr = rmap_item->address;
>>  	struct vm_area_struct *vma;
>> -	struct page *page;
>> +	struct page *page = NULL;
>>  
>>  	down_read(&mm->mmap_sem);
>>  	vma = find_mergeable_vma(mm, addr);
>> -- 
>> 1.7.1
>>
> 
> When find_mergeable_vma returned NULL, NULL is assigned to page in "out"
> statement.
> 

Oh, yes, thanks, Petr.

> 



