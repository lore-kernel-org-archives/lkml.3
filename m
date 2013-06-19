Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934361Ab3FSLXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 07:23:48 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48227 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934067Ab3FSLXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 07:23:47 -0400
Message-ID: <51C19498.8090807@ti.com>
Date: Wed, 19 Jun 2013 16:53:04 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Philip Avinash <avinashphilip@ti.com>
CC: <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <grant.likely@secretlab.ca>, <linus.walleij@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/7] gpio: davinci: move to platform device
References: <1371202532-14628-1-git-send-email-avinashphilip@ti.com> <1371202532-14628-3-git-send-email-avinashphilip@ti.com>
In-Reply-To: <1371202532-14628-3-git-send-email-avinashphilip@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/14/2013 3:05 PM, Philip Avinash wrote:
> From: KV Sujith <sujithkv@ti.com>
> 
> Modify GPIO Davinci driver to be compliant to standard platform drivers.
> The driver did not have platform driver structure or a probe. Instead,
> had a davinci_gpio_setup() function which is called in the pure_init
> sequence. The function also had dependency on davinci_soc_info structure
> of the corresponding platform. For Device Tree(DT) implementation, we
> need to get rid of the dependency on the davinci_soc_info structure.
> Hence as a first stage of DT conversion, we implement a probe. Future
> commits shall modify the probe to read platform related data from DT.
> 
> - Add platform_driver structure and driver register function for davinci
>   GPIO driver. The driver registration is made to happen in
>   postcore_initcall. This is required since machine init functions like
>   da850_lcd_hw_init() make use of GPIO.
> - Convert the davinci_gpio_setup() to davinci_gpio_probe().
> - Remove access of members in soc_info structure. Instead, relevant data
>   are taken from davinci_gpio_platform_data structure pointed by
>   pdev->dev.platform_data.
> - Change clk_get() to devm_clk_get() as devm_clk_get() is a device
>   managed function and makes error handling simpler.
> - Change pr_err to dev_err for ngpio error reporting.

s/ngpio/gpio

> - Arrange include files in alphabetical order

Doesn't happen in this patch.

> - Add struct davinci_gpio_platform_data davinci for gpio module.
> 
> Signed-off-by: KV Sujith <sujithkv@ti.com>
> [avinashphilip@ti.com: Move global definition for "struct
> davinci_gpio_controller" variable to local in probe and set it as driver
> data.]
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Sekhar Nori <nsekhar@ti.com>
> ---

> diff --git a/arch/arm/mach-davinci/include/mach/gpio-davinci.h b/arch/arm/mach-davinci/include/mach/gpio-davinci.h
> index 1fdd1fd..b325a1d 100644
> --- a/arch/arm/mach-davinci/include/mach/gpio-davinci.h
> +++ b/arch/arm/mach-davinci/include/mach/gpio-davinci.h
> @@ -60,6 +60,8 @@ struct davinci_gpio_controller {
>  	void __iomem		*set_data;
>  	void __iomem		*clr_data;
>  	void __iomem		*in_data;
> +	int			gpio_unbanked;

You don't really use this member in this patch. You should add it in the
patch you need it in.

I fixed these issues locally and pushed this patch to my v3.11/gpio branch.

Thanks,
Sekhar
