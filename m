Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935110AbaKNBin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 20:38:43 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:34074 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934808AbaKNBil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 20:38:41 -0500
X-Original-SENDERIP: 10.186.123.76
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <54655D1D.9080109@lge.com>
Date: Fri, 14 Nov 2014 10:38:37 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Laura Abbott <lauraa@codeaurora.org>, Colin Cross <ccross@android.com>,
        Joonsoo Kim <js1304@gmail.com>
CC: John Stultz <john.stultz@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?EUC-KR?B?IsDMsMfIoy/DpcDTv6yxuL/4L1NXIFBsYXRmb3JtKL+sKUFPVMbAKGd1bmhvLg==?=
	 =?EUC-KR?B?bGVlQGxnZS5jb20pIg==?= <gunho.lee@lge.com>
Subject: Re: Why does ion_cma_allocate need GFP_HIGHUSER | __GFP_ZERO flags?
References: <54645B38.10603@lge.com> <546559B2.4090003@codeaurora.org>
In-Reply-To: <546559B2.4090003@codeaurora.org>
Content-Type: text/plain; charset=euc-kr
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



2014-11-14 오전 10:24에 Laura Abbott 이(가) 쓴 글:
> On 11/12/2014 11:18 PM, Gioh Kim wrote:
>> Hi,
>>
>> I'm wondering why dma_alloc_coherent needs GFP_HIGHUSER | __GFP_ZERO flags in ion_cma_allocate().
>>
>> I think dma_alloc_coherent can go to __dma_alloc if the system has CMA area.
>> If __GFP_WAIT flag is set, it allocates memory from atomic pool.
>> So I think calling dma_alloc_coherent with __GFP_WAIT is enough.
>>
>> And can I get zero-filled-memory from CMA if I set __GFP_ZERO?
>>
>>
> 
> If we are actually using CMA, the GFP flags don't make much of a difference. If
> we didn't have CMA, using GFP_HIGHUSER would still be appropriate. The memory
> is going to userspace so the user part is necessary and there should be no need
> for a lowmem mapping so highmem can be used. __GFP_ZERO might be redundant since
> the dma layer zeros memory anyway but it's probably safe.

If cma-heap can be created even-if the system doesn't have CMA area, you're right.

But I think cma-heap should be created only if the system has CMA area.
I think, in no CMA system, cma-heap creation and/or allocation from cma-heap should be failed,
not allocate memory from lowmem or highmem as you say.

Thanks for your reply.

> 
> I think the flags should be fine as is.
> 
> Thanks,
> Laura
> 
