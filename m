Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab3K0OAD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:00:03 -0500
Received: from mail-yh0-f54.google.com ([209.85.213.54]:38931 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab3K0N7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 08:59:55 -0500
Date: Wed, 27 Nov 2013 13:59:47 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v5 1/2] regulator: max14577: Add regulator driver for
 Maxim 14577
Message-ID: <20131127135947.GL3296@lee--X1>
References: <1385559982-32039-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1385559982-32039-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Nov 2013, Krzysztof Kozlowski wrote:

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
>  drivers/mfd/max14577.c       |   13 +-
>  drivers/regulator/Kconfig    |    7 ++
>  drivers/regulator/Makefile   |    1 +
>  drivers/regulator/max14577.c |  269 ++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 287 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/regulator/max14577.c
> 
> diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
> index 94b766d..9af46c2 100644
> --- a/drivers/mfd/max14577.c
> +++ b/drivers/mfd/max14577.c
> @@ -25,9 +25,16 @@
>  #include <linux/mfd/max14577-private.h>
>  
>  static struct mfd_cell max14577_devs[] = {
> -	{ .name = "max14577-muic", },
> -	{ .name = "max14577-regulator", },
> -	{ .name = "max14577-charger", },
> +	{
> +		.name = "max14577-muic",
> +	},
> +	{
> +		.name = "max14577-regulator",
> +		.of_compatible = "maxim,max14577-regulator",
> +	},
> +	{
> +		.name = "max14577-charger",
> +	},
>  };

Still it still part of the regulator patch.

Can you pull the code above into a separate patch please?

Also, there's no requirement to open out all of the one liners, just
the entry where you're using two properties.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
