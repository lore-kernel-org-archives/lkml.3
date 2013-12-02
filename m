Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab3LBK71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 05:59:27 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:56499 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab3LBK70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 05:59:26 -0500
Date: Mon, 2 Dec 2013 10:59:18 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        Balaji Rao <balajirrao@openmoko.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFT][PATCH] mfd: pcf50633: Correct device name for pcf50633
 regulator
Message-ID: <20131202105918.GA31626@lee--X1>
References: <1385785263.24696.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1385785263.24696.2.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Nov 2013, Axel Lin wrote:

> Change the device name of the regulator function to the one chosen for
> MODULE_ALIAS. This fixes kernel auto-module loading for the regulator function.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
> Hi,
> I don't have the hardware to test, but I think this needs fix.
> We have a similar fix in
> commit ec8da805c43a "mfd: tps6586x: correct device name of the regulator cell".
> 
>  drivers/mfd/pcf50633-core.c            | 2 +-
>  drivers/regulator/pcf50633-regulator.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Patch looks fine to me and I can't fine any other instances of the
name.

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
> index 6841d68..41ab5e3 100644
> --- a/drivers/mfd/pcf50633-core.c
> +++ b/drivers/mfd/pcf50633-core.c
> @@ -245,7 +245,7 @@ static int pcf50633_probe(struct i2c_client *client,
>  	for (i = 0; i < PCF50633_NUM_REGULATORS; i++) {
>  		struct platform_device *pdev;
>  
> -		pdev = platform_device_alloc("pcf50633-regltr", i);
> +		pdev = platform_device_alloc("pcf50633-regulator", i);
>  		if (!pdev) {
>  			dev_err(pcf->dev, "Cannot create regulator %d\n", i);
>  			continue;
> diff --git a/drivers/regulator/pcf50633-regulator.c b/drivers/regulator/pcf50633-regulator.c
> index d7da1c1..134f90e 100644
> --- a/drivers/regulator/pcf50633-regulator.c
> +++ b/drivers/regulator/pcf50633-regulator.c
> @@ -105,7 +105,7 @@ static int pcf50633_regulator_probe(struct platform_device *pdev)
>  
>  static struct platform_driver pcf50633_regulator_driver = {
>  	.driver = {
> -		.name = "pcf50633-regltr",
> +		.name = "pcf50633-regulator",
>  	},
>  	.probe = pcf50633_regulator_probe,
>  };

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
