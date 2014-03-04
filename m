Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbaCDNtL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 08:49:11 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:15661 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757201AbaCDNtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 08:49:07 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-1d-5315d9d12375
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        DCG_UPD_stlinux_kernel@list.st.com, Tejun Heo <tj@kernel.org>,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH v3 3/3] ahci: st: Add support for ST's SATA IP
Date: Tue, 04 Mar 2014 14:48:54 +0100
Message-id: <4575362.nxyAcPCJSW@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <20140226144721.GP9195@lee--X1>
References: <1393328481-7251-1-git-send-email-lee.jones@linaro.org>
 <1393328481-7251-3-git-send-email-lee.jones@linaro.org>
 <20140226144721.GP9195@lee--X1>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t9jQd2LN0WDDQ49MbE4PHs7o8X9r0cZ
	LTY9vsZqcWzHIyaLy7vmsFn8Wn6U0YHNY9OqTjaPO9f2sHmcvHCSxWPzknqPz5vkAlijuGxS
	UnMyy1KL9O0SuDLOLvrMUvDVveL9yinMDYxvLLsYOTkkBEwkHq07wA5hi0lcuLeerYuRi0NI
	YDqjxO7D81khnBYmibNTJrGAVLEJWElMbF/F2MXIwSEioCJx7o05SA2zwBJGia6fr5lBaoQF
	nCTef/wHVs8ioCrxePsMJhCbV0BT4vDHzWC2qICnxI7tK9lAbE4BHYkzH96zQyybzyhx7+kt
	ZogGQYkfk++BDWIWkJfYt38qK4StJbF+53GmCYwCs5CUzUJSNgtJ2QJG5lWMoqkFyQXFSem5
	hnrFibnFpXnpesn5uZsYwcH9TGoH48oGi0OMAhyMSjy8M6aJBAuxJpYVV+YeYpTgYFYS4a26
	LhosxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdAq3WgkEB6YklqdmpqQWoRTJaJg1OqgdHu9THj
	1etVZ/+7tejQnEUnyrcqTOWfOPWtavpkXkWPszM6Vq24eOP13SkiFjo/rM/wVLxKmnrj5XUf
	3yUGMlFmMwVjr9wXWvtB9v3mX++8L62S2/rn2KR+r0C3j6umGf8/E2h5VtMxaerVLZX5WZf9
	wi7rrz69Yto1ozWcn1I+/uxY8/Npwt73fkosxRmJhlrMRcWJAL5K4vtqAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday, February 26, 2014 02:47:21 PM Lee Jones wrote:
> ahci: st: Add support for ST's SATA IP
> 
> Acked-by: Alexandre Torgue <alexandre.torgue@st.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
> index b4a9262..ee7a3dc 100644
> --- a/drivers/ata/Kconfig
> +++ b/drivers/ata/Kconfig
> @@ -97,6 +97,15 @@ config SATA_AHCI_PLATFORM
>  
>  	  If unsure, say N.
>  
> +config SATA_AHCI_ST

It would be better to name it just ACHI_ST for consistency with
existing config options (AHCI_IMX and AHCI_SUNXI).

> +	tristate "ST SATA support"

"ST AHCI SATA support"

> +	depends on SATA_AHCI_PLATFORM

There should be also dependency on ARCH_STI here.  We don't want this
driver to be available on other ARM architectures.

> +	select GENERIC_PHY

This doesn't belong here anylonger and should be removed.

> +	help
> +	  This option enables support for ST SATA controller.

ST AHCI SATA

> +	  If unsure, say N.
> +
>  config AHCI_IMX
>  	tristate "Freescale i.MX AHCI SATA support"
>  	depends on SATA_AHCI_PLATFORM && MFD_SYSCON
> diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
> index 246050b..6bbd6da 100644
> --- a/drivers/ata/Makefile
> +++ b/drivers/ata/Makefile
> @@ -5,6 +5,7 @@ obj-$(CONFIG_ATA)		+= libata.o
>  obj-$(CONFIG_SATA_AHCI)		+= ahci.o libahci.o
>  obj-$(CONFIG_SATA_ACARD_AHCI)	+= acard-ahci.o libahci.o
>  obj-$(CONFIG_SATA_AHCI_PLATFORM) += ahci_platform.o libahci.o
> +obj-$(CONFIG_SATA_AHCI_ST)      += ahci_st.o
>  obj-$(CONFIG_SATA_FSL)		+= sata_fsl.o
>  obj-$(CONFIG_SATA_INIC162X)	+= sata_inic162x.o
>  obj-$(CONFIG_SATA_SIL24)	+= sata_sil24.o
> diff --git a/drivers/ata/ahci_st.c b/drivers/ata/ahci_st.c
> new file mode 100644
> index 0000000..2f95133
> --- /dev/null
> +++ b/drivers/ata/ahci_st.c
> @@ -0,0 +1,239 @@
> +/*
> + * Copyright (C) 2012 STMicroelectronics Limited
> + *
> + * Authors: Francesco Virlinzi <francesco.virlinzi@st.com>
> + *	    Alexandre Torgue <alexandre.torgue@st.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/export.h>
> +#include <linux/platform_device.h>
> +#include <linux/clk.h>
> +#include <linux/of.h>
> +#include <linux/ahci_platform.h>
> +#include <linux/phy/phy.h>

Not needed anylonger.

> +#include <linux/libata.h>
> +#include <linux/reset.h>
> +#include <linux/io.h>
> +#include <linux/dma-mapping.h>
> +
> +#include "ahci.h"
> +
> +#define ST_AHCI_OOBR			0xbc
> +#define ST_AHCI_OOBR_WE			BIT(31)
> +#define ST_AHCI_OOBR_CWMIN_SHIFT	24
> +#define ST_AHCI_OOBR_CWMAX_SHIFT	16
> +#define ST_AHCI_OOBR_CIMIN_SHIFT	8
> +#define ST_AHCI_OOBR_CIMAX_SHIFT	0
> +
> +struct st_ahci_drv_data {
> +	struct platform_device *ahci;
> +	struct phy *phy;

ditto

> +	struct reset_control *pwr;
> +	struct reset_control *sw_rst;
> +	struct reset_control *pwr_rst;
> +	struct ahci_host_priv *hpriv;
> +};
> +
> +static void st_ahci_configure_oob(void __iomem *mmio)
> +{
> +	unsigned long old_val, new_val;
> +
> +	new_val = (0x02 << ST_AHCI_OOBR_CWMIN_SHIFT) |
> +		  (0x04 << ST_AHCI_OOBR_CWMAX_SHIFT) |
> +		  (0x08 << ST_AHCI_OOBR_CIMIN_SHIFT) |
> +		  (0x0C << ST_AHCI_OOBR_CIMAX_SHIFT);
> +
> +	old_val = readl(mmio + ST_AHCI_OOBR);
> +	writel(old_val | ST_AHCI_OOBR_WE, mmio + ST_AHCI_OOBR);
> +	writel(new_val | ST_AHCI_OOBR_WE, mmio + ST_AHCI_OOBR);
> +	writel(new_val, mmio + ST_AHCI_OOBR);
> +}
> +
> +static int st_ahci_deassert_resets(struct device *dev)
> +{
> +	struct st_ahci_drv_data *drv_data = dev_get_drvdata(dev);
> +	int err;
> +
> +	if (drv_data->pwr) {
> +		err = reset_control_deassert(drv_data->pwr);
> +		if (err) {
> +			dev_err(dev, "unable to bring out of pwrdwn\n");
> +			return err;
> +		}
> +	}
> +
> +	st_ahci_configure_oob(drv_data->hpriv->mmio);
> +
> +	if (drv_data->sw_rst) {
> +		err = reset_control_deassert(drv_data->sw_rst);
> +		if (err) {
> +			dev_err(dev, "unable to bring out of sw-rst\n");
> +			return err;
> +		}
> +	}
> +
> +	if (drv_data->pwr_rst) {
> +		err = reset_control_deassert(drv_data->pwr_rst);
> +		if (err) {
> +			dev_err(dev, "unable to bring out of pwr-rst\n");
> +			return err;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int st_ahci_probe_resets(struct platform_device *pdev)
> +{
> +	struct st_ahci_drv_data *drv_data = platform_get_drvdata(pdev);
> +
> +	drv_data->pwr = devm_reset_control_get(&pdev->dev, "pwr-dwn");
> +	if (IS_ERR(drv_data->pwr)) {
> +		dev_info(&pdev->dev, "power reset control not defined\n");
> +		drv_data->pwr = NULL;
> +	}
> +
> +	drv_data->sw_rst = devm_reset_control_get(&pdev->dev, "sw-rst");
> +	if (IS_ERR(drv_data->sw_rst)) {
> +		dev_info(&pdev->dev, "soft reset control not defined\n");
> +		drv_data->sw_rst = NULL;
> +	}
> +
> +	drv_data->pwr_rst = devm_reset_control_get(&pdev->dev, "pwr-rst");
> +	if (IS_ERR(drv_data->pwr_rst)) {
> +		dev_dbg(&pdev->dev, "power soft reset control not defined\n");
> +		drv_data->pwr_rst = NULL;
> +	}
> +
> +	return st_ahci_deassert_resets(&pdev->dev);
> +}
> +
> +static const struct ata_port_info st_ahci_port_info = {
> +	.flags          = AHCI_FLAG_COMMON,
> +	.pio_mask       = ATA_PIO4,
> +	.udma_mask      = ATA_UDMA6,
> +	.port_ops       = &ahci_platform_ops,
> +};
> +
> +static int st_ahci_probe(struct platform_device *pdev)
> +{
> +	struct st_ahci_drv_data *drv_data;
> +	struct ahci_host_priv *hpriv;
> +	int err;
> +
> +	drv_data = devm_kzalloc(&pdev->dev, sizeof(*drv_data), GFP_KERNEL);
> +	if (!drv_data)
> +		return -ENOMEM;
> +
> +	platform_set_drvdata(pdev, drv_data);
> +
> +	hpriv = ahci_platform_get_resources(pdev);
> +	if (IS_ERR(hpriv))
> +		return PTR_ERR(hpriv);
> +
> +	drv_data->hpriv = hpriv;
> +
> +	err = st_ahci_probe_resets(pdev);
> +	if (err)
> +		return err;
> +
> +	err = ahci_platform_enable_resources(hpriv);
> +	if (err)
> +		return err;
> +
> +	err = ahci_platform_init_host(pdev, hpriv, &st_ahci_port_info, 0, 0);
> +	if (err) {
> +		ahci_platform_disable_resources(hpriv);
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +
> +static int st_ahci_remove(struct platform_device *pdev)
> +{
> +	struct st_ahci_drv_data *drv_data = platform_get_drvdata(pdev);
> +	struct ahci_host_priv *hpriv = drv_data->hpriv;
> +	int err;
> +
> +	if (drv_data->pwr) {
> +		err = reset_control_assert(drv_data->pwr);
> +		if (err)
> +			dev_err(&pdev->dev, "unable to pwrdwn\n");
> +	}
> +
> +	ahci_platform_disable_resources(hpriv);
> +
> +	return 0;
> +}

This driver should define its own ->host_stop method which will
do reset_control_assert() and ahci_platform_disable_resources().

Then instead of st_ahci_remove() the ata_platform_remove_one()
one should be used as ->remove method.

[ Please see ahci_imx.c for details/example. ]

> +#ifdef CONFIG_PM_SLEEP
> +static int st_ahci_suspend(struct device *dev)
> +{
> +	struct st_ahci_drv_data *drv_data = dev_get_drvdata(dev);
> +	struct ahci_host_priv *hpriv = drv_data->hpriv;
> +	int err;
> +
> +	if (drv_data->pwr) {
> +		err = reset_control_assert(drv_data->pwr);
> +		if (err) {
> +			dev_err(dev, "unable to pwrdwn");
> +			return err;
> +		}
> +	}
> +
> +	ahci_platform_disable_resources(hpriv);

I think that ata_platform_suspend_host() should be used in
st_ahci_suspend() (please refer to ahci_imx.c).

> +	return 0;
> +}
> +
> +static int st_ahci_resume(struct device *dev)
> +{
> +	struct st_ahci_drv_data *drv_data = dev_get_drvdata(dev);
> +	struct ahci_host_priv *hpriv = drv_data->hpriv;
> +	int err;
> +
> +	err = ahci_platform_enable_resources(hpriv);

Similarly, ata_platform_resume_host() should be used in
st_ahci_resume() (please refer to ahci_imx.c).

> +	if (err)
> +		return err;
> +
> +	err = st_ahci_deassert_resets(dev);
> +	if (err) {
> +		ahci_platform_disable_resources(hpriv);
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +#endif
> +
> +static SIMPLE_DEV_PM_OPS(st_ahci_pm_ops, st_ahci_suspend, st_ahci_resume);
> +
> +static struct of_device_id st_ahci_match[] = {
> +	{ .compatible = "st,ahci", },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, st_ahci_match);
> +
> +static struct platform_driver st_ahci_driver = {
> +	.driver = {
> +		.name = "st_ahci",
> +		.owner = THIS_MODULE,
> +		.pm = &st_ahci_pm_ops,
> +		.of_match_table = of_match_ptr(st_ahci_match),
> +	},
> +	.probe = st_ahci_probe,
> +	.remove = st_ahci_remove,
> +};
> +module_platform_driver(st_ahci_driver);
> +
> +MODULE_AUTHOR("Alexandre Torgue <alexandre.torgue@st.com>");
> +MODULE_AUTHOR("Francesco Virlinzi <francesco.virlinzi@st.com>");
> +MODULE_DESCRIPTION("STMicroelectronics Sata Ahci driver");

"Sata Ahci" -> "SATA AHCI"

> +MODULE_LICENSE("GPL v2");

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

