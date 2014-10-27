Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbaJ0MN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 08:13:59 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:56891 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaJ0MN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 08:13:57 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-1d-544e3704055e
Message-id: <544E3702.8060508@samsung.com>
Date: Mon, 27 Oct 2014 13:13:54 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>,
        Weijie Yang <weijie.yang@samsung.com>
Cc: iamjoonsoo.kim@lge.com, aneesh.kumar@linux.vnet.ibm.com,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Linux-MM'" <linux-mm@kvack.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Weijie Yang'" <weijie.yang.kh@gmail.com>
Subject: Re: [PATCH] mm, cma: make parameters order consistent in func
 declaration and definition
References: <000201cfef6f$c5422b10$4fc68130$%yang@samsung.com>
 <xa1td29h2zlo.fsf@mina86.com>
In-reply-to: <xa1td29h2zlo.fsf@mina86.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t/xK7os5n4hBvMWcljMWb+GzeLx63ks
	Fiu7m9ksLu+aw2Zxb81/VosFx1tYLZ6c+M9icXLDWVYHDo+ds+6ye2z6NIndo+vtFSaPEzN+
	s3g8OLSZxWPdn1dMHn1bVjF6fN4kF8ARxWWTkpqTWZZapG+XwJUx+fEEpoIPfBXP9mk0ME7k
	6WLk4JAQMJF48DOqi5ETyBSTuHBvPVsXIxeHkMBSRolJnX8ZIZxPjBJLG5eygFTxCmhJzOza
	zwbSzCKgKnHqkxFImE3AUKLrbRcbiC0qECNxf+dqNohyQYkfk++BtYoIBEh8XNoCNpNZ4AWj
	xNePW1hB5ggLJEssu60CYgoJxEm8+1IIUs4JtGn7wxNMIDazgJnEl5eHWSFseYnNa94yT2AU
	mIVkwywkZbOQlC1gZF7FKJpamlxQnJSea6hXnJhbXJqXrpecn7uJERIHX3YwLj5mdYhRgINR
	iYd3xzTfECHWxLLiytxDjBIczEoivI4/gUK8KYmVValF+fFFpTmpxYcYmTg4pRoYu/W+VeS/
	PR4iWnw34Gu+aqf3+XePr/Sbq7G4NMtyLT0dp1Rxn/XS7PDvPVUs8+Pcl2fKG1w4lmMay/en
	XLfgoFfHvjs+F2aUsh/5MD/t8J/5USvXff5/hHOzoqB/6InklyesOLZ+Pft9b/beus6/6wsP
	/uzmkpLcuERb+HS7zvb9G223Sjm6K7EUZyQaajEXFScCAPIURy9hAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-10-24 18:37, Michal Nazarewicz wrote:
> On Fri, Oct 24 2014, Weijie Yang <weijie.yang@samsung.com> wrote:
>> In the current code, the base and size parameters order is not consistent
>> in functions declaration and definition. If someone calls these functions
>> according to the declaration parameters order in cma.h, he will run into
>> some bug and it's hard to find the reason.
>>
>> This patch makes the parameters order consistent in functions declaration
>> and definition.
>>
>> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
> Acked-by: Michal Nazarewicz <mina86@mina86.com>

Applied to my fixes-for-v3.18 branch.

>> ---
>>   include/linux/cma.h |    8 ++++----
>>   1 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/linux/cma.h b/include/linux/cma.h
>> index 0430ed0..a93438b 100644
>> --- a/include/linux/cma.h
>> +++ b/include/linux/cma.h
>> @@ -18,12 +18,12 @@ struct cma;
>>   extern phys_addr_t cma_get_base(struct cma *cma);
>>   extern unsigned long cma_get_size(struct cma *cma);
>>   
>> -extern int __init cma_declare_contiguous(phys_addr_t size,
>> -			phys_addr_t base, phys_addr_t limit,
>> +extern int __init cma_declare_contiguous(phys_addr_t base,
>> +			phys_addr_t size, phys_addr_t limit,
>>   			phys_addr_t alignment, unsigned int order_per_bit,
>>   			bool fixed, struct cma **res_cma);
>> -extern int cma_init_reserved_mem(phys_addr_t size,
>> -					phys_addr_t base, int order_per_bit,
>> +extern int cma_init_reserved_mem(phys_addr_t base,
>> +					phys_addr_t size, int order_per_bit,
>>   					struct cma **res_cma);
>>   extern struct page *cma_alloc(struct cma *cma, int count, unsigned int align);
>>   extern bool cma_release(struct cma *cma, struct page *pages, int count);
>> -- 
>> 1.7.0.4

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

