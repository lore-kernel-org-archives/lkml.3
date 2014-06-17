Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716AbaFQM0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 08:26:15 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:53548 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209AbaFQM0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 08:26:13 -0400
X-AuditID: cbfee61a-b7fef6d00000200b-ed-53a033e1c3f4
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kumar Gala <galak@codeaurora.org>
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] ata: Add Qualcomm ARM SoC AHCI SATA host controller
 driver
Date: Tue, 17 Jun 2014 14:25:21 +0200
Message-id: <14174621.WL9ndpHQ2Q@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1402676163-31574-1-git-send-email-galak@codeaurora.org>
References: <1402676163-31574-1-git-send-email-galak@codeaurora.org>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsVy+t9jAd1HxguCDa7fZLLof7OQ1WLT42us
	FhP3n2W3OLbjEZPF5V1z2Cx+LT/K6MDmcbmvl8lj06pONo/NS+o9Pm+SC2CJ4rJJSc3JLEst
	0rdL4Mq4+fgYS8F1zYrezXsYGxjfKHYxcnBICJhIrFsS28XICWSKSVy4t56ti5GLQ0hgEaPE
	tb6VLBBOC5PE0icXmUCq2ASsJCa2r2IEsUUEVCWWz90MVsQsMJ9RYvGDmcwgCWGBCIn2aY/B
	GliAii7v7mAF2cYroCXx7IEdSFhUwFNix/aVbCA2p4CrxO6N/WCtQgIuEqvXrAeL8woISvyY
	fI8FxGYWkJfYt38qK4StI7G/dRrbBEaBWUjKZiEpm4WkbAEj8ypG0dSC5ILipPRcQ73ixNzi
	0rx0veT83E2M4HB+JrWDcWWDxSFGAQ5GJR7eh7Lzg4VYE8uKK3MPMUpwMCuJ8JaILwgW4k1J
	rKxKLcqPLyrNSS0+xCjNwaIkznug1TpQSCA9sSQ1OzW1ILUIJsvEwSnVwFj4ZpkPp9GB1Rq3
	HRdOEX7FvFdEWaVN0fWk6GPPtokSe27PMbrRssfS8vrBuYtuNr60m7b3/bXJNxM2VKziU/rI
	IaH3QPa22FUFy96PDbHZZ9h2+bUben375y6y4kfN9QdJVUs88ib+XemssNnzlVn3m2OBbYc3
	8N1giHX1iLtno7jk/ZdLxycqsRRnJBpqMRcVJwIAhDVdP2MCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Friday, June 13, 2014 11:16:03 AM Kumar Gala wrote:
> Add support for the Qualcomm AHCI SATA controller that exists on several
> SoC and specifically the IPQ806x family of chips.  The IPQ806x SATA support
> requires the associated IPQ806x SATA PHY Driver to be enabled as well.
> 
> Signed-off-by: Kumar Gala <galak@codeaurora.org>
> ---
> v2:
> * Fixed MODULE_LICENSE to be GPL v2
> 
>  drivers/ata/Kconfig     | 10 ++++++
>  drivers/ata/Makefile    |  1 +
>  drivers/ata/ahci_qcom.c | 86 +++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 97 insertions(+)
>  create mode 100644 drivers/ata/ahci_qcom.c
> 
> diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
> index 7671dba..aa88648 100644
> --- a/drivers/ata/Kconfig
> +++ b/drivers/ata/Kconfig
> @@ -132,6 +132,16 @@ config AHCI_MVEBU
>  
>  	  If unsure, say N.
>  
> +config AHCI_QCOM
> +	tristate "Qualcomm AHCI SATA support"
> +	depends on ARCH_QCOM
> +	help
> +	  This option enables support for AHCI SATA controller
> +	  integrated into Qualcomm ARM SoC chipsets. For more
> +	  information please refer to http://www.qualcomm.com/chipsets.
> +
> +	  If unsure, say N.
> +
>  config AHCI_SUNXI
>  	tristate "Allwinner sunxi AHCI SATA support"
>  	depends on ARCH_SUNXI
> diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
> index 5a02aee..15401e9 100644
> --- a/drivers/ata/Makefile
> +++ b/drivers/ata/Makefile
> @@ -13,6 +13,7 @@ obj-$(CONFIG_SATA_HIGHBANK)	+= sata_highbank.o libahci.o
>  obj-$(CONFIG_AHCI_DA850)	+= ahci_da850.o libahci.o libahci_platform.o
>  obj-$(CONFIG_AHCI_IMX)		+= ahci_imx.o libahci.o libahci_platform.o
>  obj-$(CONFIG_AHCI_MVEBU)	+= ahci_mvebu.o libahci.o libahci_platform.o
> +obj-$(CONFIG_AHCI_QCOM)		+= ahci_qcom.o libahci.o libahci_platform.o
>  obj-$(CONFIG_AHCI_SUNXI)	+= ahci_sunxi.o libahci.o libahci_platform.o
>  obj-$(CONFIG_AHCI_ST)		+= ahci_st.o libahci.o libahci_platform.o
>  obj-$(CONFIG_AHCI_XGENE)	+= ahci_xgene.o libahci.o libahci_platform.o
> diff --git a/drivers/ata/ahci_qcom.c b/drivers/ata/ahci_qcom.c
> new file mode 100644
> index 0000000..bfb7a77
> --- /dev/null
> +++ b/drivers/ata/ahci_qcom.c
> @@ -0,0 +1,86 @@
> +/*
> + * Qualcomm ARM SoC AHCI SATA platform driver
> + *
> + * based on the AHCI SATA platform driver by Jeff Garzik and Anton Vorontsov
> + *
> + * Copyright (c) 2014, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/pm.h>
> +#include <linux/device.h>
> +#include <linux/platform_device.h>
> +#include <linux/libata.h>
> +#include <linux/ahci_platform.h>
> +#include "ahci.h"
> +
> +static const struct ata_port_info qcom_ahci_port_info = {
> +	.flags		= AHCI_FLAG_COMMON,
> +	.pio_mask	= ATA_PIO4,
> +	.udma_mask	= ATA_UDMA6,
> +	.port_ops	= &ahci_platform_ops,
> +};
> +
> +static int qcom_ahci_probe(struct platform_device *pdev)
> +{
> +	struct ahci_host_priv *hpriv;
> +	struct clk *rxoob_clk;
> +	int rc;
> +
> +	hpriv = ahci_platform_get_resources(pdev);
> +	if (IS_ERR(hpriv))
> +		return PTR_ERR(hpriv);
> +
> +	/* Try and set the rxoob clk to 100Mhz */
> +	rxoob_clk = of_clk_get_by_name(pdev->dev.of_node, "rxoob");
> +	if (IS_ERR(rxoob_clk))
> +		return PTR_ERR(rxoob_clk);
> +
> +	rc = clk_set_rate(rxoob_clk, 100000000);

Shouldn't the clk_prepare_enable() be called first?

> +	if (rc)
> +		return rc;

of_clk_get_by_name() gets an extra reference on the clock so clk_put()
should be called on failure.

> +	rc = ahci_platform_enable_resources(hpriv);
> +	if (rc)
> +		return rc;
> +
> +	rc = ahci_platform_init_host(pdev, hpriv, &qcom_ahci_port_info, 0, 0);
> +	if (rc)
> +		goto disable_resources;
> +
> +	return 0;
> +disable_resources:
> +	ahci_platform_disable_resources(hpriv);
> +	return rc;
> +}
> +
> +static const struct of_device_id qcom_ahci_of_match[] = {
> +	{ .compatible = "qcom,msm-ahci", },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, qcom_ahci_of_match);
> +
> +static struct platform_driver qcom_ahci_driver = {
> +	.probe = qcom_ahci_probe,
> +	.remove = ata_platform_remove_one,
> +	.driver = {
> +		.name = "qcom_ahci_qcom",
> +		.owner = THIS_MODULE,
> +		.of_match_table = qcom_ahci_of_match,
> +	},

This driver lacks PM suspend/resume support.  I assume that
the IPQ806x platform also doesn't support suspend/resume yet
(if so a comment in the driver code about this would be useful),
otherwise the driver should be fixed.

> +};
> +module_platform_driver(qcom_ahci_driver);
> +
> +MODULE_DESCRIPTION("Qualcomm AHCI SATA platform driver");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS("ahci:qcom");

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

