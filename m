Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbaG1HDC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 03:03:02 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:55934 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbaG1HC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 03:02:59 -0400
Date: Mon, 28 Jul 2014 08:02:54 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, broonie@kernel.org, lgirdwood@gmail.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6 RESEND] mfd: arizona: Add missing handling for ISRC3
 under/overclocked
Message-ID: <20140728070254.GI5273@lee--X1>
References: <1405419710-14789-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1405419710-14789-6-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405419710-14789-6-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2014, Charles Keepax wrote:

> Some parts have a third ISRC, this patch adds handling for the under and
> overclocked interrupts from this ISRC.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/arizona-core.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
> index e9c3563..ab5cf9a 100644
> --- a/drivers/mfd/arizona-core.c
> +++ b/drivers/mfd/arizona-core.c
> @@ -123,6 +123,8 @@ static irqreturn_t arizona_underclocked(int irq, void *data)
>  		dev_err(arizona->dev, "AIF2 underclocked\n");
>  	if (val & ARIZONA_AIF1_UNDERCLOCKED_STS)
>  		dev_err(arizona->dev, "AIF1 underclocked\n");
> +	if (val & ARIZONA_ISRC3_UNDERCLOCKED_STS)
> +		dev_err(arizona->dev, "ISRC3 underclocked\n");
>  	if (val & ARIZONA_ISRC2_UNDERCLOCKED_STS)
>  		dev_err(arizona->dev, "ISRC2 underclocked\n");
>  	if (val & ARIZONA_ISRC1_UNDERCLOCKED_STS)
> @@ -192,6 +194,8 @@ static irqreturn_t arizona_overclocked(int irq, void *data)
>  		dev_err(arizona->dev, "ASRC sync WARP overclocked\n");
>  	if (val[1] & ARIZONA_ADSP2_1_OVERCLOCKED_STS)
>  		dev_err(arizona->dev, "DSP1 overclocked\n");
> +	if (val[1] & ARIZONA_ISRC3_OVERCLOCKED_STS)
> +		dev_err(arizona->dev, "ISRC3 overclocked\n");
>  	if (val[1] & ARIZONA_ISRC2_OVERCLOCKED_STS)
>  		dev_err(arizona->dev, "ISRC2 overclocked\n");
>  	if (val[1] & ARIZONA_ISRC1_OVERCLOCKED_STS)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
