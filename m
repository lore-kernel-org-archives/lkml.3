Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbaKKM5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:57:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:18269 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbaKKM5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 07:57:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,361,1413270000"; 
   d="scan'208";a="605908907"
From: "Tan, Raymond" <raymond.tan@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chen, Alvin" <alvin.chen@intel.com>,
        "Tan, Raymond" <raymond.tan@intel.com>
Subject: RE: [PATCH 1/1] mfd: intel_quark_i2c_gpio: Add Intel Quark X1000
 I2C-GPIO MFD Driver
Thread-Topic: [PATCH 1/1] mfd: intel_quark_i2c_gpio: Add Intel Quark X1000
 I2C-GPIO MFD Driver
Thread-Index: AQHP9zm+zTbcHSOdkkyAmLMU7+/xEJxOF8EAgA1XooA=
Date: Tue, 11 Nov 2014 12:57:18 +0000
Message-ID: <F0CA9E243F4F424B836EAC30E41BF4CF5C778FFF@PGSMSX104.gar.corp.intel.com>
References: <1415000344-23575-1-git-send-email-raymond.tan@intel.com>
	 <1415000344-23575-2-git-send-email-raymond.tan@intel.com>
 <1415005892.2396.82.camel@linux.intel.com>
In-Reply-To: <1415005892.2396.82.camel@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sABCvsfC004749

Hi Andy,

Thanks for your review. I've made the changes and will resend the patch v2. 

Warm Regards, 

Â Raymond Tan
Software Engineer
Malaysia IT Flex Services
INET: 8-253-0075
Flex Website: http://flexservices.intel.com 

> -----Original Message-----
> From: Andy Shevchenko [mailto:andriy.shevchenko@linux.intel.com]
> Sent: Monday, November 03, 2014 5:12 PM
> To: Tan, Raymond
> Cc: Lee Jones; Samuel Ortiz; linux-kernel@vger.kernel.org; Chen, Alvin
> Subject: Re: [PATCH 1/1] mfd: intel_quark_i2c_gpio: Add Intel Quark X1000
> I2C-GPIO MFD Driver
> 
> On Mon, 2014-11-03 at 15:39 +0800, Raymond Tan wrote:
> > In Quark X1000, there's a single PCI device that provides both an I2C
> > controller and a GPIO controller. This MFD driver will split the 2
> > devices for their respective drivers.
> >
> > This patch is based on Josef Ahmad's initial work for Quark enabling.
> 
> Few comments below.
> 
> After addressing take my
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> >
> > Signed-off-by: Weike Chen <alvin.chen@intel.com>
> > Signed-off-by: Raymond Tan <raymond.tan@intel.com>
> > ---
> >  drivers/mfd/Kconfig                |   11 ++
> >  drivers/mfd/Makefile               |    1 +
> >  drivers/mfd/intel_quark_i2c_gpio.c |  298
> > ++++++++++++++++++++++++++++++++++++
> >  3 files changed, 310 insertions(+)
> >  create mode 100644 drivers/mfd/intel_quark_i2c_gpio.c
> >
> > diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig index
> > b7c74a7..d01d042 100644
> > --- a/drivers/mfd/Kconfig
> > +++ b/drivers/mfd/Kconfig
> > @@ -219,6 +219,17 @@ config HTC_I2CPLD
> >  	  This device provides input and output GPIOs through an I2C
> >  	  interface to one or more sub-chips.
> >
> > +config MFD_INTEL_QUARK_I2C_GPIO
> > +	tristate "Intel Quark MFD I2C GPIO"
> > +	depends on PCI && X86
> > +	depends on COMMON_CLK
> > +	select MFD_CORE
> > +	help
> > +	  This MFD provides support for I2C and GPIO that exist only
> > +	  in a single PCI device. It splits the 2 IO devices to
> > +	  their respective IO driver.
> > +	  The GPIO exports a total amount of 8 interrupt-capable GPIOs.
> > +
> >  config LPC_ICH
> >  	tristate "Intel ICH LPC"
> >  	depends on PCI
> > diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile index
> > 8a28dc9..d42652d 100644
> > --- a/drivers/mfd/Makefile
> > +++ b/drivers/mfd/Makefile
> > @@ -133,6 +133,7 @@ obj-$(CONFIG_AB8500_CORE)	+= ab8500-
> core.o ab8500-sysctrl.o
> >  obj-$(CONFIG_MFD_TIMBERDALE)    += timberdale.o
> >  obj-$(CONFIG_PMIC_ADP5520)	+= adp5520.o
> >  obj-$(CONFIG_MFD_KEMPLD)	+= kempld-core.o
> > +obj-$(CONFIG_MFD_INTEL_QUARK_I2C_GPIO)	+=
> intel_quark_i2c_gpio.o
> >  obj-$(CONFIG_LPC_SCH)		+= lpc_sch.o
> >  obj-$(CONFIG_LPC_ICH)		+= lpc_ich.o
> >  obj-$(CONFIG_MFD_RDC321X)	+= rdc321x-southbridge.o
> > diff --git a/drivers/mfd/intel_quark_i2c_gpio.c
> > b/drivers/mfd/intel_quark_i2c_gpio.c
> > new file mode 100644
> > index 0000000..e3cd6fb
> > --- /dev/null
> > +++ b/drivers/mfd/intel_quark_i2c_gpio.c
> > @@ -0,0 +1,298 @@
> > +/*
> > + * Intel Quark MFD PCI driver for I2C & GPIO
> > + *
> > + * Copyright(c) 2014 Intel Corporation.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > +modify it
> > + * under the terms and conditions of the GNU General Public License,
> > + * version 2, as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope it will be useful, but
> > +WITHOUT
> > + * ANY WARRANTY; without even the implied warranty of
> MERCHANTABILITY
> > +or
> > + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
> > +License for
> > + * more details.
> > + *
> > + * Intel Quark PCI device for I2C and GPIO controller sharing the
> > +same
> > + * PCI function. This PCI driver will split the 2 devices into their
> > + * respective drivers.
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/pci.h>
> > +#include <linux/mfd/core.h>
> > +#include <linux/clkdev.h>
> > +#include <linux/clk-provider.h>
> > +#include <linux/dmi.h>
> > +#include <linux/platform_data/gpio-dwapb.h>
> > +#include <linux/platform_data/i2c-designware.h>
> > +
> > +/* PCI BAR for register base address */
> > +#define MFD_I2C_BAR		0
> > +#define MFD_GPIO_BAR		1
> > +
> > +/* The base GPIO number under GPIOLIB framework */
> > +#define INTEL_QUARK_MFD_GPIO_BASE	8
> > +
> > +/* The default number of South-Cluster GPIO on Quark. */
> > +#define INTEL_QUARK_MFD_NGPIO		8
> > +
> > +/* The DesignWare GPIO ports on Quark. */
> > +#define INTEL_QUARK_GPIO_NPORTS	1
> > +
> > +#define INTEL_QUARK_IORES_MEM	0
> > +#define INTEL_QUARK_IORES_IRQ	1
> > +
> > +#define INTEL_QUARK_I2C_CONTROLLER_CLK "i2c_designware.0"
> > +
> > +/* The Quark I2C controller source clock */
> > +#define INTEL_QUARK_I2C_CLK_HZ	33000000
> > +
> > +#define INTEL_QUARK_I2C_NCLK	1
> > +
> > +struct clk *intel_quark_i2c_clk;
> > +struct clk_lookup *intel_quark_i2c_clk_lookups;
> > +
> > +struct i2c_mode_info {
> > +	const char *name;
> > +	unsigned int i2c_scl_freq;
> > +};
> > +
> > +static const struct i2c_mode_info platform_i2c_mode_info[] = {
> > +	{
> > +		.name = "Galileo",
> > +		.i2c_scl_freq = 100000,
> > +	},
> > +	{
> > +		.name = "GalileoGen2",
> > +		.i2c_scl_freq = 400000,
> > +	},
> 
> You can decrease indentation level if you want to by using
> 
> = {{
> }, {
> }};
> 
> Though I don't know if Lee likes it :-)
> 
> At least you may use }, { at one line I think.
> 
> > +};
> > +
> > +static struct resource intel_quark_i2c_res[] = {
> > +	[INTEL_QUARK_IORES_MEM] = {
> > +		.flags = IORESOURCE_MEM,
> > +	},
> > +	[INTEL_QUARK_IORES_IRQ] = {
> > +		.flags = IORESOURCE_IRQ,
> > +	},
> > +};
> > +
> > +static struct resource intel_quark_gpio_res[] = {
> > +	[INTEL_QUARK_IORES_MEM] = {
> > +		.flags = IORESOURCE_MEM,
> > +	},
> > +};
> > +
> > +static struct mfd_cell intel_quark_mfd_cells[] = {
> > +	{
> > +		.id = MFD_I2C_BAR,
> > +		.name = "i2c_designware",
> > +		.num_resources = ARRAY_SIZE(intel_quark_i2c_res),
> > +		.resources = intel_quark_i2c_res,
> > +		.ignore_resource_conflicts = true,
> > +	},
> > +	{
> > +		.id = MFD_GPIO_BAR,
> > +		.name = "gpio-dwapb",
> > +		.num_resources = ARRAY_SIZE(intel_quark_gpio_res),
> > +		.resources = intel_quark_gpio_res,
> > +		.ignore_resource_conflicts = true,
> > +	},
> 
> Ditto.
> 
> > +};
> > +
> > +static const struct pci_device_id intel_quark_mfd_ids[] = {
> > +	{ PCI_VDEVICE(INTEL, 0x0934), },
> > +	{ 0,}
> > +};
> > +MODULE_DEVICE_TABLE(pci, intel_quark_mfd_ids);
> > +
> > +static struct dwapb_platform_data *
> > +intel_quark_prepare_pdata(struct pci_dev *pdev) {
> > +	struct dwapb_platform_data *pdata;
> > +	struct device *dev = &pdev->dev;
> > +
> > +	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
> > +	if (!pdata)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	/* For intel quark x1000, it has only one port: portA */
> > +	pdata->nports = INTEL_QUARK_GPIO_NPORTS;
> > +	pdata->properties = devm_kcalloc(dev, pdata->nports,
> > +					 sizeof(*pdata->properties),
> > +					 GFP_KERNEL);
> > +	if (!pdata->properties)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	/* Set the properties for portA */
> > +	pdata->properties->node	= NULL;
> > +	pdata->properties->name	= "intel-quark-x1000-gpio-portA";
> > +	pdata->properties->idx	= 0;
> > +	pdata->properties->ngpio	= INTEL_QUARK_MFD_NGPIO;
> > +	pdata->properties->gpio_base	= INTEL_QUARK_MFD_GPIO_BASE;
> > +	pdata->properties->irq	= pdev->irq;
> > +	pdata->properties->irq_shared	= true;
> > +
> > +	return pdata;
> > +}
> > +
> > +static struct dw_i2c_platform_data *
> > +intel_quark_get_i2c_mode(struct pci_dev *pdev) {
> > +	const char *board_name =
> dmi_get_system_info(DMI_BOARD_NAME);
> > +	struct dw_i2c_platform_data *pdata;
> > +	struct device *dev = &pdev->dev;
> > +	unsigned int i;
> > +
> > +	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
> > +	if (!pdata)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	/* Fast mode by default */
> > +	pdata->i2c_scl_freq = 400000;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(platform_i2c_mode_info); i++)
> > +		if (!strcmp(board_name, platform_i2c_mode_info[i].name))
> > +			pdata->i2c_scl_freq
> > +				= platform_i2c_mode_info[i].i2c_scl_freq;
> > +
> > +	return pdata;
> > +}
> > +
> > +static int intel_quark_register_i2c_clk(struct pci_dev *pdev) {
> > +	intel_quark_i2c_clk = clk_register_fixed_rate(
> > +		&pdev->dev, INTEL_QUARK_I2C_CONTROLLER_CLK, NULL,
> > +		CLK_IS_ROOT, INTEL_QUARK_I2C_CLK_HZ);
> > +
> > +	intel_quark_i2c_clk_lookups = devm_kcalloc(
> > +		&pdev->dev, INTEL_QUARK_I2C_NCLK,
> > +		sizeof(*intel_quark_i2c_clk_lookups), GFP_KERNEL);
> > +
> > +	if (!intel_quark_i2c_clk_lookups)
> 
> Potential leak here since you didn't call clk_unregister().
> Maybe you move the memory allocation upper?
> 
> > +		return -ENOMEM;
> > +
> > +	intel_quark_i2c_clk_lookups[0].dev_id =
> > +INTEL_QUARK_I2C_CONTROLLER_CLK;
> > +
> > +	return clk_register_clkdevs(intel_quark_i2c_clk,
> > +		intel_quark_i2c_clk_lookups, INTEL_QUARK_I2C_NCLK); }
> > +
> > +static void intel_quark_unregister_i2c_clk(void)
> > +{
> > +	if (!intel_quark_i2c_clk || !intel_quark_i2c_clk_lookups)
> > +		return;
> > +
> > +	clkdev_drop(intel_quark_i2c_clk_lookups);
> > +	clk_unregister(intel_quark_i2c_clk);
> > +}
> > +
> > +static int intel_quark_i2c_setup(struct pci_dev *pdev, struct
> > +mfd_cell *cell) {
> > +	struct dw_i2c_platform_data *pdata;
> > +	struct resource *res = (struct resource *)cell->resources;
> > +	int retval;
> > +
> > +	res[INTEL_QUARK_IORES_MEM].start =
> > +		pci_resource_start(pdev, MFD_I2C_BAR);
> > +	res[INTEL_QUARK_IORES_MEM].end =
> > +		pci_resource_end(pdev, MFD_I2C_BAR);
> > +
> > +	res[INTEL_QUARK_IORES_IRQ].start = pdev->irq;
> > +	res[INTEL_QUARK_IORES_IRQ].end = pdev->irq;
> > +
> > +	retval = intel_quark_register_i2c_clk(pdev);
> > +	if (retval) {
> > +		dev_err(&pdev->dev, "Fixed clk register failed: %d\n",
> retval);
> > +		return retval;
> > +	}
> > +
> > +	pdata = intel_quark_get_i2c_mode(pdev);
> > +	if (IS_ERR(pdata))
> > +		return PTR_ERR(pdata);
> > +
> > +	cell->platform_data = pdata;
> > +	cell->pdata_size = sizeof(*pdata);
> > +
> > +	return 0;
> > +}
> > +
> > +static int intel_quark_gpio_setup(struct pci_dev *pdev, struct
> > +mfd_cell *cell) {
> > +	struct dwapb_platform_data *pdata;
> > +	struct resource *res = (struct resource *)cell->resources;
> > +
> > +	res[INTEL_QUARK_IORES_MEM].start =
> > +		pci_resource_start(pdev, MFD_GPIO_BAR);
> > +	res[INTEL_QUARK_IORES_MEM].end =
> > +		pci_resource_end(pdev, MFD_GPIO_BAR);
> > +
> > +	pdata = intel_quark_prepare_pdata(pdev);
> > +	if (IS_ERR(pdata))
> > +		return PTR_ERR(pdata);
> > +
> > +	cell->platform_data = pdata;
> > +	cell->pdata_size = sizeof(*pdata);
> > +
> > +	return 0;
> > +}
> > +
> > +struct intel_quark_mfd_dev {
> > +	int (*setup)(struct pci_dev *pdev, struct mfd_cell *cell);
> > +	struct mfd_cell *cell;
> > +};
> > +
> > +static struct intel_quark_mfd_dev intel_quark_mfd_devs[] = {
> > +	{
> > +		.cell = &intel_quark_mfd_cells[MFD_I2C_BAR],
> > +		.setup = intel_quark_i2c_setup,
> > +	},
> > +	{
> > +		.cell = &intel_quark_mfd_cells[MFD_GPIO_BAR],
> > +		.setup = intel_quark_gpio_setup,
> > +	},
> > +	{
> > +		/* terminator */
> > +	},
> > +};
> > +
> > +static int intel_quark_mfd_probe(struct pci_dev *pdev,
> > +				 const struct pci_device_id *id)
> > +{
> > +	struct intel_quark_mfd_dev *mfd_dev;
> > +	int retval;
> > +
> > +	retval = pcim_enable_device(pdev);
> > +	if (retval)
> > +		return retval;
> > +
> > +	for (mfd_dev = intel_quark_mfd_devs; mfd_dev->cell; mfd_dev++)
> > +		if (mfd_dev->setup) {
> > +			retval = mfd_dev->setup(pdev, mfd_dev->cell);
> > +			if (retval)
> > +				return retval;
> > +		}
> > +
> > +	return mfd_add_devices(&pdev->dev, 0, intel_quark_mfd_cells,
> > +		ARRAY_SIZE(intel_quark_mfd_cells), NULL, 0, NULL); }
> > +
> > +static void intel_quark_mfd_remove(struct pci_dev *pdev) {
> > +	intel_quark_unregister_i2c_clk();
> > +	mfd_remove_devices(&pdev->dev);
> > +}
> > +
> > +static struct pci_driver intel_quark_mfd_driver = {
> > +	.name		= "intel_quark_mfd_i2c_gpio",
> > +	.id_table	= intel_quark_mfd_ids,
> > +	.probe		= intel_quark_mfd_probe,
> > +	.remove		= intel_quark_mfd_remove,
> > +};
> > +
> > +module_pci_driver(intel_quark_mfd_driver);
> > +
> > +MODULE_AUTHOR("Raymond Tan <raymond.tan@intel.com>");
> > +MODULE_DESCRIPTION("Intel Quark MFD PCI driver for I2C & GPIO");
> > +MODULE_LICENSE("GPL v2");
> 
> 
> --
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Intel Finland Oy

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
