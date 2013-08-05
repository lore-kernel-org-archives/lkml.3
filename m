Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab3HEJFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 05:05:43 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:25843 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486Ab3HEJFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 05:05:42 -0400
Message-ID: <51FF6ADE.8060306@huawei.com>
Date: Mon, 5 Aug 2013 17:05:34 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] cma: use macro PFN_DOWN when converting size to pages
References: <51FF62C4.9010001@huawei.com> <20130805085404.GA22170@kroah.com>
In-Reply-To: <20130805085404.GA22170@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/8/5 16:54, Greg Kroah-Hartman wrote:

> On Mon, Aug 05, 2013 at 04:31:00PM +0800, Xishi Qiu wrote:
>> Use "PFN_DOWN(r->size)" instead of "r->size >> PAGE_SHIFT".
>>
>> Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
>> ---
>>  drivers/base/dma-contiguous.c |    5 ++---
>>  1 files changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
>> index 0ca5442..1bcfaed 100644
>> --- a/drivers/base/dma-contiguous.c
>> +++ b/drivers/base/dma-contiguous.c
>> @@ -201,13 +201,12 @@ static int __init cma_init_reserved_areas(void)
>>  {
>>  	struct cma_reserved *r = cma_reserved;
>>  	unsigned i = cma_reserved_count;
>> +	struct cma *cma;
> 
> Why change this?
> 
>>  
>>  	pr_debug("%s()\n", __func__);
>>  
>>  	for (; i; --i, ++r) {
>> -		struct cma *cma;
>> -		cma = cma_create_area(PFN_DOWN(r->start),
>> -				      r->size >> PAGE_SHIFT);
>> +		cma = cma_create_area(PFN_DOWN(r->start), PFN_DOWN(r->size));
> 
> That's reasonable to clean up, but nothing major.  Care to resend this
> without the cma change?
> 

Thank you and I will resend it soon.

Thanks,
Xishi Qiu

> thanks,
> 
> greg k-h
> 


