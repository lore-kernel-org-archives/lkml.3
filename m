Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab3LEUK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 15:10:29 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:57725 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab3LEUKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 15:10:25 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH 2/2] regulator: gpio: Warn if an invalid regulator-type is supplied
Date: Thu, 05 Dec 2013 21:10:31 +0100
Message-ID: <66015321.Q31GikVXiU@avalon>
User-Agent: KMail/4.10.5 (Linux/3.10.17-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1386270722-13962-2-git-send-email-broonie@kernel.org>
References: <1386270722-13962-1-git-send-email-broonie@kernel.org> <1386270722-13962-2-git-send-email-broonie@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Thank you for the patch.

On Thursday 05 December 2013 19:12:02 Mark Brown wrote:
> From: Mark Brown <broonie@linaro.org>
> 
> Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Mark Brown <broonie@linaro.org>

I believe you could squash this patch with the one you've previously posted 
that makes the property optional. For the result,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/regulator/gpio-regulator.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/regulator/gpio-regulator.c
> b/drivers/regulator/gpio-regulator.c index 13ec94d984ca..c0a1d00b78c9
> 100644
> --- a/drivers/regulator/gpio-regulator.c
> +++ b/drivers/regulator/gpio-regulator.c
> @@ -210,6 +210,9 @@ of_get_gpio_regulator_config(struct device *dev, struct
> device_node *np) config->type = REGULATOR_VOLTAGE;
>  		else if (!strncmp("current", regtype, 7))
>  			config->type = REGULATOR_CURRENT;
> +		else
> +			dev_warn(dev, "Unknown regulator-type '%s'\n",
> +				 regtype);
>  	}
> 
>  	return config;
-- 
Regards,

Laurent Pinchart

