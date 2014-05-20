Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347AbaETXZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 19:25:57 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:42836 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbaETXZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 19:25:56 -0400
X-Original-SENDERIP: 10.178.33.69
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <537BE481.2040702@lge.com>
Date: Wed, 21 May 2014 08:25:53 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, gunho.lee@lge.com
Subject: Re: [PATCH] Documentation/DMA-API-HOWTO.txt: update API descriptions
References: <1399895153-29451-1-git-send-email-gioh.kim@lge.com> <20140520231940.GA24638@google.com>
In-Reply-To: <20140520231940.GA24638@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm glad that my patch is useful.
Thank you.


2014-05-21 오전 8:19, Bjorn Helgaas 쓴 글:
> On Mon, May 12, 2014 at 08:45:52PM +0900, gioh.kim wrote:
>> From: "gioh.kim" <gioh.kim@lge.com>
>>
>> update descriptions for dma_pool_create and dma_pool_alloc
>>
>> Signed-off-by: Gioh Kim <gioh.kim@lge.com>
>
> I applied this to my "dma-api" branch for v3.16, thanks!
>
> (I fixed up the From: line as you did for the other patch.)
>
>> ---
>>   Documentation/DMA-API-HOWTO.txt |    8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/Documentation/DMA-API-HOWTO.txt b/Documentation/DMA-API-HOWTO.txt
>> index 5e98303..e4251a3 100644
>> --- a/Documentation/DMA-API-HOWTO.txt
>> +++ b/Documentation/DMA-API-HOWTO.txt
>> @@ -373,13 +373,13 @@ Create a dma_pool like this:
>>
>>   	struct dma_pool *pool;
>>
>> -	pool = dma_pool_create(name, dev, size, align, alloc);
>> +	pool = dma_pool_create(name, dev, size, align, boundary);
>>
>>   The "name" is for diagnostics (like a kmem_cache name); dev and size
>>   are as above.  The device's hardware alignment requirement for this
>>   type of data is "align" (which is expressed in bytes, and must be a
>>   power of two).  If your device has no boundary crossing restrictions,
>> -pass 0 for alloc; passing 4096 says memory allocated from this pool
>> +pass 0 for boundary; passing 4096 says memory allocated from this pool
>>   must not cross 4KByte boundaries (but at that time it may be better to
>>   go for dma_alloc_coherent directly instead).
>>
>> @@ -387,8 +387,8 @@ Allocate memory from a dma pool like this:
>>
>>   	cpu_addr = dma_pool_alloc(pool, flags, &dma_handle);
>>
>> -flags are SLAB_KERNEL if blocking is permitted (not in_interrupt nor
>> -holding SMP locks), SLAB_ATOMIC otherwise.  Like dma_alloc_coherent,
>> +flags are GFP_KERNEL if blocking is permitted (not in_interrupt nor
>> +holding SMP locks), GFP_ATOMIC otherwise.  Like dma_alloc_coherent,
>>   this returns two values, cpu_addr and dma_handle.
>>
>>   Free memory that was allocated from a dma_pool like this:
>> --
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
