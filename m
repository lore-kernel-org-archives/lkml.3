Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933930Ab3FSBFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:05:31 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:51836 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933792Ab3FSBFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:05:30 -0400
MIME-Version: 1.0
In-Reply-To: <1371602813-19828-3-git-send-email-jon.mason@intel.com>
References: <1371602813-19828-1-git-send-email-jon.mason@intel.com>
	<1371602813-19828-3-git-send-email-jon.mason@intel.com>
Date: Tue, 18 Jun 2013 17:59:59 -0700
X-Google-Sender-Auth: d3NfUnSkj8GTf8PRHZbDnyJyors
Message-ID: <CAA9_cmeie_V0PauHBadVsg22OQmFrC_Oeg1o1FwdzQ+mVU9gTA@mail.gmail.com>
Subject: Re: [PATCH 2/2] ioatdma: add DMA_PRIVATE capabilities flag
From: Dan Williams <djbw@fb.com>
To: Jon Mason <jon.mason@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Dave Jiang <dave.jiang@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 5:46 PM, Jon Mason <jon.mason@intel.com> wrote:
> Set the DMA_PRIVATE dma_transaction_type in the capability mask.  This
> enables the ability to get an exclusive ioatdma DMA channel for any
> devices that requests one via the dma_request_channel function call.
>
> Signed-off-by: Jon Mason <jon.mason@intel.com>
> Acked-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/dma/ioat/dma_v3.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
> index ca6ea9b..ac2aeef 100644
> --- a/drivers/dma/ioat/dma_v3.c
> +++ b/drivers/dma/ioat/dma_v3.c
> @@ -1883,6 +1883,7 @@ int ioat3_dma_probe(struct ioatdma_device *device, int dca)
>                 dma->copy_align = 6;
>
>         dma_cap_set(DMA_INTERRUPT, dma->cap_mask);
> +       dma_cap_set(DMA_PRIVATE, dma->cap_mask);
>         dma->device_prep_dma_interrupt = ioat3_prep_interrupt_lock;

DMA_PRIVATE here keeps all channels private, so they couldn't be used
elsewhere, for example raid offload.  Do you need a private allocation
or can you get away with a dynamically assigned channel?
