Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab3JUHds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 03:33:48 -0400
Received: from mail-qe0-f42.google.com ([209.85.128.42]:42642 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab3JUHdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 03:33:47 -0400
MIME-Version: 1.0
In-Reply-To: <1381940926-25564-9-git-send-email-vinod.koul@intel.com>
References: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
	<1381940926-25564-9-git-send-email-vinod.koul@intel.com>
Date: Mon, 21 Oct 2013 13:03:46 +0530
Message-ID: <CAKohpo=UFu21WZVtfoTRzRuQxs=xXxaTjXUATn9r16W5BJJPbA@mail.gmail.com>
Subject: Re: [PATCH 08/28] dmaengine: dw: use DMA_COMPLETE for dma completion status
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: dan.j.williams@intel.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 October 2013 21:58, Vinod Koul <vinod.koul@intel.com> wrote:
> Signed-off-by: Vinod Koul <vinod.koul@intel.com>
> CC: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> CC: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/dma/dw/core.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/dma/dw/core.c b/drivers/dma/dw/core.c
> index 89eb89f..2c29331 100644
> --- a/drivers/dma/dw/core.c
> +++ b/drivers/dma/dw/core.c
> @@ -1098,13 +1098,13 @@ dwc_tx_status(struct dma_chan *chan,
>         enum dma_status         ret;
>
>         ret = dma_cookie_status(chan, cookie, txstate);
> -       if (ret == DMA_SUCCESS)
> +       if (ret == DMA_COMPLETE)
>                 return ret;
>
>         dwc_scan_descriptors(to_dw_dma(chan->device), dwc);
>
>         ret = dma_cookie_status(chan, cookie, txstate);
> -       if (ret != DMA_SUCCESS)
> +       if (ret != DMA_COMPLETE)
>                 dma_set_residue(txstate, dwc_get_residue(dwc));
>
>         if (dwc->paused && ret == DMA_IN_PROGRESS)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
