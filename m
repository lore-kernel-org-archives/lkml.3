Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966049Ab3DQIGx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 04:06:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:62827 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965847Ab3DQIGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 04:06:50 -0400
Date: Wed, 17 Apr 2013 10:06:45 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Axel Lin <axel.lin@ingics.com>
cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] regulator: as3711: Use a static of_regulator_match
 table for of_regulator_match
In-Reply-To: <1366185682.26712.1.camel@phoenix>
Message-ID: <Pine.LNX.4.64.1304171005310.12878@axis700.grange>
References: <1366185682.26712.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:6JPXSTKPcrPDUVKrAZZvDeDGV3tGSnDqwkUqYEtc8UF
 L9AsoIWfWZ+tRMpXkdNgZxbj5+6Zfz1buTbXhF/xiE2t398UuZ
 AE6ys4aY5Knt4tcGVAw2VnkCidVNpE62aiAb98d792FeHpVBst
 kWCoh3ez5lL2PjR+corllkzmV+Qk2yNBs+S5BkvetyweTY5GZa
 h2GWTwsmIyZjxZqxJgo3PqqvgsHO2pjvKgTECHNvZfx0kpAJ8C
 /Euyv0CDLfZzrgdx5ybDHXkeaiBJ5bhfhWgKx+90dahiUMqJcI
 Ca99dlq6V5geHWMeN3zPS48YrteiQxmx57fffJkKPblq0l8efJ
 EUS8HiZGX8GPd1BN3KG5J4B1g/vmXIHt0NMz8P20Nlp7zdIc//
 1EGr/2yz53EmQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Apr 2013, Axel Lin wrote:

> The same table can be used for multiple instance of pdev, so we don't need to
> allocate memory for of_regulator_match table per pdev.
> 
> match->driver_data points to the corresponding entry of as3711_reg_info,
> however it is not used in current code, thus this patch does not set
> driver_data in the of_regulator_match table.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

> ---
>  drivers/regulator/as3711-regulator.c |   43 ++++++++++++++--------------------
>  1 file changed, 18 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/regulator/as3711-regulator.c b/drivers/regulator/as3711-regulator.c
> index 0539b3e..3da6bd6 100644
> --- a/drivers/regulator/as3711-regulator.c
> +++ b/drivers/regulator/as3711-regulator.c
> @@ -278,19 +278,20 @@ static struct as3711_regulator_info as3711_reg_info[] = {
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
> +static struct of_regulator_match
> +as3711_regulator_matches[AS3711_REGULATOR_NUM] = {
> +	[AS3711_REGULATOR_SD_1] = { .name = "sd1" },
> +	[AS3711_REGULATOR_SD_2] = { .name = "sd2" },
> +	[AS3711_REGULATOR_SD_3] = { .name = "sd3" },
> +	[AS3711_REGULATOR_SD_4] = { .name = "sd4" },
> +	[AS3711_REGULATOR_LDO_1] = { .name = "ldo1" },
> +	[AS3711_REGULATOR_LDO_2] = { .name = "ldo2" },
> +	[AS3711_REGULATOR_LDO_3] = { .name = "ldo3" },
> +	[AS3711_REGULATOR_LDO_4] = { .name = "ldo4" },
> +	[AS3711_REGULATOR_LDO_5] = { .name = "ldo5" },
> +	[AS3711_REGULATOR_LDO_6] = { .name = "ldo6" },
> +	[AS3711_REGULATOR_LDO_7] = { .name = "ldo7" },
> +	[AS3711_REGULATOR_LDO_8] = { .name = "ldo8" },
>  };
>  
>  static int as3711_regulator_parse_dt(struct device *dev,
> @@ -299,7 +300,7 @@ static int as3711_regulator_parse_dt(struct device *dev,
>  	struct as3711_regulator_pdata *pdata = dev_get_platdata(dev);
>  	struct device_node *regulators =
>  		of_find_node_by_name(dev->parent->of_node, "regulators");
> -	struct of_regulator_match *matches, *match;
> +	struct of_regulator_match *match;
>  	int ret, i;
>  
>  	if (!regulators) {
> @@ -307,23 +308,15 @@ static int as3711_regulator_parse_dt(struct device *dev,
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

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
