Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906AbaH1A4R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 20:56:17 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39734 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755639AbaH1A4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 20:56:15 -0400
Message-ID: <53FE7E2D.9060408@codeaurora.org>
Date: Wed, 27 Aug 2014 17:56:13 -0700
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Aug 27
References: <20140827161021.298aede6@canb.auug.org.au>	<20140827235809.GA9598@roeck-us.net> <20140828104830.4447c5e5@canb.auug.org.au>
In-Reply-To: <20140828104830.4447c5e5@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/27/2014 5:48 PM, Stephen Rothwell wrote:
> Hi all,
>
> On Wed, 27 Aug 2014 16:58:09 -0700 Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> I see a large number of build failures with this kernel.
>>
>> drivers/base/dma-mapping.c: In function 'dma_common_contiguous_remap':
>> drivers/base/dma-mapping.c:294:2: error: implicit declaration of function
>> 'dma_common_pages_remap' [-Werror=implicit-function-declaration]
>> drivers/base/dma-mapping.c:294:6: warning: assignment makes pointer from integer
>> without a cast [enabled by default]
>> drivers/base/dma-mapping.c: At top level:
>> drivers/base/dma-mapping.c:305:7: error: conflicting types for
>> 'dma_common_pages_remap'
>> drivers/base/dma-mapping.c:294:8: note: previous implicit declaration of
>> 'dma_common_pages_remap' was here
>> cc1: some warnings being treated as errors
>> make[2]: *** [drivers/base/dma-mapping.o] Error 1
>
> Caused by commit fa44abcad042 ("common: dma-mapping: introduce common
> remapping functions") from the akpm-current tree.  I will attempt to
> revert that commit today, but I may need to also revert the following 2
> commits as well:
>
> arm: use genalloc for the atomic pool
> arm64: add atomic pool for non-coherent and CMA allocations
>
> though I am not sure.  Hopefully someone will let me know in the next
> few hours ...
>

I sent fixes for this to Andrew yesterday, did those not get picked up
or fix the problem?

Thanks,
Laura

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
