Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab3H1HfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 03:35:20 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:45540 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab3H1HfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 03:35:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org,
        "'Laurent Pinchart'" <laurent.pinchart+renesas@ideasonboard.com>,
        "'Guennadi Liakhovetski'" <g.liakhovetski@gmx.de>,
        "'Ian Molton'" <ian.molton@collabora.co.uk>,
        "'Chris Ball'" <cjb@laptop.org>
Subject: Re: [PATCH 1/5] mfd: asic3: Remove .set_pwr() callback
Date: Wed, 28 Aug 2013 09:36:39 +0200
Message-ID: <4590364.P8qlcBVRgM@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <000301cea3b2$c06f2a20$414d7e60$%han@samsung.com>
References: <000301cea3b2$c06f2a20$414d7e60$%han@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,

Thank you for the patch.

On Wednesday 28 August 2013 14:52:16 Jingoo Han wrote:
> Since 3af9d15 "mmc: tmio-mmc: Remove .set_pwr() callback from
> platform data", .set_pwr() callback is removed from platform data.
> Thus, .set_pwr() is not used anymore. Also, this patch fixes
> the following build error and warning.
> 
> drivers/mfd/asic3.c:724:2: error: unknown field 'set_pwr' specified in
> initializer drivers/mfd/asic3.c:724:2: warning: initialization makes
> integer from pointer without a cast [enabled by default]
> drivers/mfd/asic3.c:724:2: warning: (near initialization for
> 'asic3_mmc_data.capabilities' [enabled by default]

My bad, it looks like I've overlooked a few users of the .set_pwr() field :-/ 
Sorry about that.

> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Ian Molton <ian.molton@collabora.co.uk>
> Cc: Chris Ball <cjb@laptop.org>
> ---
>  drivers/mfd/asic3.c |    8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
> index fa22154..7a6f713 100644
> --- a/drivers/mfd/asic3.c
> +++ b/drivers/mfd/asic3.c
> @@ -705,13 +705,6 @@ static struct mfd_cell asic3_cell_ds1wm = {
>  	.resources     = ds1wm_resources,
>  };
> 
> -static void asic3_mmc_pwr(struct platform_device *pdev, int state)
> -{
> -	struct asic3 *asic = dev_get_drvdata(pdev->dev.parent);
> -
> -	tmio_core_mmc_pwr(asic->tmio_cnf, 1 - asic->bus_shift, state);
> -}
> -

I don't think blindly removing the function is the right fix, as it seems to 
be needed. Looking at the whole series, I believe we should just revert 
3af9d15 "mmc: tmio-mmc: Remove .set_pwr() callback from platform data" 
instead.

>  static void asic3_mmc_clk_div(struct platform_device *pdev, int state)
>  {
>  	struct asic3 *asic = dev_get_drvdata(pdev->dev.parent);
> @@ -721,7 +714,6 @@ static void asic3_mmc_clk_div(struct platform_device
> *pdev, int state)
> 
>  static struct tmio_mmc_data asic3_mmc_data = {
>  	.hclk           = 24576000,
> -	.set_pwr        = asic3_mmc_pwr,
>  	.set_clk_div    = asic3_mmc_clk_div,
>  };

-- 
Regards,

Laurent Pinchart

