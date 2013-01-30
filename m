Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab3A3CGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 21:06:24 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:33603 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab3A3CGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 21:06:22 -0500
MIME-Version: 1.0
In-Reply-To: <1359471984-26336-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1359471984-26336-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Wed, 30 Jan 2013 07:36:21 +0530
Message-ID: <CAKohpo=hNd3p2dbg9aGF9dO85PbYR+zwvZ_QyTRxa9mRbw1-pQ@mail.gmail.com>
Subject: Re: [PATCH] dw_dmac: apply default dma_mask if needed
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 January 2013 20:36, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> In some cases we got the device without dma_mask configured. We have to apply
> the default value to avoid crashes during memory mapping.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dw_dmac.c |    6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index e8d0679..a572a1e 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -1673,6 +1673,12 @@ static int dw_probe(struct platform_device *pdev)
>         if (IS_ERR(regs))
>                 return PTR_ERR(regs);
>
> +       /* Apply default dma_mask if needed */
> +       if (!pdev->dev.dma_mask) {
> +               pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
> +               pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
> +       }
> +
>         dw_params = dma_read_byaddr(regs, DW_PARAMS);
>         autocfg = dw_params >> DW_PARAMS_EN & 0x1;

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
