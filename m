Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934982AbaKNBYF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 20:24:05 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:32960 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934699AbaKNBYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 20:24:03 -0500
Message-ID: <546559B2.4090003@codeaurora.org>
Date: Thu, 13 Nov 2014 17:24:02 -0800
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Gioh Kim <gioh.kim@lge.com>, Colin Cross <ccross@android.com>,
        Joonsoo Kim <js1304@gmail.com>
CC: John Stultz <john.stultz@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?EUC-KR?B?IsDMsMfIoy/DpcDTv6yxuL/4L1NXIFBsYXRmb3JtKL+sKUFPVMbAKGd1bmhvLg==?=
	 =?EUC-KR?B?bGVlQGxnZS5jb20pIg==?= <gunho.lee@lge.com>
Subject: Re: Why does ion_cma_allocate need GFP_HIGHUSER | __GFP_ZERO flags?
References: <54645B38.10603@lge.com>
In-Reply-To: <54645B38.10603@lge.com>
Content-Type: text/plain; charset=euc-kr
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2014 11:18 PM, Gioh Kim wrote:
> Hi,
> 
> I'm wondering why dma_alloc_coherent needs GFP_HIGHUSER | __GFP_ZERO flags in ion_cma_allocate().
> 
> I think dma_alloc_coherent can go to __dma_alloc if the system has CMA area.
> If __GFP_WAIT flag is set, it allocates memory from atomic pool.
> So I think calling dma_alloc_coherent with __GFP_WAIT is enough.
> 
> And can I get zero-filled-memory from CMA if I set __GFP_ZERO?
> 
> 

If we are actually using CMA, the GFP flags don't make much of a difference. If
we didn't have CMA, using GFP_HIGHUSER would still be appropriate. The memory
is going to userspace so the user part is necessary and there should be no need
for a lowmem mapping so highmem can be used. __GFP_ZERO might be redundant since
the dma layer zeros memory anyway but it's probably safe.

I think the flags should be fine as is.

Thanks,
Laura

-- 
Qualcomm Innovation Center, Inc. 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
