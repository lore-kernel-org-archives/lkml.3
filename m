Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbaFRPwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:52:08 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56682 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbaFRPwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:52:06 -0400
Message-ID: <53A1B58C.6070508@ti.com>
Date: Wed, 18 Jun 2014 10:51:40 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Felipe Balbi <balbi@ti.com>, <lgirdwood@gmail.com>, <broonie@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Keerthy <j-keerthy@ti.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] regulators: TPS65218: Add the missing of_node assignment
 in probe
References: <1403104668-32316-1-git-send-email-balbi@ti.com>
In-Reply-To: <1403104668-32316-1-git-send-email-balbi@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nit pick:
s/regulators: TPS65218:/regulators: tps65218:/

On 06/18/2014 10:17 AM, Felipe Balbi wrote:
> From: Keerthy <j-keerthy@ti.com>
> 
> Add the missing of_node assignment in probe.
Hmm... I think an explanation of the type below might be nice:

config.of_node is used to populate the regulator_dev->dev.of_node as
part of registration. this is used for consumer supply match to the
right regulator device such as in regulator_dev_lookup.

not populating config.of_node results in inability to use the
regulator node as a supply in device tree.


> 
> Cc: <stable@vger.kernel.org> # v3.15

Fixes: 90e7d5262796 (regulator: tps65218: Add Regulator driver for
TPS65218 PMIC)

?
> Signed-off-by: Keerthy <j-keerthy@ti.com>
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
>  drivers/regulator/tps65218-regulator.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/regulator/tps65218-regulator.c b/drivers/regulator/tps65218-regulator.c
> index 69b4b77..edbc46e 100644
> --- a/drivers/regulator/tps65218-regulator.c
> +++ b/drivers/regulator/tps65218-regulator.c
> @@ -240,6 +240,7 @@ static int tps65218_regulator_probe(struct platform_device *pdev)
>  	config.init_data = init_data;
>  	config.driver_data = tps;
>  	config.regmap = tps->regmap;
> +	config.of_node = pdev->dev.of_node;
>  
>  	rdev = devm_regulator_register(&pdev->dev, &regulators[id], &config);
>  	if (IS_ERR(rdev)) {
> 

otherwise,
Acked-by: Nishanth Menon <nm@ti.com>
-- 
Regards,
Nishanth Menon
