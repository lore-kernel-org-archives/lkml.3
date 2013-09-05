Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab3IEPT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 11:19:59 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:44887 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab3IEPT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 11:19:58 -0400
Message-ID: <5228A11B.2020808@linaro.org>
Date: Thu, 05 Sep 2013 11:19:55 -0400
From: Matt Porter <matt.porter@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Josh Boyer <jwboyer@redhat.com>
CC: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma/Kconfig: Make TI_EDMA select TI_PRIV_EDMA
References: <20130904133203.GB12834@hansolo.jdub.homelinux.org>
In-Reply-To: <20130904133203.GB12834@hansolo.jdub.homelinux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 09:32 AM, Josh Boyer wrote:
> The TI_EDMA driver unconditionally calls functions provided by the
> TI_PRIV_EDMA code, but it doesn't force that to be built-in.  If that isn't
> otherwise enabled somewhere, you can get build errors like:
>
> linux-3.12.0-0.rc0.git1.1.fc21.armv7hl/drivers/dma/edma.c:593: undefined reference to `edma_free_slot'
> drivers/built-in.o: In function `edma_terminate_all':
> linux-3.12.0-0.rc0.git1.1.fc21.armv7hl/drivers/dma/edma.c:169: undefined reference to `edma_stop'
> drivers/built-in.o: In function `edma_execute':
> linux-3.12.0-0.rc0.git1.1.fc21.armv7hl/drivers/dma/edma.c:122: undefined reference to `edma_write_slot'
> linux-3.12.0-0.rc0.git1.1.fc21.armv7hl/drivers/dma/edma.c:149: undefined reference to `edma_link'
> linux-3.12.0-0.rc0.git1.1.fc21.armv7hl/drivers/dma/edma.c:152: undefined reference to `edma_start'
>
> Make TI_EDMA select TI_PRIV_EDMA to avoid this.
>
> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
> ---
>   drivers/dma/Kconfig | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index daa4da2..825374b 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -198,6 +198,7 @@ config TI_EDMA
>   	depends on ARCH_DAVINCI || ARCH_OMAP
>   	select DMA_ENGINE
>   	select DMA_VIRTUAL_CHANNELS
> +	select TI_PRIV_EDMA
>   	default n
>   	help
>   	  Enable support for the TI EDMA controller. This DMA
>

Looks good, thanks for addressing this.

Acked-by: Matt Porter <matt.porter@linaro.org>
