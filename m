Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473AbaA1GdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 01:33:15 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:49905 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaA1GdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 01:33:13 -0500
Date: Mon, 27 Jan 2014 22:33:08 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Manish Badarkhe <badarkhe.manish@gmail.com>
Cc: linux-omap@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        broonie@kernel.org, lgirdwood@gmail.com
Subject: Re: [PATCH V2] regulator: fixed: update to devm_* API
Message-ID: <20140128063308.GA5965@core.coreip.homeip.net>
References: <1390878720-8676-1-git-send-email-badarkhe.manish@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390878720-8676-1-git-send-email-badarkhe.manish@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manish,

On Tue, Jan 28, 2014 at 08:42:00AM +0530, Manish Badarkhe wrote:
> Update the code to use devm_* API so that driver core will manage
> resources.
> 
> Signed-off-by: Manish Badarkhe <badarkhe.manish@gmail.com>
> ---
> Changes since V1:
> 1. Updated driver to use "devm_kzalloc" to "kstrdup".
> 2. Updated commit message.
> 
> Not tested on any board.
> 
> :100644 100644 5ea64b9... e9763a4... M	drivers/regulator/fixed.c
>  drivers/regulator/fixed.c |   42 ++++++++++++------------------------------
>  1 file changed, 12 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
> index 5ea64b9..e9763a4 100644
> --- a/drivers/regulator/fixed.c
> +++ b/drivers/regulator/fixed.c
> @@ -132,15 +132,15 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
>  			       GFP_KERNEL);
>  	if (drvdata == NULL) {
>  		dev_err(&pdev->dev, "Failed to allocate device data\n");
> -		ret = -ENOMEM;
> -		goto err;
> +		return -ENOMEM;
>  	}
>  
> -	drvdata->desc.name = kstrdup(config->supply_name, GFP_KERNEL);
> +	drvdata->desc.name = devm_kzalloc(&pdev->dev,
> +					  strlen(config->supply_name) + 1,
> +					  GFP_KERNEL);
>  	if (drvdata->desc.name == NULL) {
>  		dev_err(&pdev->dev, "Failed to allocate supply name\n");
> -		ret = -ENOMEM;
> -		goto err;
> +		return -ENOMEM;
>  	}

Umm, I am fairly certain that devm_kzalloc() can't be used as a
substitute for kstrdup, at least not without accompanying memcpy.

Thanks.

-- 
Dmitry
