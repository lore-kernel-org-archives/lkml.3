Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757738AbaCTM5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 08:57:34 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:44939 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaCTM5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 08:57:30 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-e8-532ae5b86eb1
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Sekhar Nori <nsekhar@ti.com>
Cc: Tejun Heo <tj@kernel.org>, Kevin Hilman <khilman@deeprootsystems.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, linux-ide@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        spear-devel@list.st.com
Subject: Re: [PATCH 3/4] ata: add new-style AHCI platform driver for DaVinci
 DA850 AHCI controller
Date: Thu, 20 Mar 2014 13:57:10 +0100
Message-id: <2662651.GJX9HVKij5@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <532AA2B0.1060103@ti.com>
References: <1395081118-15248-1-git-send-email-b.zolnierkie@samsung.com>
 <1395081118-15248-4-git-send-email-b.zolnierkie@samsung.com>
 <532AA2B0.1060103@ti.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsVy+t9jAd0dT7WCDb61K1mcu9XAanFnBbPF
	psfXWC2O7XjEZHF51xw2i/29G5gsGrp72C3mzNjMavFr+VFGi5UX/zI7cHlcf/WfyWPnrLvs
	HptWdbJ5zJnWxOJx8sJJFo/NS+o9nv7Yy+xx/MZ2Jo/Pm+QCOKO4bFJSczLLUov07RK4Mo6c
	e8ZS8Me14uvve4wNjDPMuxg5OCQETCRaL5Z2MXICmWISF+6tZ+ti5OIQEljEKLHu1lpWCKeF
	SeLHvYlMIFVsAlYSE9tXMYLYIgIKEquu7AUrYhY4xiTx8+d0sCJhgRSJGQ9msoDYLAKqEvNW
	fQFr4BXQlFj5+RBYXFTAU2LH9pVsIDangJpE2+Fp7BDbFjNKbOqEKOIVEJT4MfkemM0sIC+x
	b/9UVghbR2J/6zS2CYwCs5CUzUJSNgtJ2QJG5lWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsY
	wbHyTGoH48oGi0OMAhyMSjy8K/ZoBguxJpYVV+YeYpTgYFYS4Z16QytYiDclsbIqtSg/vqg0
	J7X4EKM0B4uSOO+BVutAIYH0xJLU7NTUgtQimCwTB6dUA6OXxbQvc0/UmFzdcd9ktkjR5ByT
	nXOV04V2CCVuXnro1pElggv+5euICGZGq9toCf4R26EecrpWOEDDrjfl5+tjmsf5lH0b43PN
	RT8qyBzh28qgFriLe1PtodC7+utz34XkzV9fWiJgErlR6KIgd3yKT6iLseN//+c/Lgge1c2w
	+Fik8v2+rBJLcUaioRZzUXEiAJ5ks8ORAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thursday, March 20, 2014 01:41:28 PM Sekhar Nori wrote:
> Hi Bartlomiej,
> 
> On Tuesday 18 March 2014 12:01 AM, Bartlomiej Zolnierkiewicz wrote:
> > The new driver is named ahci_da850 and is only compile tested.  Once it
> > is tested on the real hardware and verified to work correctly, the legacy
> > platform code (which depends on the deprecated struct ahci_platform_data)
> > can be removed.
> > 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> 
> Thanks for the patch. I have been able to use your patch and verify SATA
> functionality on DA850 EVM. I have some comments though.

Thanks for testing + quick reply.

> > ---
> >  drivers/ata/Kconfig      |   9 +++
> >  drivers/ata/Makefile     |   1 +
> >  drivers/ata/ahci_da850.c | 178 +++++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 188 insertions(+)
> >  create mode 100644 drivers/ata/ahci_da850.c
> > 
> > diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
> > index 371e8890..6379a00 100644
> > --- a/drivers/ata/Kconfig
> > +++ b/drivers/ata/Kconfig
> > @@ -97,6 +97,15 @@ config SATA_AHCI_PLATFORM
> >  
> >  	  If unsure, say N.
> >  
> > +config AHCI_DA850
> > +	tristate "DaVinci DA850 AHCI SATA support (experimental)"
> > +	depends on ARCH_DAVINCI_DA850
> > +	help
> > +	  This option enables support for the DaVinci DA850 SoC's
> > +	  onboard AHCI SATA.
> > +
> > +	  If unsure, say N.
> > +
> >  config AHCI_ST
> >  	tristate "ST AHCI SATA support"
> >  	depends on ARCH_STI
> > diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
> > index 6123e64..0646d83 100644
> > --- a/drivers/ata/Makefile
> > +++ b/drivers/ata/Makefile
> > @@ -10,6 +10,7 @@ obj-$(CONFIG_SATA_INIC162X)	+= sata_inic162x.o
> >  obj-$(CONFIG_SATA_SIL24)	+= sata_sil24.o
> >  obj-$(CONFIG_SATA_DWC)		+= sata_dwc_460ex.o
> >  obj-$(CONFIG_SATA_HIGHBANK)	+= sata_highbank.o libahci.o
> > +obj-$(CONFIG_AHCI_DA850)	+= ahci_da850.o libahci.o libahci_platform.o
> >  obj-$(CONFIG_AHCI_IMX)		+= ahci_imx.o libahci.o libahci_platform.o
> >  obj-$(CONFIG_AHCI_SUNXI)	+= ahci_sunxi.o libahci.o libahci_platform.o
> >  obj-$(CONFIG_AHCI_ST)		+= ahci_st.o libahci.o libahci_platform.o
> > diff --git a/drivers/ata/ahci_da850.c b/drivers/ata/ahci_da850.c
> > new file mode 100644
> > index 0000000..da874699
> > --- /dev/null
> > +++ b/drivers/ata/ahci_da850.c
> > @@ -0,0 +1,178 @@
> > +/*
> > + * DaVinci DA850 AHCI SATA platform driver
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2, or (at your option)
> > + * any later version.
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/pm.h>
> > +#include <linux/device.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/libata.h>
> > +#include <linux/ahci_platform.h>
> > +#include "ahci.h"
> > +
> > +extern void __iomem *da8xx_syscfg1_base;
> 
> This platform specific extern symbol should not be used in drivers and
> in fact checkpatch complains about it too. Can you instead get the
> addresses you need as part of the device resources?

This is problematic because it is system resource not particular device
resource.  I would prefer to wait with fixing it until the conversion to
the device tree.

> > +#define DA8XX_SYSCFG1_VIRT(x)	(da8xx_syscfg1_base + (x))
> > +#define DA8XX_PWRDN_REG		0x18
> > +
> > +/* SATA PHY Control Register offset from AHCI base */
> > +#define SATA_P0PHYCR_REG	0x178
> > +
> > +#define SATA_PHY_MPY(x)		((x) << 0)
> > +#define SATA_PHY_LOS(x)		((x) << 6)
> > +#define SATA_PHY_RXCDR(x)	((x) << 10)
> > +#define SATA_PHY_RXEQ(x)	((x) << 13)
> > +#define SATA_PHY_TXSWING(x)	((x) << 19)
> > +#define SATA_PHY_ENPLL(x)	((x) << 31)
> 
> These can be replaced with BIT(N)

OK, I'll fix it.

> > +
> > +static struct clk *da850_sata_clk;
> > +static unsigned long da850_sata_refclkpn = 100 * 1000 * 1000;
> 
> This should ideally be platform data. Since we are not going to add
> anymore board files, I am not going to ask you to add one.
> 
> However, with the input value hard coded in driver, it does not make
> sense to have the frequencies table and its traversal. Instead, I
> suggest you hard-code the multiplier itself with a porting warning
> comment. Later when the DT conversion happens and this becomes a DT
> property, we can add back the logic for multiple multiplier settings.
> The way it is now, the code looks superfluous.

OK, will fix.

> > +
> > +/* Supported DA850 SATA crystal frequencies */
> > +#define KHZ_TO_HZ(freq) ((freq) * 1000)
> > +static unsigned long da850_sata_xtal[] = {
> > +	KHZ_TO_HZ(300000),
> > +	KHZ_TO_HZ(250000),
> > +	0,			/* Reserved */
> > +	KHZ_TO_HZ(187500),
> > +	KHZ_TO_HZ(150000),
> > +	KHZ_TO_HZ(125000),
> > +	KHZ_TO_HZ(120000),
> > +	KHZ_TO_HZ(100000),
> > +	KHZ_TO_HZ(75000),
> > +	KHZ_TO_HZ(60000),
> > +};
> > +
> > +static int da850_sata_init(struct device *dev, void __iomem *addr)
> > +{
> > +	int i, ret;
> > +	unsigned int val;
> > +
> > +	da850_sata_clk = clk_get(dev, NULL);
> > +	if (IS_ERR(da850_sata_clk))
> > +		return PTR_ERR(da850_sata_clk);
> > +
> > +	ret = clk_prepare_enable(da850_sata_clk);
> > +	if (ret)
> > +		goto err0;
> 
> Please switch to pm_runtime instead of using the clock APIs directly.

Could you please elaborate a bit more on this?

> > +
> > +	/* Enable SATA clock receiver */
> > +	val = __raw_readl(DA8XX_SYSCFG1_VIRT(DA8XX_PWRDN_REG));
> 
> Use readl() or readl_relaxed() for endian-neutrality.

OK, I will use readl()/writel().

> > +	val &= ~BIT(0);
> > +	__raw_writel(val, DA8XX_SYSCFG1_VIRT(DA8XX_PWRDN_REG));
> > +
> > +	/* Get the multiplier needed for 1.5GHz PLL output */
> > +	for (i = 0; i < ARRAY_SIZE(da850_sata_xtal); i++)
> > +		if (da850_sata_xtal[i] == da850_sata_refclkpn)
> > +			break;
> > +
> > +	if (i == ARRAY_SIZE(da850_sata_xtal)) {
> > +		ret = -EINVAL;
> > +		goto err1;
> > +	}
> > +
> > +	val = SATA_PHY_MPY(i + 1) |
> > +		SATA_PHY_LOS(1) |
> > +		SATA_PHY_RXCDR(4) |
> > +		SATA_PHY_RXEQ(1) |
> > +		SATA_PHY_TXSWING(3) |
> > +		SATA_PHY_ENPLL(1);
> > +
> > +	__raw_writel(val, addr + SATA_P0PHYCR_REG);
> > +
> > +	return 0;
> > +
> > +err1:
> > +	clk_disable_unprepare(da850_sata_clk);
> > +err0:
> > +	clk_put(da850_sata_clk);
> > +	return ret;
> > +}
> > +
> > +static void da850_sata_exit(struct device *dev)
> > +{
> > +	clk_disable_unprepare(da850_sata_clk);
> > +	clk_put(da850_sata_clk);
> > +}
> > +
> > +static void ahci_da850_host_stop(struct ata_host *host)
> > +{
> > +	struct device *dev = host->dev;
> > +	struct ahci_host_priv *hpriv = host->private_data;
> > +
> > +	da850_sata_exit(dev);
> > +
> > +	ahci_platform_disable_resources(hpriv);
> > +}
> > +
> > +static struct ata_port_operations ahci_da850_port_ops = {
> > +	.inherits	= &ahci_platform_ops,
> > +	.host_stop	= ahci_da850_host_stop,
> > +};
> > +
> > +static const struct ata_port_info ahci_da850_port_info = {
> > +	.flags		= AHCI_FLAG_COMMON,
> > +	.pio_mask	= ATA_PIO4,
> > +	.udma_mask	= ATA_UDMA6,
> > +	.port_ops	= &ahci_da850_port_ops,
> > +};
> > +
> > +static int ahci_da850_probe(struct platform_device *pdev)
> > +{
> > +	struct device *dev = &pdev->dev;
> > +	struct ahci_host_priv *hpriv;
> > +	int rc;
> > +
> > +	hpriv = ahci_platform_get_resources(pdev);
> > +	if (IS_ERR(hpriv))
> > +		return PTR_ERR(hpriv);
> > +
> > +	rc = ahci_platform_enable_resources(hpriv);
> > +	if (rc)
> > +		return rc;
> > +
> > +	rc = da850_sata_init(dev, hpriv->mmio);
> > +	if (rc)
> > +		goto disable_resources;
> > +
> > +	rc = ahci_platform_init_host(pdev, hpriv, &ahci_da850_port_info, 0, 0);
> > +	if (rc)
> > +		goto sata_exit;
> > +
> > +	return 0;
> > +sata_exit:
> > +	da850_sata_exit(dev);
> > +disable_resources:
> > +	ahci_platform_disable_resources(hpriv);
> > +	return rc;
> > +}
> > +
> > +static SIMPLE_DEV_PM_OPS(ahci_da850_pm_ops, ahci_platform_suspend,
> > +			 ahci_platform_resume);
> > +
> > +static struct platform_device_id ahci_da850_platform_ids[] = {
> > +	{ .name = "ahci" },
> 
> I was not able to get this driver probed with this name (I guess that
> was because the generic driver was picked instead?). Can you please

Yes, the generic driver should be disabled to use this one.

> change it to "da850-sata"?

I prefer to remove the ids table (so the "ahci_da850" driver name is
used) and update the platform device name accordingly.  This would also
allow me to remove the old ahci_platform_data code in this patch.

Is this OK with you?

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

