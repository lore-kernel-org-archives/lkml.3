Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061AbaAXWNI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 17:13:08 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:52577 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbaAXWNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 17:13:04 -0500
Message-ID: <52E2E56D.3040009@codeaurora.org>
Date: Fri, 24 Jan 2014 14:13:01 -0800
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Somraj Mani <somraj.mani@samsung.com>
Subject: Re: [PATCH] arm64: fix build error if DMA_CMA is enabled
References: <1390551788-6138-1-git-send-email-pankaj.dubey@samsung.com> <20140124153756.GH19052@arm.com>
In-Reply-To: <20140124153756.GH19052@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/24/2014 7:37 AM, Catalin Marinas wrote:
> On Fri, Jan 24, 2014 at 08:23:08AM +0000, Pankaj Dubey wrote:
>> arm64/include/asm/dma-contiguous.h is trying to include
>> <asm-genric/dma-contiguous.h> which does not exist, and thus failing
>> build for arm64 if we enable CONFIG_DMA_CMA. This patch fixes build
>> error by removing unwanted header inclusion from arm64's dma-contiguous.h.
>>
>> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
>> Signed-off-by: Somraj Mani <somraj.mani@samsung.com>
>> ---
>>   arch/arm64/include/asm/dma-contiguous.h |    1 -
>>   1 file changed, 1 deletion(-)
>>
>> diff --git a/arch/arm64/include/asm/dma-contiguous.h b/arch/arm64/include/asm/dma-contiguous.h
>> index d6aacb6..14c4c0c 100644
>> --- a/arch/arm64/include/asm/dma-contiguous.h
>> +++ b/arch/arm64/include/asm/dma-contiguous.h
>> @@ -18,7 +18,6 @@
>>   #ifdef CONFIG_DMA_CMA
>>
>>   #include <linux/types.h>
>> -#include <asm-generic/dma-contiguous.h>
>
> Thanks for this.
>
> Laura, did you have additional patches adding
> asm-generic/dma-contiguous.h?
>

no, asm-generic/dma-contiguous.h was an old file which was later 
removed. I missed this when rebasing from my older branch to mainline.
You can have

Acked-by: Laura Abbott <lauraa@codeaurora.org>

Thanks,
Laura

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
