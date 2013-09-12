Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab3ILRLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:11:47 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:38632 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337Ab3ILRLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:11:46 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <5231F45C.3020500@infradead.org>
References: <1378960710-15648-1-git-send-email-olof@lixom.net>
	<5231F45C.3020500@infradead.org>
Date: Thu, 12 Sep 2013 10:11:44 -0700
Message-ID: <CAOesGMi2VkBzvXtK9eftViaWBRFGdv6TgzYZ6NCKQfhKWZGVWA@mail.gmail.com>
Subject: Re: [PATCH] dma: use %pa to print dma_addr_t
From: Olof Johansson <olof@lixom.net>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 10:05 AM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 09/11/13 21:38, Olof Johansson wrote:
>> This resolves some warnings seen when building with CONFIG_ARM_LPAE=y, since
>> dma_addr_t might then be 64-bit:
>>
>>   drivers/dma/imx-sdma.c:1092:3: warning: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat=]
>>   drivers/dma/imx-sdma.c:1166:3: warning: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat=]
>>   drivers/dma/imx-dma.c:579:3: warning: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat=]
>>   drivers/dma/imx-dma.c:579:3: warning: format '%x' expects argument of type 'unsigned int', but argument 7 has type 'dma_addr_t' [-Wformat=]
>>   drivers/dma/imx-dma.c:593:4: warning: format '%x' expects argument of type 'unsigned int', but argument 9 has type 'dma_addr_t' [-Wformat=]
>>   drivers/dma/imx-dma.c:603:4: warning: format '%x' expects argument of type 'unsigned int', but argument 9 has type 'dma_addr_t' [-Wformat=]
>>   drivers/dma/imx-dma.c:930:2: warning: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat=]
>>   drivers/dma/imx-dma.c:930:2: warning: format '%x' expects argument of type 'unsigned int', but argument 7 has type 'dma_addr_t' [-Wformat=]
>>   drivers/dma/imx-dma.c:960:2: warning: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat=]
>>   drivers/dma/imx-dma.c:960:2: warning: format '%x' expects argument of type 'unsigned int', but argument 7 has type 'dma_addr_t' [-Wformat=]
>>   drivers/dma/ipu/ipu_idmac.c:1235:2: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'dma_addr_t' [-Wformat=]
>
>
> I've been tempted to make similar patches, but CONFIG_PHYS_ADDR_T_64BIT
> and CONFIG_ARCH_DMA_ADDR_T_64BIT are independent AFAICT,
> and %pa is for physical addresses, not necessarily DMA addresses.
>
> Am I confused?

So, I prepared just that (allocating %pA for dma_addr_t) last night,
but after looking around a bit more, it was unclear to me if it's ever
meaningful to separate the two of them at different word sizes.

Any >32bit-addressable machine will likely want 64-bit dma_addr_t as
well. The only architecture that doesn't seem to set
ARCH_DMA_ADDR_T_64BIT based on PHYS_ADDR_T size is ARM, and I think
that should just be changed there as well.


-Olof
