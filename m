Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab3K0NQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 08:16:39 -0500
Received: from mail-yh0-f43.google.com ([209.85.213.43]:61600 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab3K0NQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 08:16:35 -0500
Date: Wed, 27 Nov 2013 13:16:26 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v4 4/5] regulator: max14577: Add regulator driver for
 Maxim 14577
Message-ID: <20131127131626.GH3296@lee--X1>
References: <1385135469-27044-1-git-send-email-k.kozlowski@samsung.com>
 <1385135469-27044-5-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1385135469-27044-5-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> MAX14577 chip is a multi-function device which includes MUIC,
> charger and voltage regulator. The driver is located in drivers/mfd.
> 
> This patch adds regulator driver for MAX14577 chip. There are two
> regulators in this chip:
> 1. Safeout LDO with constant voltage output of 4.9V. It can be only
>    enabled or disabled.
> 2. Current regulator for the charger. It provides current from 90mA up
>    to 950mA.
> Driver supports Device Tree.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/mfd/max14577.c       |    3 +-
>  drivers/regulator/Kconfig    |    7 ++
>  drivers/regulator/Makefile   |    1 +
>  drivers/regulator/max14577.c |  268 ++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 278 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/regulator/max14577.c
> 
> diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
> index 94b766d..d841f2a 100644
> --- a/drivers/mfd/max14577.c
> +++ b/drivers/mfd/max14577.c
> @@ -26,7 +26,8 @@
>  
>  static struct mfd_cell max14577_devs[] = {
>  	{ .name = "max14577-muic", },
> -	{ .name = "max14577-regulator", },
> +	{ .name = "max14577-regulator",
> +		.of_compatible = "maxim,max14577-regulator", },
>  	{ .name = "max14577-charger", },
>  };

If you separate this patch out and make it look 'normal' i.e. sort out
the indenting, I'll apply it. Instead of this randomness, I expect to
see something like: 

> +	 {
> +	        .name = "max14577-regulator",
> +	        .of_compatible = "maxim,max14577-regulator", 
> +	 },


-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
