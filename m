Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934795AbaH0OLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 10:11:35 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:61453 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933802AbaH0OLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 10:11:34 -0400
Date: Wed, 27 Aug 2014 15:11:27 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Guodong Xu <guodong.xu@linaro.org>
Cc: sameo@linux.intel.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, grant.likely@linaro.org,
        khilman@linaro.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        zhangnian@huawei.com
Subject: Re: [PATCH 2/3] mfd: Add hi6421 PMIC core driver
Message-ID: <20140827141127.GA24579@lee--X1>
References: <1408973982-2072-1-git-send-email-guodong.xu@linaro.org>
 <1408973982-2072-3-git-send-email-guodong.xu@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1408973982-2072-3-git-send-email-guodong.xu@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This adds driver to support HiSilicon Hi6421 PMIC. Hi6421 includes multi-
> functions, such as regulators, codec, ADCs, Coulomb counter, etc.
> This driver includes core APIs _only_.
> 
> Drivers for individul components, like voltage regulators, are
> implemented in corresponding driver directories and files.
> 
> Registers in Hi6421 are memory mapped, so using regmap-mmio API.
> 
> Signed-off-by: Guodong Xu <guodong.xu@linaro.org>
> ---

The patch is missing version information normally indicated to in the
£SUBJECT line with a full description added here.  This looks like a
first submission, but we both know that it's not. 

>  drivers/mfd/Kconfig             |  13 +++++
>  drivers/mfd/Makefile            |   1 +
>  drivers/mfd/hi6421-pmic-core.c  | 112 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/hi6421-pmic.h |  42 +++++++++++++++
>  4 files changed, 168 insertions(+)
>  create mode 100644 drivers/mfd/hi6421-pmic-core.c
>  create mode 100644 include/linux/mfd/hi6421-pmic.h

[...]

> diff --git a/drivers/mfd/hi6421-pmic-core.c b/drivers/mfd/hi6421-pmic-core.c
> new file mode 100644
> index 0000000..c6cba8f
> --- /dev/null
> +++ b/drivers/mfd/hi6421-pmic-core.c
> @@ -0,0 +1,112 @@

[...]

> +#include <linux/device.h>
> +#include <linux/err.h>
> +#include <linux/mfd/core.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/regmap.h>
> +#include <linux/mfd/hi6421-pmic.h>
> +
> +static struct of_device_id of_hi6421_pmic_match_tbl[] = {
> +	{ .compatible = "hisilicon,hi6421-pmic", },
> +	{ },
> +};

Unless you're going to use this to of_match() on in future, this
should be down by the definition of 'struct platform_driver'.

> +static int hi6421_pmic_probe(struct platform_device *pdev)
> +{

[...]

> +	/* set over-current protection debounce 8ms */
> +	regmap_update_bits(pmic->regmap, HI6421_OCP_DEB_CTRL_REG,
> +		(HI6421_OCP_DEB_SEL_MASK | HI6421_OCP_EN_DEBOUNCE_MASK |
> +		 HI6421_OCP_AUTO_STOP_MASK),
> +		(HI6421_OCP_DEB_SEL_8MS | HI6421_OCP_EN_DEBOUNCE_ENABLE));

These might read a little better stacked and aligned.

> +	pmic->dev = &pdev->dev;

Can't you retrieve this via dev->parent?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
