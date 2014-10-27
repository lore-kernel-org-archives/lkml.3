Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbaJ0L7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 07:59:50 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:38916 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbaJ0L7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 07:59:48 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-4c-544e33b15b2e
Message-id: <544E33B0.4020405@samsung.com>
Date: Mon, 27 Oct 2014 12:59:44 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Stefan Hengelein <stefan.hengelein@fau.de>,
        Laura Abbott <lauraa@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        akpm@linux-foundation.org, linux-arm-kernel@lists.infradead.org,
        Valentin Rothberg <valentinrothberg@gmail.com>,
        iommu@lists.linux-foundation.org
Subject: Re: [PATCH] arm: dma-mapping: fix compilation error when CONFIG_MMU is
 not present
References: <1413734340-53108-1-git-send-email-stefan.hengelein@fau.de>
 <5444BCFF.8030803@samsung.com>
 <CABv5NL_GdtZegpw8wxau9oD6xXWdX3GUySLqCaoaoa549Kg_GQ@mail.gmail.com>
 <5445A345.7010401@codeaurora.org> <5448B930.7070800@samsung.com>
 <CABv5NL_E83CgBcHbAqo9xejWAEamO3oxX6ZjU+fo9X6k4cE_1w@mail.gmail.com>
In-reply-to: <CABv5NL_E83CgBcHbAqo9xejWAEamO3oxX6ZjU+fo9X6k4cE_1w@mail.gmail.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t/xa7objf1CDA7MMbSYs34Nm8WC/dYW
	2ztnsFtsenyN1eLyrjlsFrcv81p035/EZvGpuY3ZgcOjpbmHzeNyXy+Tx/n22SweO2fdZfc4
	MeM3i8fmJfUek28sZ/T4vEkugCOKyyYlNSezLLVI3y6BK6Pl/TOmgj1cFfOXrGBtYNzL0cXI
	ySEhYCJx6uVpFghbTOLCvfVsXYxcHEICSxklLpyZxAThfGKU2HJ5CnMXIwcHr4CWRPevAhCT
	RUBVYupuf5BeNgFDia63XWwgtqhAjMT9navBbF4BQYkfk++xgJSLCIRJ7HlgBTKRWeAio8Tk
	jcdZQWqEBWIlVvYdglq1k0li2dTjYAdxCgRLTJ/byghiMwuYSXx5eZgVwpaX2LzmLfMERoFZ
	SHbMQlI2C0nZAkbmVYyiqaXJBcVJ6blGesWJucWleel6yfm5mxghcfB1B+PSY1aHGAU4GJV4
	eCcU+4YIsSaWFVfmHmKU4GBWEuF1/AkU4k1JrKxKLcqPLyrNSS0+xMjEwSnVwMja6Z+mwXuD
	t8X4yEu7O9wV1+3/vjZjEYsMKvxnyfhh6f01f18l98+RjAv/KtfC9uRncBlHvifDx0Veh2SD
	ZzkyPLFwdebq67NdZS/zYMr1FuHJN8y6Fed8Efo0kdnaNMKgg1vdgKcxSVKS5VD5/WrnPZzK
	Jg0pN7e4XrzjO2ue4k+O+E9zlViKMxINtZiLihMBVFIky2ECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-10-24 15:15, Stefan Hengelein wrote:
> Hello,
>
> adding a dependency to CONFIG_ARM_DMA_USE_IOMMU is probably not a good
> idea anyways.
> If you read the Documentation/kbuild/kconfig-language.txt, you will see that:
> 1. in general, selected options should have no prompt and no dependencies
> 2. giving ARM_DMA_USE_IOMMU a dependency on MMU will and cannot solve
> the problem, since ARM_DMA_USE_IOMMU itself is selected by several
> sources and select will not enforce dependencies to be resolved (to be
> precise, it will simply ignore them). Thus, CONFIG_MMU will not be
> enabled (as you can see in your warning).
> If you want to ensure CONFIG_MMU is enabled when
> CONFIG_ARM_DMA_USE_IOMMU is selected, the selecting options (e.g.
> SHMOBILE_IOMMU) should have a dependency on MMU.
> However, i'm not sure if that's the right way to solve it, since it
> will hide these options when MMU is not enabled.
>
> Making the whole IOMMU subsystem depend on MMU would probably also
> solve the problem. Is there any situation where it would make sense to
> use an IOMMU without an MMU?

IMHO such configuration doesn't make sense and hiding IOMMU section
completely when non-MMU systems are enabled is the right approach.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

