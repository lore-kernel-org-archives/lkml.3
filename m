Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab3DQFfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 01:35:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56186 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819Ab3DQFff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 01:35:35 -0400
Date: Wed, 17 Apr 2013 07:35:31 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Axel Lin <axel.lin@ingics.com>
cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: as3711: Use a static of_regulator_match table
 for of_regulator_match
In-Reply-To: <1366166245.9682.1.camel@phoenix>
Message-ID: <Pine.LNX.4.64.1304170729080.12878@axis700.grange>
References: <1366166245.9682.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:5B/Y7lH2OimtJTnsuy6TgMiqj+JwiEs4Xi0vFAXrb1S
 aRYXEiboh6MKqUGJtOjzATa/2UcuCDoemlm1gOqVlsjZ9twAWq
 2Iqe+YaQrohQ712/ef8eZjAm2+FUq0FJY6zYqOz72qtfarR+gu
 hEEy2J/o45mLnR5TKUMYwcPadxgAMNt30U1+Gsq+stAMwDK6Z1
 vqkXp8wXoq+nZIBh0zcjLD4OW1wLWOigZs496ZJh84dAvnXTCe
 Y7cX/kxwHMo7lZGo2b1wQ3uM9S/5ZpmKkanVcotUrIvDHr+pxg
 2mIuMmAEPXO7UKUp1gRiQN1jUMszAUrimLk+rZpZTweTchR3ob
 b36iMJDy7mBFsmnaNkYmFn9OhU5PGXDBID/VMB7vIWFl2MdKn0
 jWhFm7qz0eNnQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel

Thanks for the patch

On Wed, 17 Apr 2013, Axel Lin wrote:

> The same table can be used for multiple instance of pdev, so we don't need to
> allocate memory for of_regulator_match table per pdev.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/regulator/as3711-regulator.c |   46 ++++++++++++++--------------------
>  1 file changed, 19 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/regulator/as3711-regulator.c b/drivers/regulator/as3711-regulator.c
> index 0539b3e..dd1a089 100644
> --- a/drivers/regulator/as3711-regulator.c
> +++ b/drivers/regulator/as3711-regulator.c
> @@ -278,52 +278,44 @@ static struct as3711_regulator_info as3711_reg_info[] = {
>  
>  #define AS3711_REGULATOR_NUM ARRAY_SIZE(as3711_reg_info)
>  
> -static const char *as3711_regulator_of_names[AS3711_REGULATOR_NUM] = {
> -	[AS3711_REGULATOR_SD_1] = "sd1",
> -	[AS3711_REGULATOR_SD_2] = "sd2",
> -	[AS3711_REGULATOR_SD_3] = "sd3",
> -	[AS3711_REGULATOR_SD_4] = "sd4",
> -	[AS3711_REGULATOR_LDO_1] = "ldo1",
> -	[AS3711_REGULATOR_LDO_2] = "ldo2",
> -	[AS3711_REGULATOR_LDO_3] = "ldo3",
> -	[AS3711_REGULATOR_LDO_4] = "ldo4",
> -	[AS3711_REGULATOR_LDO_5] = "ldo5",
> -	[AS3711_REGULATOR_LDO_6] = "ldo6",
> -	[AS3711_REGULATOR_LDO_7] = "ldo7",
> -	[AS3711_REGULATOR_LDO_8] = "ldo8",
> +static struct of_regulator_match as3711_regulator_matches[] = {
> +	{ .name = "sd1" },
> +	{ .name = "sd2" },
> +	{ .name = "sd3" },
> +	{ .name = "sd4" },
> +	{ .name = "ldo1" },
> +	{ .name = "ldo2" },
> +	{ .name = "ldo3" },
> +	{ .name = "ldo4" },
> +	{ .name = "ldo5" },
> +	{ .name = "ldo6" },
> +	{ .name = "ldo7" },
> +	{ .name = "ldo8" },

Please keep explicit indices to match this array's members to the 
as3711_reg_info[] array.

>  };
>  
>  static int as3711_regulator_parse_dt(struct device *dev,
>  				struct device_node **of_node, const int count)
>  {
>  	struct as3711_regulator_pdata *pdata = dev_get_platdata(dev);
> -	struct device_node *regulators =
> -		of_find_node_by_name(dev->parent->of_node, "regulators");
> -	struct of_regulator_match *matches, *match;
> +	struct device_node *regulators;
> +	struct of_regulator_match *match;
>  	int ret, i;
>  
> +	regulators = of_find_node_by_name(dev->parent->of_node, "regulators");

What was wrong with the original code? I don't see a difference, this 
seems to be an unrelated stylistic change, please, don't do this.

>  	if (!regulators) {
>  		dev_err(dev, "regulator node not found\n");
>  		return -ENODEV;
>  	}
>  
> -	matches = devm_kzalloc(dev, sizeof(*matches) * count, GFP_KERNEL);
> -	if (!matches)
> -		return -ENOMEM;
> -
> -	for (i = 0, match = matches; i < count; i++, match++) {
> -		match->name = as3711_regulator_of_names[i];
> -		match->driver_data = as3711_reg_info + i;

This is a separate change. I was probably copy-pasting this parsing from 
some other driver and didn't realise, that .driver_data isn't actually 
used. And that was the reason why I copied the array at run-time. I won't 
play a patch-police here, asking you to split this into a separate patch, 
but please, could you at least make a remark in the commit message, 
confirming my understanding. Or maybe I'm wrong and .driver_data is 
needed? Then the whole your patch might not be right.

> -	}
> -
> -	ret = of_regulator_match(dev->parent, regulators, matches, count);
> +	ret = of_regulator_match(dev->parent, regulators,
> +				 as3711_regulator_matches, count);
>  	of_node_put(regulators);
>  	if (ret < 0) {
>  		dev_err(dev, "Error parsing regulator init data: %d\n", ret);
>  		return ret;
>  	}
>  
> -	for (i = 0, match = matches; i < count; i++, match++)
> +	for (i = 0, match = as3711_regulator_matches; i < count; i++, match++)
>  		if (match->of_node) {
>  			pdata->init_data[i] = match->init_data;
>  			of_node[i] = match->of_node;
> -- 
> 1.7.10.4

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
