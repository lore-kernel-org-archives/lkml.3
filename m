Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab3GQLw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 07:52:56 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:41552 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573Ab3GQLwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 07:52:55 -0400
Date: Wed, 17 Jul 2013 12:52:49 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH 1/2] mfd: wm8994: Remove duplicate check for active
 JACKDET
Message-ID: <20130717115249.GE3336@laptop>
References: <1374060037-18527-1-git-send-email-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1374060037-18527-1-git-send-email-broonie@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jul 2013, Mark Brown wrote:

> From: Mark Brown <broonie@linaro.org>
> 
> Probably the result of a mismerge or rebase failing to notice that the
> hunk had already been applied.
> 
> Signed-off-by: Mark Brown <broonie@linaro.org>
> ---
>  drivers/mfd/wm8994-core.c | 14 --------------
>  1 file changed, 14 deletions(-)
> 
> diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
> index 781115e..e8ecb8e 100644
> --- a/drivers/mfd/wm8994-core.c
> +++ b/drivers/mfd/wm8994-core.c
> @@ -245,20 +245,6 @@ static int wm8994_suspend(struct device *dev)
>  		break;
>  	}
>  
> -	switch (wm8994->type) {
> -	case WM1811:
> -		ret = wm8994_reg_read(wm8994, WM8994_ANTIPOP_2);
> -		if (ret < 0) {
> -			dev_err(dev, "Failed to read jackdet: %d\n", ret);
> -		} else if (ret & WM1811_JACKDET_MODE_MASK) {
> -			dev_dbg(dev, "CODEC still active, ignoring suspend\n");
> -			return 0;
> -		}
> -		break;
> -	default:
> -		break;
> -	}
> -
>  	/* Disable LDO pulldowns while the device is suspended if we
>  	 * don't know that something will be driving them. */
>  	if (!wm8994->ldo_ena_always_driven)

I don't see the duplicate?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
