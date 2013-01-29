Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056Ab3A2PXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 10:23:07 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:50808 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756480Ab3A2PXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 10:23:06 -0500
MIME-Version: 1.0
In-Reply-To: <1359471984-26336-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1359471984-26336-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Tue, 29 Jan 2013 20:53:04 +0530
Message-ID: <CAKohpo=upCjze53v5STZJUz5OSrRqBU+mU3Q-C9BL18sXYAs5Q@mail.gmail.com>
Subject: Re: [PATCH] dw_dmac: apply default dma_mask if needed
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Arnd in cc.

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

Hmm... Why is it required for a DMA controller? What kind of crash do you
get?

@Arnd: Is this change recommended?
