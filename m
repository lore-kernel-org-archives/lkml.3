Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab3LEAoi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 19:44:38 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:51676 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756000Ab3LEAof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 19:44:35 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH] regulator: gpio: Don't require a regulator-type property
Date: Thu, 05 Dec 2013 01:44:42 +0100
Message-ID: <1766701.HGqKkTj0sM@avalon>
User-Agent: KMail/4.10.5 (Linux/3.10.17-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1386203515-6815-1-git-send-email-broonie@kernel.org>
References: <1386203515-6815-1-git-send-email-broonie@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Thanks for the patch.

On Thursday 05 December 2013 00:31:55 Mark Brown wrote:
> From: Mark Brown <broonie@linaro.org>
> 
> Since essentially all GPIO controlled regulators are voltage regulators
> make the regulator-type property optional, defaulting to voltage.
> 
> Signed-off-by: Mark Brown <broonie@linaro.org>
> ---
> 
> Compile tested only.
> 
>  drivers/regulator/gpio-regulator.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/regulator/gpio-regulator.c
> b/drivers/regulator/gpio-regulator.c index 234960dc9607..13ec94d984ca
> 100644
> --- a/drivers/regulator/gpio-regulator.c
> +++ b/drivers/regulator/gpio-regulator.c
> @@ -203,17 +203,15 @@ of_get_gpio_regulator_config(struct device *dev,
> struct device_node *np) }
>  	config->nr_states = i;
> 
> +	config->type = REGULATOR_VOLTAGE;
>  	ret = of_property_read_string(np, "regulator-type", &regtype);
> -	if (ret < 0) {
> -		dev_err(dev, "Missing 'regulator-type' property\n");
> -		return ERR_PTR(-EINVAL);
> +	if (ret >= 0) {
> +		if (!strncmp("voltage", regtype, 7))
> +			config->type = REGULATOR_VOLTAGE;
> +		else if (!strncmp("current", regtype, 7))
> +			config->type = REGULATOR_CURRENT;

Should we warn or error in case of an unsupported value ?

>  	}
> 
> -	if (!strncmp("voltage", regtype, 7))
> -		config->type = REGULATOR_VOLTAGE;
> -	else if (!strncmp("current", regtype, 7))
> -		config->type = REGULATOR_CURRENT;
> -
>  	return config;
>  }
-- 
Regards,

Laurent Pinchart

