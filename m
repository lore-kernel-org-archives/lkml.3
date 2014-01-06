Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbaAFLw4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 06:52:56 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:55040 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbaAFLwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 06:52:54 -0500
Date: Mon, 6 Jan 2014 11:52:49 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 6/7] mfd: pm8921: Add DT match table
Message-ID: <20140106115249.GD30156@lee--X1>
References: <1387831563-13535-1-git-send-email-sboyd@codeaurora.org>
 <1387831563-13535-7-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1387831563-13535-7-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Allow this driver to probe based on devicetree.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/mfd/pm8921-core.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/pm8921-core.c b/drivers/mfd/pm8921-core.c
> index d13cb6e..290f0da 100644
> --- a/drivers/mfd/pm8921-core.c
> +++ b/drivers/mfd/pm8921-core.c
> @@ -420,6 +420,13 @@ static const struct regmap_config ssbi_regmap_config = {
>  	.reg_write = ssbi_reg_write
>  };
>  
> +static const struct of_device_id pm8921_id_table[] = {
> +	{ .compatible = "qcom,pm8058", },
> +	{ .compatible = "qcom,pm8921", },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, pm8921_id_table);
> +
>  static int pm8921_probe(struct platform_device *pdev)
>  {
>  	struct pm8921 *pmic;
> @@ -429,7 +436,6 @@ static int pm8921_probe(struct platform_device *pdev)
>  	unsigned int irq;
>  	u32 rev;
>  
> -

Sneaky!

>  	irq = platform_get_irq(pdev, 0);
>  	if (irq < 0)
>  		return irq;
> @@ -494,6 +500,7 @@ static struct platform_driver pm8921_driver = {
>  	.driver		= {
>  		.name	= "pm8921-core",
>  		.owner	= THIS_MODULE,
> +		.of_match_table = pm8921_id_table,
>  	},
>  };

Patch fine:
  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
