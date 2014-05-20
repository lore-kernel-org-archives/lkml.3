Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491AbaETXj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 19:39:58 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:56129 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaETXj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 19:39:56 -0400
X-Original-SENDERIP: 10.178.33.69
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <537BE7CA.4030706@lge.com>
Date: Wed, 21 May 2014 08:39:54 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Heesub Shin <heesub.shin@samsung.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        =?UTF-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>
Subject: Re: [RFC PATCH] arm: dma-mapping: fallback allocation for cma failure
References: <537AEEDB.2000001@lge.com> <20140520065222.GB8315@js1304-P5Q-DELUXE> <537AFED0.4010401@lge.com> <20140520083206.GA8927@js1304-P5Q-DELUXE>
In-Reply-To: <20140520083206.GA8927@js1304-P5Q-DELUXE>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



2014-05-20 오후 5:32, Joonsoo Kim 쓴 글:
> On Tue, May 20, 2014 at 04:05:52PM +0900, Gioh Kim wrote:
>> That case, device-specific coherent memory allocation, is handled at dma_alloc_coherent in arm_dma_alloc.
>> __dma_alloc handles only general coherent memory allocation.
>>
>> I'm sorry missing mention about it.
>>
>
> Hello,
>
> AFAIK, *coherent* memory allocation is different with *contiguous* memory
> allocation(CMA). So we need to handle the case I mentioned.

Yes, I confused the coherent memory aand contiguous memory. It's my mistake.

So I checked dma_alloc_from_contiguous and found dev_get_cma_area function.
The dev_get_cma_area returns device-specific cma if it exists or default global-cma.
I think __alloc_from_contiguous doesn't distinguish device-specific cma area and global cma.
The purpose of __alloc_from_contiguous is allocation of contiguous memory from any cma area, not device-specific area.

If my assumption is right, __alloc_from_contiguous can be replaced with __alloc_remap_buffer without checking device-specific cma area.

What do you think about it?

>
> Thanks.
>
