Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab3ILRFn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:05:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52806 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906Ab3ILRFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:05:42 -0400
Message-ID: <5231F45C.3020500@infradead.org>
Date: Thu, 12 Sep 2013 10:05:32 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] dma: use %pa to print dma_addr_t
References: <1378960710-15648-1-git-send-email-olof@lixom.net>
In-Reply-To: <1378960710-15648-1-git-send-email-olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/13 21:38, Olof Johansson wrote:
> This resolves some warnings seen when building with CONFIG_ARM_LPAE=y, since
> dma_addr_t might then be 64-bit:
> 
>   drivers/dma/imx-sdma.c:1092:3: warning: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat=]
>   drivers/dma/imx-sdma.c:1166:3: warning: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat=]
>   drivers/dma/imx-dma.c:579:3: warning: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat=]
>   drivers/dma/imx-dma.c:579:3: warning: format '%x' expects argument of type 'unsigned int', but argument 7 has type 'dma_addr_t' [-Wformat=]
>   drivers/dma/imx-dma.c:593:4: warning: format '%x' expects argument of type 'unsigned int', but argument 9 has type 'dma_addr_t' [-Wformat=]
>   drivers/dma/imx-dma.c:603:4: warning: format '%x' expects argument of type 'unsigned int', but argument 9 has type 'dma_addr_t' [-Wformat=]
>   drivers/dma/imx-dma.c:930:2: warning: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat=]
>   drivers/dma/imx-dma.c:930:2: warning: format '%x' expects argument of type 'unsigned int', but argument 7 has type 'dma_addr_t' [-Wformat=]
>   drivers/dma/imx-dma.c:960:2: warning: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat=]
>   drivers/dma/imx-dma.c:960:2: warning: format '%x' expects argument of type 'unsigned int', but argument 7 has type 'dma_addr_t' [-Wformat=]
>   drivers/dma/ipu/ipu_idmac.c:1235:2: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'dma_addr_t' [-Wformat=]


I've been tempted to make similar patches, but CONFIG_PHYS_ADDR_T_64BIT
and CONFIG_ARCH_DMA_ADDR_T_64BIT are independent AFAICT,
and %pa is for physical addresses, not necessarily DMA addresses.

Am I confused?


-- 
~Randy
