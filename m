Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113AbaHZNAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 09:00:38 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:33647 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758111AbaHZNAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 09:00:33 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-9b-53fc84eea11e
Message-id: <53FC84EC.1050800@samsung.com>
Date: Tue, 26 Aug 2014 15:00:28 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Laura Abbott <lauraa@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-mm-sig@lists.linaro.org, devicetree@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Grant Likely <grant.likely@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mackerras <paulus@samba.org>,
        Jon Medhurst <tixy@linaro.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Aneesh Kumar K.V." <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 0/4] CMA & device tree, once again
References: <1405321966-28184-1-git-send-email-m.szyprowski@samsung.com>
 <53E56B16.5030402@codeaurora.org>
In-reply-to: <53E56B16.5030402@codeaurora.org>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsVy+t/xa7rvWv4EG6y+wWkxZ/0aNovHr+ex
	WPyddIzd4kNTK7PF+2U9jBbzj5xjtTjwZwejxcruZjaLneveMVps75zBbvHlykMmi02Pr7Fa
	XN41h81iw8uDTBYLjrewWvyZLmex5shidou/2zexWKyf8ZrFYuH8++wWLz+eYHEQ9Vgzbw2j
	x+9fkxg9Lvf1MnnsnHWX3aPnTQurR9fbK0wed67tYfM4MeM3i8eDQ5tZPDYvqfe4/e8xs8e6
	P6+YPPr/GnjM3dXH6NG3ZRWjx+dNcgECUVw2Kak5mWWpRfp2CVwZq286FMyUqJh47DRzA+Np
	4S5GTg4JAROJPz0r2CBsMYkL99YD2VwcQgJLGSUuXpvCDuF8YpQ4c/I4C0gVr4CWxKPOOawg
	NouAqsTvCVPAutkEDCW63nYB2RwcogJREse+5kGUC0r8mHwPrFVEIE/i4cedjCA2s8BpVolv
	FxRAbGEBS4n2ZYfAaoQEciT+tmxjBrE5BfQkjr34yg5Rbybx5eVhVghbXmLzmrfMExgFZiFZ
	MQtJ2SwkZQsYmVcxiqaWJhcUJ6XnGukVJ+YWl+al6yXn525ihMT11x2MS49ZHWIU4GBU4uF9
	kPY7WIg1say4MvcQowQHs5II74+kP8FCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGD26F9wT7Wk6
	ta08Olf+2AK9xa27sl+s+pCsMevZ6t3PFi74kr/U6miM3nre5KAIzspKnW9bbwVKft6tfYat
	/OilE4yZlzhjGs0OOiy9Zf6A3WXmx2LJ1V5hx6fuWqQfGawQ8nSOX3ztkUWzXD/J5kkppE22
	2D/rlvsu5hkf/x58fcbP3b17prQSS3FGoqEWc1FxIgD92pfVyQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-08-09 02:28, Laura Abbott wrote:
> On 7/14/2014 12:12 AM, Marek Szyprowski wrote:
>> Hello,
>>
>> This is one more respin of the patches which add support for creating
>> reserved memory regions defined in device tree. The last attempt
>> (http://lists.linaro.org/pipermail/linaro-mm-sig/2014-February/003738.html)
>> ended in merging only half of the code, so right now we have complete
>> documentation merged and only basic code, which implements a half of it
>> is written in the documentation. Although the merged patches allow to
>> reserve memory, there is no way of using it for devices and drivers.
>>
>> This situation makes CMA rather useless, as the main architecture (ARM),
>> which used it, has been converted from board-file based system
>> initialization to device tree. Thus there is no place to use direct
>> calls to dma_declare_contiguous() and some new solution, which bases on
>> device tree, is urgently needed.
>>
>> This patch series fixes this issue. It provides two, already widely
>> discussed and already present in the kernel, drivers for reserved
>> memory: first based on DMA-coherent allocator, second using Contiguous
>> Memory Allocator. The first one nicely implements typical 'carved out'
>> reserved memory way of allocating contiguous buffers in a kernel-style
>> way. The memory is used exclusively by devices assigned to the given
>> memory region. The second one allows to reuse reserved memory for
>> movable kernel pages (like disk buffers, anonymous memory) and migrates
>> it out when device to allocates contiguous memory buffer. Both driver
>> provides memory buffers via standard dma-mapping API.
>>
>> The patches have been rebased on top of latest CMA and mm changes merged
>> to akmp kernel tree.
>>
>> To define a 64MiB CMA region following node is needed:
>>
>> multimedia_reserved: multimedia_mem_region {
>> 	compatible = "shared-dma-pool";
>> 	reusable;
>> 	size = <0x4000000>;
>> 	alignment = <0x400000>;
>> };
>>
>> Similarly, one can define 64MiB region with DMA coherent memory:
>>
>> multimedia_reserved: multimedia_mem_region {
>> 	compatible = "shared-dma-pool";
>> 	no-map;
>> 	size = <0x4000000>;
>> 	alignment = <0x400000>;
>> };
>>
> Longer term, I think it would be good if we didn't have to use no-map with
> the coherent memory. With no-map and dma-coherent.c right now, not only
> do you lose out on the physical memory space, you also have to give up
> the same amount of vmalloc space for mapping. On arm32, if you have the default
> 240MB vmalloc space, 64M is ~25% of the vmalloc space. At least on arm you can
> make this up by remapping the memory as coherent.
>
> I haven't seen this picked up anywhere yet so you are welcome to add
>
> Tested-by: Laura Abbott <lauraa@codeaurora.org>

Right, when the code reaches mainline I will add code which will remove 
no-map
requirement. Changing memory attributes can be handled in this case the same
way as for CMA.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

