Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359AbaJWIPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 04:15:53 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:13905 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602AbaJWIPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 04:15:48 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed
X-AuditID: cbfec7f4-b7f6c6d00000120b-b8-5448b931eec8
Content-transfer-encoding: 8BIT
Message-id: <5448B930.7070800@samsung.com>
Date: Thu, 23 Oct 2014 10:15:44 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
To: Laura Abbott <lauraa@codeaurora.org>,
        Stefan Hengelein <stefan.hengelein@fau.de>
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        akpm@linux-foundation.org, linux-arm-kernel@lists.infradead.org,
        andreas.herrmann@calxeda.com,
        Valentin Rothberg <valentinrothberg@gmail.com>,
        iommu@lists.linux-foundation.org
Subject: Re: [PATCH] arm: dma-mapping: fix compilation error when CONFIG_MMU is
 not present
References: <1413734340-53108-1-git-send-email-stefan.hengelein@fau.de>
 <5444BCFF.8030803@samsung.com>
 <CABv5NL_GdtZegpw8wxau9oD6xXWdX3GUySLqCaoaoa549Kg_GQ@mail.gmail.com>
 <5445A345.7010401@codeaurora.org>
In-reply-to: <5445A345.7010401@codeaurora.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t/xq7qGOz1CDBZ9lbOYs34Nm8XiIzEW
	C/ZbW2zvnMFusenxNVaLy7vmsFncvsxr0X1/EpvFp+Y2ZgdOj5bmHjaPBZ+vsHtc7utl8jjf
	PpvFY+esu+weJ2b8ZvHYvKTeY/KN5YwenzfJBXBGcdmkpOZklqUW6dslcGWceLaUrWCqcMWZ
	/Q+YGhgnC3QxcnJICJhITLu6gRnCFpO4cG89WxcjF4eQwFJGiQ9XzzCCJHgFBCV+TL7H0sXI
	wcEsIC9x5FI2SJhZwEziy8vDrBD1nxgl9sy6wwxRryUxZ84mZpB6FgFViSUHuUHCbAKGEl1v
	u9hAbFGBGIn7O1eD2SICYRJ3Dz8F28ss8J5RYlnbCiaQhLBArMTKvkNMEAsuM0rcbZoP1sEp
	oCdx7vZ8pgmMArOQ3DcL4b5ZSO5bwMi8ilE0tTS5oDgpPddQrzgxt7g0L10vOT93EyMkMr7s
	YFx8zOoQowAHoxIPb0WyR4gQa2JZcWXuIUYJDmYlEd60HUAh3pTEyqrUovz4otKc1OJDjEwc
	nFINjCXfqnOy4/MeMRT/iI/6tDj7ocnKVdMjDt3ybmANk1z0N3irgX516e6aYy4ZH7sm6dvn
	JEvdOLNf+OSFZeHtv47XrA2TO5fPJJI9K+ooX77w1agblWs+mfX4pdQJ5NvIx+zijdcuq1+h
	4iBS8vR05UuGOmsW5vuzWW2fXC07Y5oTxHnl53oPJZbijERDLeai4kQAdjLcUmoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-10-21 02:05, Laura Abbott wrote:
> On 10/20/2014 6:50 AM, Stefan Hengelein wrote:
>> Well,
>>
>> arch/arm/mm/dma-mapping.c: In function ‘__atomic_get_pages’:
>> arch/arm/mm/dma-mapping.c:1265:31: error: ‘atomic_pool’ undeclared
>> (first use in this function)
>>
>> arch/arm/mm/dma-mapping.c: In function ‘__iommu_get_pages’:
>> arch/arm/mm/dma-mapping.c:1275:2: error: implicit declaration of
>> function ‘__in_atomic_pool’ [-Werror=implicit-function-declaration]
>>
>>
>> others:
>> arch/arm/mm/dma-mapping.c: In function ‘__iommu_alloc_remap’:
>> arch/arm/mm/dma-mapping.c:1200:4: error: ‘VM_ARM_DMA_CONSISTENT’
>> undeclared (first use in this function)
>> arch/arm/mm/dma-mapping.c:1200:4: note: each undeclared identifier is
>> reported only once for each function it appears in
>>
>> arch/arm/mm/dma-mapping.c: In function ‘__iommu_get_pages’:
>> arch/arm/mm/dma-mapping.c:1282:29: error: ‘VM_ARM_DMA_CONSISTENT’
>> undeclared (first use in this function)
>> arch/arm/mm/dma-mapping.c: In function ‘arm_iommu_free_attrs’:
>> arch/arm/mm/dma-mapping.c:1411:4: error: ‘VM_ARM_DMA_CONSISTENT’
>> undeclared (first use in this function)
>>
>>
>> i've attached a configuration where it happens.
>> when you place the configuration in your tree and compile the file,
>> the errors should show up.
>>
>> However, within the configuration CONFIG_ARM_DMA_USE_IOMMU is defined
>> and CONFIG_MMU is not. AFAIUI, if both should be enabled together, it
>> should be mapped in Kconfig somewhere, right?
>
> There isn't a nice way to fixup the dma consistent flags so I would
> say this option should just depend on MMU.

The question is which option should depend on MMU? Making 
CONFIG_ARM_DMA_USE_IOMMU
to depend on MMU doesn't solve this case. It only gives following 
warning with the
mentioned .config:
warning: (VIDEO_OMAP3 && EXYNOS_IOMMU && SHMOBILE_IOMMU && IPMMU_VMSA && 
ARM_SMMU) selects ARM_DMA_USE_IOMMU which has unmet direct dependencies 
(MMU)

IMHO the best solution will be to either make the whole IOMMU subsystem 
to depend
on MMU or alternatively, add this dependency to all IOMMU drivers which 
can be
enabled by COMPILE_TEST option (here the issue is caused by 
SHMOBILE_IOMMU, which
otherwise cannot be enabled when no-mmu systems are selected).

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

