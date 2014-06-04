Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751122AbaFDISR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 04:18:17 -0400
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:10134
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750742AbaFDISL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 04:18:11 -0400
From: "Bharat.Bhushan@freescale.com" <Bharat.Bhushan@freescale.com>
To: Scott Wood <scottwood@freescale.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RESEND PATCH] memory: Freescale CoreNet Coherency Fabric error
 reporting driver
Thread-Topic: [RESEND PATCH] memory: Freescale CoreNet Coherency Fabric error
 reporting driver
Thread-Index: AQHPfFZ5AO8lYHxFT069YHO6X2X6YptgmrRg
Date: Wed, 4 Jun 2014 08:17:55 +0000
Message-ID: <967d9a5e0f7e4d0a8f5e7ec6b8e88ff2@BLUPR03MB566.namprd03.prod.outlook.com>
References: <20140530222743.GA6918@home.buserror.net>
In-Reply-To: <20140530222743.GA6918@home.buserror.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.169.1]
x-microsoft-antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
x-forefront-prvs: 0232B30BBC
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(199002)(189002)(51704005)(13464003)(377454003)(81542001)(19580405001)(50986999)(15975445006)(99286001)(54356999)(77096999)(64706001)(19580395003)(79102001)(92566001)(99396002)(66066001)(81342001)(76576001)(83322001)(76482001)(2656002)(87936001)(21056001)(77982001)(4396001)(85852003)(74502001)(74662001)(31966008)(20776003)(33646001)(80022001)(76176999)(101416001)(86362001)(74316001)(83072002)(575784001)(46102001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB389;H:BLUPR03MB566.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Bharat.Bhushan@freescale.com; 
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s548IeoD012166



> -----Original Message-----
> From: Linuxppc-dev [mailto:linuxppc-dev-
> bounces+bharat.bhushan=freescale.com@lists.ozlabs.org] On Behalf Of Scott Wood
> Sent: Saturday, May 31, 2014 3:58 AM
> To: Greg Kroah-Hartman
> Cc: linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org
> Subject: [RESEND PATCH] memory: Freescale CoreNet Coherency Fabric error
> reporting driver
> 
> The CoreNet Coherency Fabric is part of the memory subsystem on some Freescale
> QorIQ chips.  It can report coherency violations (e.g.
> due to misusing memory that is mapped noncoherent) as well as transactions that
> do not hit any local access window, or which hit a local access window with an
> invalid target ID.
> 
> Signed-off-by: Scott Wood <scottwood@freescale.com>
> ---
> Resending to the proper list addresses -- sorry for the duplicate.
> 
>  arch/powerpc/configs/corenet32_smp_defconfig |   1 +
>  arch/powerpc/configs/corenet64_smp_defconfig |   1 +
>  drivers/memory/Kconfig                       |  10 ++
>  drivers/memory/Makefile                      |   1 +
>  drivers/memory/fsl-corenet-cf.c              | 246 +++++++++++++++++++++++++++
>  5 files changed, 259 insertions(+)
>  create mode 100644 drivers/memory/fsl-corenet-cf.c
> 
> diff --git a/arch/powerpc/configs/corenet32_smp_defconfig
> b/arch/powerpc/configs/corenet32_smp_defconfig
> index c19ff05..0c99d7e 100644
> --- a/arch/powerpc/configs/corenet32_smp_defconfig
> +++ b/arch/powerpc/configs/corenet32_smp_defconfig
> @@ -179,3 +179,4 @@ CONFIG_CRYPTO_SHA512=y  CONFIG_CRYPTO_AES=y  #
> CONFIG_CRYPTO_ANSI_CPRNG is not set  CONFIG_CRYPTO_DEV_FSL_CAAM=y
> +CONFIG_FSL_CORENET_CF=y
> diff --git a/arch/powerpc/configs/corenet64_smp_defconfig
> b/arch/powerpc/configs/corenet64_smp_defconfig
> index 5c7fa19..8fb616d 100644
> --- a/arch/powerpc/configs/corenet64_smp_defconfig
> +++ b/arch/powerpc/configs/corenet64_smp_defconfig
> @@ -175,3 +175,4 @@ CONFIG_CRYPTO_SHA256=y  CONFIG_CRYPTO_SHA512=y  #
> CONFIG_CRYPTO_ANSI_CPRNG is not set  CONFIG_CRYPTO_DEV_FSL_CAAM=y
> +CONFIG_FSL_CORENET_CF=y
> diff --git a/drivers/memory/Kconfig b/drivers/memory/Kconfig index
> c59e9c9..fab81a1 100644
> --- a/drivers/memory/Kconfig
> +++ b/drivers/memory/Kconfig
> @@ -61,6 +61,16 @@ config TEGRA30_MC
>  	  analysis, especially for IOMMU/SMMU(System Memory Management
>  	  Unit) module.
> 
> +config FSL_CORENET_CF
> +	tristate "Freescale CoreNet Error Reporting"
> +	depends on FSL_SOC_BOOKE
> +	help
> +	  Say Y for reporting of errors from the Freescale CoreNet
> +	  Coherency Fabric.  Errors reported include accesses to
> +	  physical addresses that mapped by no local access window
> +	  (LAW) or an invalid LAW, as well as bad cache state that
> +	  represents a coherency violation.
> +
>  config FSL_IFC
>  	bool
>  	depends on FSL_SOC
> diff --git a/drivers/memory/Makefile b/drivers/memory/Makefile index
> 71160a2..4055c47 100644
> --- a/drivers/memory/Makefile
> +++ b/drivers/memory/Makefile
> @@ -7,6 +7,7 @@ obj-$(CONFIG_OF)		+= of_memory.o
>  endif
>  obj-$(CONFIG_TI_AEMIF)		+= ti-aemif.o
>  obj-$(CONFIG_TI_EMIF)		+= emif.o
> +obj-$(CONFIG_FSL_CORENET_CF)	+= fsl-corenet-cf.o
>  obj-$(CONFIG_FSL_IFC)		+= fsl_ifc.o
>  obj-$(CONFIG_MVEBU_DEVBUS)	+= mvebu-devbus.o
>  obj-$(CONFIG_TEGRA20_MC)	+= tegra20-mc.o
> diff --git a/drivers/memory/fsl-corenet-cf.c b/drivers/memory/fsl-corenet-cf.c
> new file mode 100644 index 0000000..a57a614
> --- /dev/null
> +++ b/drivers/memory/fsl-corenet-cf.c
> @@ -0,0 +1,246 @@
> +/*
> + * CoreNet Coherency Fabric error reporting
> + *
> + * Copyright 2014 Freescale Semiconductor Inc.
> + *
> + * This program is free software; you can redistribute  it and/or
> +modify it
> + * under  the terms of  the GNU General  Public License as published by
> +the
> + * Free Software Foundation;  either version 2 of the  License, or (at
> +your
> + * option) any later version.
> + */
> +
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/irq.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/of_device.h>
> +#include <linux/of_irq.h>
> +#include <linux/platform_device.h>
> +
> +enum ccf_version {
> +	CCF1,
> +	CCF2,
> +};
> +
> +struct ccf_info {
> +	enum ccf_version version;
> +	int err_reg_offs;
> +};
> +
> +static const struct ccf_info ccf1_info = {
> +	.version = CCF1,
> +	.err_reg_offs = 0xa00,
> +};
> +
> +static const struct ccf_info ccf2_info = {
> +	.version = CCF2,
> +	.err_reg_offs = 0xe40,
> +};
> +
> +static const struct of_device_id ccf_matches[] = {
> +	{
> +		.compatible = "fsl,corenet1-cf",
> +		.data = &ccf1_info,
> +	},
> +	{
> +		.compatible = "fsl,corenet2-cf",
> +		.data = &ccf2_info,
> +	},
> +	{}
> +};
> +
> +struct ccf_err_regs {
> +	u32 errdet;		/* 0x00 Error Detect Register */
> +	/* 0x04 Error Enable (ccf1)/Disable (ccf2) Register */
> +	u32 errdis;
> +	/* 0x08 Error Interrupt Enable Register (ccf2 only) */
> +	u32 errinten;
> +	u32 cecar;		/* 0x0c Error Capture Attribute Register */
> +	u32 cecadrh;		/* 0x10 Error Capture Address High */

s/cecadrh/cecaddrh/g
This way we will be consistent with Reference manual.

> +	u32 cecadrl;		/* 0x14 Error Capture Address Low */

s/cecadrl/cecaddrl/g

> +	u32 cecar2;		/* 0x18 Error Capture Attribute Register 2 */
> +};
> +
> +/* LAE/CV also valid for errdis and errinten */
> +#define ERRDET_LAE		(1 << 0)  /* Local Access Error */
> +#define ERRDET_CV		(1 << 1)  /* Coherency Violation */
> +#define ERRDET_CTYPE_SHIFT	26	  /* Capture Type (ccf2 only) */
> +#define ERRDET_CTYPE_MASK	(0x3f << ERRDET_CTYPE_SHIFT)

Should not this be (0x1f << ERRDET_CTYPE_SHIFT)

> +#define ERRDET_CAP		(1 << 31) /* Capture Valid (ccf2 only) */
> +
> +#define CECAR_VAL		(1 << 0)  /* Valid (ccf1 only) */
> +#define CECAR_UVT		(1 << 15) /* Unavailable target ID (ccf1) */
> +#define CECAR_SRCID_SHIFT_CCF1	24
> +#define CECAR_SRCID_MASK_CCF1	(0xff << CECAR_SRCID_SHIFT_CCF1)
> +#define CECAR_SRCID_SHIFT_CCF2	18
> +#define CECAR_SRCID_MASK_CCF2	(0xff << CECAR_SRCID_SHIFT_CCF2)
> +
> +#define CECADRH_ADDRH		0xf

On ccf2 this id 0xff.

> +
> +struct ccf_private {
> +	const struct ccf_info *info;
> +	struct device *dev;
> +	void __iomem *regs;
> +	struct ccf_err_regs __iomem *err_regs; };
> +
> +static irqreturn_t ccf_irq(int irq, void *dev_id) {
> +	struct ccf_private *ccf = dev_id;
> +	static DEFINE_RATELIMIT_STATE(ratelimit, DEFAULT_RATELIMIT_INTERVAL,
> +				      DEFAULT_RATELIMIT_BURST);
> +	u32 errdet, cecar, cecar2;
> +	u64 addr;
> +	u32 src_id;
> +	bool uvt = false;
> +	bool cap_valid = false;
> +
> +	errdet = ioread32be(&ccf->err_regs->errdet);
> +	cecar = ioread32be(&ccf->err_regs->cecar);
> +	cecar2 = ioread32be(&ccf->err_regs->cecar2);
> +	addr = ioread32be(&ccf->err_regs->cecadrl);
> +	addr |= ((u64)(ioread32be(&ccf->err_regs->cecadrh) &
> +		       CECADRH_ADDRH)) << 32;

So this go down to ccf version type switch. 

> +
> +	if (!__ratelimit(&ratelimit))
> +		goto out;
> +
> +	switch (ccf->info->version) {
> +	case CCF1:
> +		if (cecar & CECAR_VAL) {
> +			if (cecar & CECAR_UVT)
> +				uvt = true;
> +
> +			src_id = (cecar & CECAR_SRCID_MASK_CCF1) >>
> +				 CECAR_SRCID_SHIFT_CCF1;
> +			cap_valid = true;
> +		}
> +
> +		break;
> +	case CCF2:
> +		if (errdet & ERRDET_CAP) {
> +			src_id = (cecar & CECAR_SRCID_MASK_CCF2) >>
> +				 CECAR_SRCID_SHIFT_CCF2;
> +			cap_valid = true;
> +		}
> +
> +		break;
> +	}
> +
> +	dev_crit(ccf->dev, "errdet 0x%08x cecar 0x%08x cecar2 0x%08x\n",
> +		 errdet, cecar, cecar2);
> +
> +	if (errdet & ERRDET_LAE) {
> +		if (uvt)
> +			dev_crit(ccf->dev, "LAW Unavailable Target ID\n");
> +		else
> +			dev_crit(ccf->dev, "Local Access Window Error\n");
> +	}
> +
> +	if (errdet & ERRDET_CV)
> +		dev_crit(ccf->dev, "Coherency Violation\n");
> +
> +	if (cap_valid) {
> +		dev_crit(ccf->dev, "address 0x%09llx, src id 0x%x\n",
> +			 addr, src_id);
> +	}
> +
> +out:
> +	iowrite32be(errdet, &ccf->err_regs->errdet);
> +	return errdet ? IRQ_HANDLED : IRQ_NONE; }
> +
> +static int ccf_probe(struct platform_device *pdev) {
> +	struct ccf_private *ccf;
> +	struct resource *r;
> +	const struct of_device_id *match;
> +	int ret, irq;
> +
> +	match = of_match_device(ccf_matches, &pdev->dev);
> +	if (WARN_ON(!match))
> +		return -ENODEV;
> +
> +	ccf = devm_kzalloc(&pdev->dev, sizeof(*ccf), GFP_KERNEL);
> +	if (!ccf)
> +		return -ENOMEM;
> +
> +	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!r) {
> +		dev_err(&pdev->dev, "%s: no mem resource\n", __func__);
> +		return -ENXIO;
> +	}
> +
> +	ccf->regs = devm_ioremap_resource(&pdev->dev, r);
> +	if (IS_ERR(ccf->regs)) {
> +		dev_err(&pdev->dev, "%s: can't map mem resource\n", __func__);
> +		return PTR_ERR(ccf->regs);
> +	}
> +
> +	ccf->dev = &pdev->dev;
> +	ccf->info = match->data;
> +	ccf->err_regs = ccf->regs + ccf->info->err_reg_offs;
> +
> +	dev_set_drvdata(&pdev->dev, ccf);
> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (!irq) {
> +		dev_err(&pdev->dev, "%s: no irq\n", __func__);
> +		return -ENXIO;
> +	}
> +
> +	ret = devm_request_irq(&pdev->dev, irq, ccf_irq, 0, pdev->name, ccf);
> +	if (ret) {
> +		dev_err(&pdev->dev, "%s: can't request irq\n", __func__);
> +		return ret;
> +	}
> +
> +	switch (ccf->info->version) {
> +	case CCF1:
> +		/* On CCF1 this register enables rather than disables. */
> +		iowrite32be(ERRDET_LAE | ERRDET_CV, &ccf->err_regs->errdis);
> +		break;
> +
> +	case CCF2:
> +		iowrite32be(0, &ccf->err_regs->errdis);
> +		iowrite32be(ERRDET_LAE | ERRDET_CV, &ccf->err_regs->errinten);
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> +static int ccf_remove(struct platform_device *pdev) {
> +	struct ccf_private *ccf = dev_get_drvdata(&pdev->dev);
> +
> +	switch (ccf->info->version) {
> +	case CCF1:
> +		iowrite32be(0, &ccf->err_regs->errdis);
> +		break;
> +
> +	case CCF2:
> +		iowrite32be(0, &ccf->err_regs->errinten);

Do you think it is same to disable detection bits in ccf->err_regs->errdis?

Thanks
-Bharat

> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> +static struct platform_driver ccf_driver = {
> +	.driver = {
> +		.name = KBUILD_MODNAME,
> +		.owner = THIS_MODULE,
> +		.of_match_table = ccf_matches,
> +	},
> +	.probe = ccf_probe,
> +	.remove = ccf_remove,
> +};
> +
> +module_platform_driver(ccf_driver);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Freescale Semiconductor"); MODULE_DESCRIPTION("Freescale
> +CoreNet Coherency Fabric error reporting");
> --
> 1.9.1
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
