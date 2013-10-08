Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab3JHNTf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:19:35 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:61356 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab3JHNTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:19:32 -0400
Date: Tue, 8 Oct 2013 15:17:27 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: plagnioj@jcrosoft.com, nicolas.ferre@atmel.com, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, alexandre.belloni@free-electrons.com,
        Bo Shen <voice.shen@atmel.com>
Subject: Re: [PATCH v5] PWM: atmel-pwm: add PWM controller driver
Message-ID: <20131008131727.GB12839@ulmo.nvidia.com>
References: <1380532240-18650-1-git-send-email-voice.shen@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b5gNqxB1S1yM7hjW"
Content-Disposition: inline
In-Reply-To: <1380532240-18650-1-git-send-email-voice.shen@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--b5gNqxB1S1yM7hjW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 30, 2013 at 05:10:40PM +0800, Bo Shen wrote:
> Add Atmel PWM controller driver based on PWM framework.
>=20
> This is the basic function implementation of Atmel PWM controller.
> It can work with PWM based led and backlight.
>=20
> Signed-off-by: Bo Shen <voice.shen@atmel.com>
>=20
> ---
> Changes in v5:
>   - call clk_disable directly, if so, it won't cause more than one channel
>     enabled, the clock can not be disabled.
>=20
> Changes in v4:
>   - check the return value of clk_prepare()
>   - change channel register size as constant
>=20
> Changes in v3:
>   - change compatible string from "atmel,sama5-pwm" to "atmel,sama5d3-pwm"
>   - Add PWM led example in binding documentation
>   - Using micro replace hard code
>=20
> Changes in v2:
>   - Address the comments from Thierry Reding
>=20
>  .../devicetree/bindings/pwm/atmel-pwm.txt          |   41 +++
>  drivers/pwm/Kconfig                                |    9 +
>  drivers/pwm/Makefile                               |    1 +
>  drivers/pwm/pwm-atmel.c                            |  344 ++++++++++++++=
++++++
>  4 files changed, 395 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pwm/atmel-pwm.txt
>  create mode 100644 drivers/pwm/pwm-atmel.c

I haven't seen an Acked-by from the device tree bindings maintainers on
this. I've Cc'ed them, so hopefully one of them has time to review.

Thierry

> diff --git a/Documentation/devicetree/bindings/pwm/atmel-pwm.txt b/Docume=
ntation/devicetree/bindings/pwm/atmel-pwm.txt
> new file mode 100644
> index 0000000..1c1a5fa
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pwm/atmel-pwm.txt
> @@ -0,0 +1,41 @@
> +Atmel PWM controller
> +
> +Required properties:
> +  - compatible: should be one of:
> +    - "atmel,at91sam9rl-pwm"
> +    - "atmel,sama5d3-pwm"
> +  - reg: physical base address and length of the controller's registers
> +  - #pwm-cells: Should be 3. See pwm.txt in this directory for a
> +    description of the cells format
> +
> +Example:
> +
> +	pwm0: pwm@f8034000 {
> +		compatible =3D "atmel,at91sam9rl-pwm";
> +		reg =3D <0xf8034000 0x400>;
> +		#pwm-cells =3D <3>;
> +	};
> +
> +The following the pwm led based example:
> +
> +	pwm0: pwm@f8034000 {
> +		compatible =3D "atmel,at91sam9rl-pwm";
> +		reg =3D <0xf8034000 0x400>;
> +		#pwm-cells =3D <3>;
> +	};
> +
> +	pwdleds {
> +		compatible =3D "pwm-leds";
> +
> +		d1 {
> +			label =3D "d1";
> +			pwms =3D <&pwm0 3 5000 0>
> +			max-brightness =3D <255>;
> +		};
> +
> +		d2 {
> +			label =3D "d2";
> +			pwms =3D <&pwm0 1 5000 1>
> +			max-brightness =3D <255>;
> +		};
> +	};
> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index 75840b5..54237b9 100644
> --- a/drivers/pwm/Kconfig
> +++ b/drivers/pwm/Kconfig
> @@ -41,6 +41,15 @@ config PWM_AB8500
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called pwm-ab8500.
> =20
> +config PWM_ATMEL
> +	tristate "Atmel PWM support"
> +	depends on ARCH_AT91
> +	help
> +	  Generic PWM framework driver for Atmel SoC.
> +
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called pwm-atmel.
> +
>  config PWM_ATMEL_TCB
>  	tristate "Atmel TC Block PWM support"
>  	depends on ATMEL_TCLIB && OF
> diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
> index 77a8c18..5b193f8 100644
> --- a/drivers/pwm/Makefile
> +++ b/drivers/pwm/Makefile
> @@ -1,6 +1,7 @@
>  obj-$(CONFIG_PWM)		+=3D core.o
>  obj-$(CONFIG_PWM_SYSFS)		+=3D sysfs.o
>  obj-$(CONFIG_PWM_AB8500)	+=3D pwm-ab8500.o
> +obj-$(CONFIG_PWM_ATMEL)		+=3D pwm-atmel.o
>  obj-$(CONFIG_PWM_ATMEL_TCB)	+=3D pwm-atmel-tcb.o
>  obj-$(CONFIG_PWM_BFIN)		+=3D pwm-bfin.o
>  obj-$(CONFIG_PWM_IMX)		+=3D pwm-imx.o
> diff --git a/drivers/pwm/pwm-atmel.c b/drivers/pwm/pwm-atmel.c
> new file mode 100644
> index 0000000..b4df36c
> --- /dev/null
> +++ b/drivers/pwm/pwm-atmel.c
> @@ -0,0 +1,344 @@
> +/*
> + * Driver for Atmel Pulse Width Modulation Controller
> + *
> + * Copyright (C) 2013 Atmel Corporation
> + *		 Bo Shen <voice.shen@atmel.com>
> + *
> + * Licensed under GPLv2.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/platform_device.h>
> +#include <linux/pwm.h>
> +#include <linux/slab.h>
> +
> +/* The following is global registers for PWM controller */
> +#define PWM_ENA			0x04
> +#define PWM_DIS			0x08
> +#define PWM_SR			0x0C
> +/* bit field in SR */
> +#define PWM_SR_ALL_CH_ON	0x0F
> +
> +/* The following register is PWM channel related registers */
> +#define PWM_CH_REG_OFFSET	0x200
> +#define PWM_CH_REG_SIZE		0x20
> +
> +#define PWM_CMR			0x0
> +/* bit field in CMR */
> +#define PWM_CMR_CPOL		(1 << 9)
> +#define PWM_CMR_UPD_CDTY	(1 << 10)
> +
> +/* The following registers for PWM v1 */
> +#define PWMv1_CDTY		0x04
> +#define PWMv1_CPRD		0x08
> +#define PWMv1_CUPD		0x10
> +
> +/* The following registers for PWM v2 */
> +#define PWMv2_CDTY		0x04
> +#define PWMv2_CDTYUPD		0x08
> +#define PWMv2_CPRD		0x0C
> +#define PWMv2_CPRDUPD		0x10
> +
> +/* max value for duty and period */
> +/*
> + * Although the duty and period register is 32 bit,
> + * however only the LSB 16 bits are significant.
> + */
> +#define PWM_MAX_DTY		0xFFFF
> +#define PWM_MAX_PRD		0xFFFF
> +#define PRD_MAX_PRES		10
> +
> +struct atmel_pwm_chip {
> +	struct pwm_chip chip;
> +	struct clk *clk;
> +	void __iomem *base;
> +
> +	void (*config)(struct pwm_chip *chip, struct pwm_device *pwm,
> +		       int dty, int prd);
> +};
> +
> +static inline struct atmel_pwm_chip *to_atmel_pwm_chip(struct pwm_chip *=
chip)
> +{
> +	return container_of(chip, struct atmel_pwm_chip, chip);
> +}
> +
> +static inline u32 atmel_pwm_readl(struct atmel_pwm_chip *chip,
> +				  unsigned long offset)
> +{
> +	return readl(chip->base + offset);
> +}
> +
> +static inline void atmel_pwm_writel(struct atmel_pwm_chip *chip,
> +				    unsigned long offset, unsigned long val)
> +{
> +	writel(val, chip->base + offset);
> +}
> +
> +static inline u32 atmel_pwm_ch_readl(struct atmel_pwm_chip *chip,
> +				     unsigned int ch, unsigned long offset)
> +{
> +	return readl(chip->base + PWM_CH_REG_OFFSET + ch * PWM_CH_REG_SIZE
> +		     + offset);
> +}
> +
> +static inline void atmel_pwm_ch_writel(struct atmel_pwm_chip *chip,
> +				       unsigned int ch, unsigned long offset,
> +				       unsigned long val)
> +{
> +	writel(val, chip->base + PWM_CH_REG_OFFSET + ch * PWM_CH_REG_SIZE
> +	       + offset);
> +}
> +
> +static int atmel_pwm_config(struct pwm_chip *chip, struct pwm_device *pw=
m,
> +		int duty_ns, int period_ns)
> +{
> +	struct atmel_pwm_chip *atmel_pwm =3D to_atmel_pwm_chip(chip);
> +	unsigned long clk_rate, prd, dty;
> +	unsigned long long div;
> +	int ret, pres =3D 0;
> +
> +	clk_rate =3D clk_get_rate(atmel_pwm->clk);
> +	div =3D clk_rate;
> +
> +	/* Calculate the period cycles */
> +	while (div > PWM_MAX_PRD) {
> +		div =3D clk_rate / (1 << pres);
> +		div =3D div * period_ns;
> +		/* 1/Hz =3D 100000000 ns */
> +		do_div(div, 1000000000);
> +
> +		if (pres++ > PRD_MAX_PRES) {
> +			pr_err("PRES is bigger than maximum pre-scaler\n");
> +			return -EINVAL;
> +		}
> +	}
> +
> +	/* Calculate the duty cycles */
> +	prd =3D div;
> +	div *=3D duty_ns;
> +	do_div(div, period_ns);
> +	dty =3D div;
> +
> +	ret =3D clk_enable(atmel_pwm->clk);
> +	if (ret) {
> +		pr_err("Failed to enable pwm clock\n");
> +		return ret;
> +	}
> +
> +	atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWM_CMR, pres);
> +	atmel_pwm->config(chip, pwm, dty, prd);
> +
> +	clk_disable(atmel_pwm->clk);
> +
> +	return 0;
> +}
> +
> +static void atmel_pwm_config_v1(struct pwm_chip *chip, struct pwm_device=
 *pwm,
> +				int dty, int prd)
> +{
> +	struct atmel_pwm_chip *atmel_pwm =3D to_atmel_pwm_chip(chip);
> +	unsigned int val;
> +
> +	/*
> +	 * If the PWM channel is disabled, write value to duty and period
> +	 * registers directly.
> +	 * If the PWM channel is enabled, using the update register, it needs
> +	 * to set bit 10 of CMR to 0
> +	 */
> +	if (test_bit(PWMF_ENABLED, &pwm->flags)) {
> +		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMv1_CUPD, dty);
> +
> +		val =3D atmel_pwm_ch_readl(atmel_pwm, pwm->hwpwm, PWM_CMR);
> +		val &=3D ~PWM_CMR_UPD_CDTY;
> +		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWM_CMR, val);
> +	} else {
> +		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMv1_CDTY, dty);
> +		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMv1_CPRD, prd);
> +	}
> +}
> +
> +static void atmel_pwm_config_v2(struct pwm_chip *chip, struct pwm_device=
 *pwm,
> +				int dty, int prd)
> +{
> +	struct atmel_pwm_chip *atmel_pwm =3D to_atmel_pwm_chip(chip);
> +
> +	/*
> +	 * If the PWM channel is disabled, write value to duty and period
> +	 * registers directly.
> +	 * If the PWM channel is enabled, using the duty update register to
> +	 * update the value.
> +	 */
> +	if (test_bit(PWMF_ENABLED, &pwm->flags)) {
> +		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMv2_CDTYUPD, dty);
> +	} else {
> +		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMv2_CDTY, dty);
> +		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMv2_CPRD, prd);
> +	}
> +}
> +
> +static int atmel_pwm_set_polarity(struct pwm_chip *chip, struct pwm_devi=
ce *pwm,
> +		enum pwm_polarity polarity)
> +{
> +	struct atmel_pwm_chip *atmel_pwm =3D to_atmel_pwm_chip(chip);
> +	u32 val =3D 0;
> +	int ret;
> +
> +	ret =3D clk_enable(atmel_pwm->clk);
> +	if (ret) {
> +		pr_err("failed to enable pwm clock\n");
> +		return ret;
> +	}
> +
> +	if (polarity =3D=3D PWM_POLARITY_NORMAL)
> +		val &=3D ~PWM_CMR_CPOL;
> +	else
> +		val |=3D PWM_CMR_CPOL;
> +
> +	atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWM_CMR, val);
> +
> +	clk_disable(atmel_pwm->clk);
> +
> +	return 0;
> +}
> +
> +static int atmel_pwm_enable(struct pwm_chip *chip, struct pwm_device *pw=
m)
> +{
> +	struct atmel_pwm_chip *atmel_pwm =3D to_atmel_pwm_chip(chip);
> +	int ret;
> +
> +	ret =3D clk_enable(atmel_pwm->clk);
> +	if (ret) {
> +		pr_err("failed to enable pwm clock\n");
> +		return ret;
> +	}
> +
> +	atmel_pwm_writel(atmel_pwm, PWM_ENA, 1 << pwm->hwpwm);
> +
> +	return 0;
> +}
> +
> +static void atmel_pwm_disable(struct pwm_chip *chip, struct pwm_device *=
pwm)
> +{
> +	struct atmel_pwm_chip *atmel_pwm =3D to_atmel_pwm_chip(chip);
> +
> +	atmel_pwm_writel(atmel_pwm, PWM_DIS, 1 << pwm->hwpwm);
> +
> +	clk_disable(atmel_pwm->clk);
> +}
> +
> +static const struct pwm_ops atmel_pwm_ops =3D {
> +	.config =3D atmel_pwm_config,
> +	.set_polarity =3D atmel_pwm_set_polarity,
> +	.enable =3D atmel_pwm_enable,
> +	.disable =3D atmel_pwm_disable,
> +	.owner =3D THIS_MODULE,
> +};
> +
> +struct atmel_pwm_data {
> +	void (*config)(struct pwm_chip *chip, struct pwm_device *pwm,
> +		       int dty, int prd);
> +};
> +
> +static const struct atmel_pwm_data atmel_pwm_data_v1 =3D {
> +	.config =3D atmel_pwm_config_v1,
> +};
> +
> +static const struct atmel_pwm_data atmel_pwm_data_v2 =3D {
> +	.config =3D atmel_pwm_config_v2,
> +};
> +
> +#ifdef CONFIG_OF
> +static const struct of_device_id atmel_pwm_dt_ids[] =3D {
> +	{
> +		.compatible =3D "atmel,at91sam9rl-pwm",
> +		.data =3D &atmel_pwm_data_v1,
> +	}, {
> +		.compatible =3D "atmel,sama5d3-pwm",
> +		.data =3D &atmel_pwm_data_v2,
> +	}, {
> +		/* sentinel */
> +	},
> +};
> +MODULE_DEVICE_TABLE(of, atmel_pwm_dt_ids);
> +#endif
> +
> +static int atmel_pwm_probe(struct platform_device *pdev)
> +{
> +	const struct of_device_id *of_id =3D
> +		of_match_device(atmel_pwm_dt_ids, &pdev->dev);
> +	const struct atmel_pwm_data *data;
> +	struct atmel_pwm_chip *atmel_pwm;
> +	struct resource *res;
> +	int ret;
> +
> +	atmel_pwm =3D devm_kzalloc(&pdev->dev, sizeof(*atmel_pwm), GFP_KERNEL);
> +	if (!atmel_pwm)
> +		return -ENOMEM;
> +
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res)
> +		return -ENODEV;
> +
> +	atmel_pwm->base =3D devm_ioremap_resource(&pdev->dev, res);
> +
> +	atmel_pwm->clk =3D devm_clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(atmel_pwm->clk))
> +		return PTR_ERR(atmel_pwm->clk);
> +
> +	ret =3D clk_prepare(atmel_pwm->clk);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to prepare pwm clock\n");
> +		return ret;
> +	}
> +
> +	atmel_pwm->chip.dev =3D &pdev->dev;
> +	atmel_pwm->chip.ops =3D &atmel_pwm_ops;
> +	atmel_pwm->chip.of_xlate =3D of_pwm_xlate_with_flags;
> +	atmel_pwm->chip.of_pwm_n_cells =3D 3;
> +	atmel_pwm->chip.base =3D -1;
> +	atmel_pwm->chip.npwm =3D 4;
> +
> +	data =3D of_id->data;
> +	atmel_pwm->config =3D data->config;
> +
> +	ret =3D pwmchip_add(&atmel_pwm->chip);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "failed to add pwm chip %d\n", ret);
> +		goto unprepare_clk;
> +	}
> +
> +	platform_set_drvdata(pdev, atmel_pwm);
> +
> +unprepare_clk:
> +	clk_unprepare(atmel_pwm->clk);
> +	return ret;
> +}
> +
> +static int atmel_pwm_remove(struct platform_device *pdev)
> +{
> +	struct atmel_pwm_chip *atmel_pwm =3D platform_get_drvdata(pdev);
> +
> +	clk_unprepare(atmel_pwm->clk);
> +
> +	return pwmchip_remove(&atmel_pwm->chip);
> +}
> +
> +static struct platform_driver atmel_pwm_driver =3D {
> +	.driver =3D {
> +		.name =3D "atmel-pwm",
> +		.of_match_table =3D of_match_ptr(atmel_pwm_dt_ids),
> +	},
> +	.probe =3D atmel_pwm_probe,
> +	.remove =3D atmel_pwm_remove,
> +};
> +module_platform_driver(atmel_pwm_driver);
> +
> +MODULE_ALIAS("platform:atmel-pwm");
> +MODULE_AUTHOR("Bo Shen <voice.shen@atmel.com>");
> +MODULE_DESCRIPTION("Atmel PWM driver");
> +MODULE_LICENSE("GPL v2");
> --=20
> 1.7.9.5
>=20

--b5gNqxB1S1yM7hjW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSVAXnAAoJEN0jrNd/PrOhTrAP/0A9zLCvUXnlgXBGRgGcX20J
BAP3d9PREVbJZJ4m0zGscVSW0NKB6otKLNz5Cky8ntp3otIuPi4tNdw7WlnLDsUe
B1ZXMHX6Oi0/X+kYPjRpIQ7hO/vFMqsGaoPE4K7cF7XN/E6BBPOTUsNJMnlwL0tA
NeKkv1ka4iafF5mVRQgvib7+8e1C8VuZKZciOkl5h/j/arreX4V3s/CZTddbTWOG
Lz3SaUH7S//M8pHXtra4p6IpXotu4Hf9iGHVmWTsFErq2Zg67sV3ja9l5/bGMBWA
X0j/pmXPz5AFD7/Qj92KsI5AQK9eJ6AuAj6UbK6l090/lYXAyai0YSgkK/Ts3GBu
cAPJgPUHAK+V3PwaOdruJBBQDWDQP7CKebjJie3vkEaT18PBn1z658uuipAmvGNe
Zd/87qSRXiywOYYggpLY9tVyqPw27HsjQsemZwOFA1MsVGVO5Wwelo+1oH8nMdOo
353KYQx+x/w2U7OJuTIa7pIZgO8qD5fN/t+q7n9FW62Hlq4qCY4sihsRBOx1wXw8
BdQYzzQOhP5sVWG+IGe6c66/u6n5riOo/UJ7jWr6OUHfLJLzfrn8SlRyVLakz9Z8
rfl4EbEj/y3Jh8pBmbEUxjsafz28fQea6aZTDUdPb5EN/l5ZbHq3PYJ4M2XO1aaX
B7FF5kNsKwejmErDfUyT
=JCE3
-----END PGP SIGNATURE-----

--b5gNqxB1S1yM7hjW--
