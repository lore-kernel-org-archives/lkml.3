Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbaJUAF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 20:05:29 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38925 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbaJUAF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 20:05:28 -0400
Message-ID: <5445A345.7010401@codeaurora.org>
Date: Mon, 20 Oct 2014 17:05:25 -0700
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stefan Hengelein <stefan.hengelein@fau.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>
CC: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        akpm@linux-foundation.org, linux-arm-kernel@lists.infradead.org,
        andreas.herrmann@calxeda.com,
        Valentin Rothberg <valentinrothberg@gmail.com>
Subject: Re: [PATCH] arm: dma-mapping: fix compilation error when CONFIG_MMU
 is not present
References: <1413734340-53108-1-git-send-email-stefan.hengelein@fau.de>	<5444BCFF.8030803@samsung.com> <CABv5NL_GdtZegpw8wxau9oD6xXWdX3GUySLqCaoaoa549Kg_GQ@mail.gmail.com>
In-Reply-To: <CABv5NL_GdtZegpw8wxau9oD6xXWdX3GUySLqCaoaoa549Kg_GQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2014 6:50 AM, Stefan Hengelein wrote:
> Well,
>
> arch/arm/mm/dma-mapping.c: In function ‘__atomic_get_pages’:
> arch/arm/mm/dma-mapping.c:1265:31: error: ‘atomic_pool’ undeclared
> (first use in this function)
>
> arch/arm/mm/dma-mapping.c: In function ‘__iommu_get_pages’:
> arch/arm/mm/dma-mapping.c:1275:2: error: implicit declaration of
> function ‘__in_atomic_pool’ [-Werror=implicit-function-declaration]
>
>
> others:
> arch/arm/mm/dma-mapping.c: In function ‘__iommu_alloc_remap’:
> arch/arm/mm/dma-mapping.c:1200:4: error: ‘VM_ARM_DMA_CONSISTENT’
> undeclared (first use in this function)
> arch/arm/mm/dma-mapping.c:1200:4: note: each undeclared identifier is
> reported only once for each function it appears in
>
> arch/arm/mm/dma-mapping.c: In function ‘__iommu_get_pages’:
> arch/arm/mm/dma-mapping.c:1282:29: error: ‘VM_ARM_DMA_CONSISTENT’
> undeclared (first use in this function)
> arch/arm/mm/dma-mapping.c: In function ‘arm_iommu_free_attrs’:
> arch/arm/mm/dma-mapping.c:1411:4: error: ‘VM_ARM_DMA_CONSISTENT’
> undeclared (first use in this function)
>
>
> i've attached a configuration where it happens.
> when you place the configuration in your tree and compile the file,
> the errors should show up.
>
> However, within the configuration CONFIG_ARM_DMA_USE_IOMMU is defined
> and CONFIG_MMU is not. AFAIUI, if both should be enabled together, it
> should be mapped in Kconfig somewhere, right?
>
> Best Regards,
> Stefan
>

There isn't a nice way to fixup the dma consistent flags so I would
say this option should just depend on MMU.

Thanks,
Laura

-- 
Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
