Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab3ILRoW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:44:22 -0400
Received: from mail-qe0-f51.google.com ([209.85.128.51]:49474 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab3ILRoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:44:21 -0400
MIME-Version: 1.0
In-Reply-To: <CAOesGMi2VkBzvXtK9eftViaWBRFGdv6TgzYZ6NCKQfhKWZGVWA@mail.gmail.com>
References: <1378960710-15648-1-git-send-email-olof@lixom.net>
	<5231F45C.3020500@infradead.org>
	<CAOesGMi2VkBzvXtK9eftViaWBRFGdv6TgzYZ6NCKQfhKWZGVWA@mail.gmail.com>
Date: Thu, 12 Sep 2013 10:44:19 -0700
X-Google-Sender-Auth: pS4OdBDonWeIdFcucb8m9pS_5e0
Message-ID: <CAA9_cmc2HKq5HKQSAJMAcZ4=9RG=9Le1LdGgyYW5+sXp5wE8gw@mail.gmail.com>
Subject: Re: [PATCH] dma: use %pa to print dma_addr_t
From: Dan Williams <dan.j.williams@intel.com>
To: Olof Johansson <olof@lixom.net>
Cc: Randy Dunlap <rdunlap@infradead.org>, Vinod Koul <vinod.koul@intel.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 10:11 AM, Olof Johansson <olof@lixom.net> wrote:
> On Thu, Sep 12, 2013 at 10:05 AM, Randy Dunlap <rdunlap@infradead.org> wrote:
>> On 09/11/13 21:38, Olof Johansson wrote:
>>> This resolves some warnings seen when building with CONFIG_ARM_LPAE=y, since
>>> dma_addr_t might then be 64-bit:
>>>
>>>   drivers/dma/imx-sdma.c:1092:3: warning: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat=]
>>>   drivers/dma/imx-sdma.c:1166:3: warning: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat=]
>>>   drivers/dma/imx-dma.c:579:3: warning: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat=]
>>>   drivers/dma/imx-dma.c:579:3: warning: format '%x' expects argument of type 'unsigned int', but argument 7 has type 'dma_addr_t' [-Wformat=]
>>>   drivers/dma/imx-dma.c:593:4: warning: format '%x' expects argument of type 'unsigned int', but argument 9 has type 'dma_addr_t' [-Wformat=]
>>>   drivers/dma/imx-dma.c:603:4: warning: format '%x' expects argument of type 'unsigned int', but argument 9 has type 'dma_addr_t' [-Wformat=]
>>>   drivers/dma/imx-dma.c:930:2: warning: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat=]
>>>   drivers/dma/imx-dma.c:930:2: warning: format '%x' expects argument of type 'unsigned int', but argument 7 has type 'dma_addr_t' [-Wformat=]
>>>   drivers/dma/imx-dma.c:960:2: warning: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat=]
>>>   drivers/dma/imx-dma.c:960:2: warning: format '%x' expects argument of type 'unsigned int', but argument 7 has type 'dma_addr_t' [-Wformat=]
>>>   drivers/dma/ipu/ipu_idmac.c:1235:2: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'dma_addr_t' [-Wformat=]
>>
>>
>> I've been tempted to make similar patches, but CONFIG_PHYS_ADDR_T_64BIT
>> and CONFIG_ARCH_DMA_ADDR_T_64BIT are independent AFAICT,
>> and %pa is for physical addresses, not necessarily DMA addresses.
>>
>> Am I confused?
>
> So, I prepared just that (allocating %pA for dma_addr_t) last night,
> but after looking around a bit more, it was unclear to me if it's ever
> meaningful to separate the two of them at different word sizes.
>
> Any >32bit-addressable machine will likely want 64-bit dma_addr_t as
> well. The only architecture that doesn't seem to set
> ARCH_DMA_ADDR_T_64BIT based on PHYS_ADDR_T size is ARM, and I think
> that should just be changed there as well.
>

Xen also plays games here and has a 32-bit physical address with
64-bit dma.  So I think we need something like Joe's patch.

--
Dan
