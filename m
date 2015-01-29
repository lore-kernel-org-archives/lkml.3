Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762269AbbA2K1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:27:22 -0500
Received: from mail-qg0-f54.google.com ([209.85.192.54]:49176 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758001AbbA2K1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 05:27:17 -0500
MIME-Version: 1.0
In-Reply-To: <1422446052-2323-1-git-send-email-jszhang@marvell.com>
References: <1422446052-2323-1-git-send-email-jszhang@marvell.com>
Date: Thu, 29 Jan 2015 11:27:16 +0100
Message-ID: <CAPDyKFo608ndc3FUTjYr+e9WH5fEeiO47vhuNNLs0Khfri9CDA@mail.gmail.com>
Subject: Re: [PATCH] mmc: sdhci-pxav3: fix setting of pdata->clk_delay_cycles
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Jisheng Zhang <jszhang@marvell.com>
Cc: Chris Ball <chris@printf.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 January 2015 at 12:54, Jisheng Zhang <jszhang@marvell.com> wrote:
> Current code checks "clk_delay_cycles > 0" to know whether the optional
> "mrvl,clk_delay_cycles" is set or not. But of_property_read_u32() doesn't
> touch clk_delay_cycles if the property is not set. And type of
> clk_delay_cycles is u32, so we may always set pdata->clk_delay_cycles as a
> random value.
>
> This patch fix this problem by check the return value of of_property_read_u32()
> to know whether the optional clk-delay-cycles is set or not.
>
> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
> Cc: <stable@vger.kernel.org> # v3.6+

Thanks! Applied for next.

Kind regards
Uffe

> ---
>  drivers/mmc/host/sdhci-pxav3.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mmc/host/sdhci-pxav3.c b/drivers/mmc/host/sdhci-pxav3.c
> index c5db5d2..f1c6362 100644
> --- a/drivers/mmc/host/sdhci-pxav3.c
> +++ b/drivers/mmc/host/sdhci-pxav3.c
> @@ -268,8 +268,8 @@ static struct sdhci_pxa_platdata *pxav3_get_mmc_pdata(struct device *dev)
>         if (!pdata)
>                 return NULL;
>
> -       of_property_read_u32(np, "mrvl,clk-delay-cycles", &clk_delay_cycles);
> -       if (clk_delay_cycles > 0)
> +       if (!of_property_read_u32(np, "mrvl,clk-delay-cycles",
> +                                 &clk_delay_cycles))
>                 pdata->clk_delay_cycles = clk_delay_cycles;
>
>         return pdata;
> --
> 2.1.4
>
