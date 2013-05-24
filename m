Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab3EXLXk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 07:23:40 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:55913 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab3EXLXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 07:23:39 -0400
Date: Fri, 24 May 2013 12:23:33 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        broonie@kernel.org, linus.walleij@linaro.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com
Subject: Re: [PATCH] regulator: ab8500-ext: Don't register without
 initialisation data
Message-ID: <20130524112333.GW22683@gmail.com>
References: <1369226853-16978-1-git-send-email-lee.jones@linaro.org>
 <1369226853-16978-3-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1369226853-16978-3-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 May 2013, Lee Jones wrote:

> This patch fixes a bug introduced in the v3.10 merge window.
> 
> Some platforms will not want external registers. Rather than setting up
> lots of different clauses in the core ab8500 regulator driver not to
> call ab8500-ext init() we just won't pass the initialisation data from
> platform code. This patch checks for it and if it's missing, we won't
> register the external regulators.
> 
> Cc: Mark Brown <broonie@kernel.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/regulator/ab8500-ext.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
> index b4d4547..8421537 100644
> --- a/drivers/regulator/ab8500-ext.c
> +++ b/drivers/regulator/ab8500-ext.c
> @@ -334,6 +334,12 @@ int ab8500_ext_regulator_init(struct platform_device *pdev)
>  		return -EINVAL;
>  	}
>  
> +	/* have any external regulators been specified? */
> +	if (pdata->num_ext_regulator == 0) {
> +		dev_warn(&pdev->dev, "Not using external regulators\n");
> +		return 0;
> +	}
> +
>  	/* make sure the platform data has the correct size */
>  	if (pdata->num_ext_regulator != ARRAY_SIZE(ab8500_ext_regulator_info)) {
>  		dev_err(&pdev->dev, "Configuration error: size mismatch.\n");

Okay drop this patch, I have a better solution.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
