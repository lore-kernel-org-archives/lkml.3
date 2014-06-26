Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434AbaFZKJR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 06:09:17 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:33423 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482AbaFZKJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 06:09:00 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7fac6d000006cfe-d5-53abf1381ed2
Content-transfer-encoding: 8BIT
Message-id: <1403777337.27156.19.camel@AMDC1943>
Subject: Re: [PATCH v4 10/14] regulator: Add driver for Maxim 77802 PMIC
 regulators
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 26 Jun 2014 12:08:57 +0200
In-reply-to: <1403723019-6212-11-git-send-email-javier.martinez@collabora.co.uk>
References: <1403723019-6212-1-git-send-email-javier.martinez@collabora.co.uk>
 <1403723019-6212-11-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: Evolution 3.10.4-0ubuntu1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42I5/e/4VV3Lj6uDDXb/ZbRYcvEqu8XUh0/Y
	LDb1b2W3mH/kHKvF2WUH2SyO/i6w6F1wlc3i/tejjBbfrnQwWWx6fI3V4vKuOWwWM87vY7J4
	OuEim8Wp65/ZLE53s1pMP/6W1aJv7SU2B0GP2Q0XWTz+Pr/O4rHj7hJGj52z7rJ7bFrVyeZx
	59oeNo95JwM9Ni+p97hyoonVo2/LKkaP6fN+Mnl83iQXwBPFZZOSmpNZllqkb5fAlbGjs5Op
	YLd2xaXGqewNjFeVuxg5OSQETCS+3r/MCmGLSVy4t56ti5GLQ0hgKaPE56MdjCAJXgFBiR+T
	77F0MXJwMAvISxy5lA0SZhZQl5g0bxEzRP1nRom3b+4yQ9QbSNzZ8gesV1ggVOL7qQ9gC9gE
	jCU2L1/CBmKLCNhJ3Fj9EKyZWeARi8QjqAYWAVWJ1VN+s4PYnAIBEreXvGOE2DCFUeJi73Fm
	iFOVJebtP8Y0gVFgFpIDZyEcOAvJgQsYmVcxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn525ihETi
	lx2Mi49ZHWIU4GBU4uGVmLs6WIg1say4MvcQowQHs5IIb+cdoBBvSmJlVWpRfnxRaU5q8SFG
	Jg5OqQZGo4CHwm7XJ3YvEg27+bqxQ/r7Cc0mbuFvx02YrV259k6xXv+t/UpBk1DoTS5/UY3t
	382lDnI8yZE7b36CJe5Yx42P6y8yPGjYp2hl6712vou289/OnfOnTdNZv/Rv9GSm93vi7iQr
	CVyvT+1X0bln6bh70ZOls2MeXZi3OO2YzKc9peLzNmisV2Ipzkg01GIuKk4EAM/IdNKiAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-06-25 at 21:03 +0200, Javier Martinez Canillas wrote:
> The MAX77802 PMIC has 10 high-efficiency Buck and 32 Low-dropout
> (LDO) regulators. This patch adds support for all these regulators
> found on the MAX77802 PMIC and is based on a driver added by Simon
> Glass to the Chrome OS kernel 3.8 tree.
> 
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
> 
> Changes since v3:
>  - Set the supply_name for regulators to lookup their parent supply node.
>    Suggested by Mark Brown.
>  - Change Exyno5 for Exynos5420/Exynos5800 in regulator driver Kconfig.
>    Suggested by Doug Anderson.
> 
> Changes since v2:
>  - Use dev_warn() instead pr_warn(). Suggested by Mark Brown.
>  - Add a generic function to regmap core to copy registers instead of
>    having a driver-specific function. Suggested by Mark Brown.
>  - Remove unnecessary probe debug log. Suggested by Mark Brown.
>  - Set struct regulator_config dev field to MFD instead of the platform dev.
>    Suggested by Mark Brown.
>  - Read the regulators operational mode from the hardware registers instead
>    of setting to normal as default on probe. Suggested by Mark Brown.
>  - Remove unnecessary cross-subsystem dependencies. Suggested by Lee Jones.
> 
> Changes since v1:
>  - Remove unneeded check if num_regulators != MAX77802_MAX_REGULATORS.
>  - Fix .set_suspend_mode handler comment and split regulators ops for
>    regulators that behave differently. Suggested by Mark Brown.
>  - Use module_platform_driver() instead of having init/exit functions.
>    Suggested by Mark Brown.
>  - Use the new descriptor-based GPIO interface instead of the deprecated
>    integer based GPIO one. Suggested by Mark Brown.
>  - Look for "regulators" child node instead of "voltage-regulators" to be
>    consistent with other PMIC drivers. Suggested by Mark Brown.

(...)

> +
> +static struct regulator_desc regulators[] = {
> +	regulator_77802_desc_16_buck(1),
> +	regulator_77802_desc_234_buck(2),
> +	regulator_77802_desc_234_buck(3),
> +	regulator_77802_desc_234_buck(4),
> +	regulator_77802_desc_buck5(5),
> +	regulator_77802_desc_16_buck(6),
> +	regulator_77802_desc_buck7_10(7),
> +	regulator_77802_desc_buck7_10(8),
> +	regulator_77802_desc_buck7_10(9),
> +	regulator_77802_desc_buck7_10(10),
> +	regulator_77802_desc_n_ldo(1, 10, 2),
> +	regulator_77802_desc_n_ldo(2, 10, 1),
> +	regulator_77802_desc_p_ldo(3, 3, 2),
> +	regulator_77802_desc_p_ldo(4, 6, 1),
> +	regulator_77802_desc_p_ldo(5, 3, 1),
> +	regulator_77802_desc_p_ldo(6, 3, 1),
> +	regulator_77802_desc_p_ldo(7, 3, 1),
> +	regulator_77802_desc_n_ldo(8, 1, 1),
> +	regulator_77802_desc_p_ldo(9, 5, 1),
> +	regulator_77802_desc_p_ldo(10, 4, 1),
> +	regulator_77802_desc_p_ldo(11, 4, 1),
> +	regulator_77802_desc_p_ldo(12, 9, 1),
> +	regulator_77802_desc_p_ldo(13, 4, 1),
> +	regulator_77802_desc_p_ldo(14, 4, 1),
> +	regulator_77802_desc_n_ldo(15, 1, 1),
> +	regulator_77802_desc_n_ldo(17, 2, 1),
> +	regulator_77802_desc_p_ldo(18, 7, 1),
> +	regulator_77802_desc_p_ldo(19, 5, 1),
> +	regulator_77802_desc_p_ldo(20, 7, 2),
> +	regulator_77802_desc_p_ldo(21, 6, 2),
> +	regulator_77802_desc_p_ldo(23, 9, 1),
> +	regulator_77802_desc_p_ldo(24, 6, 1),
> +	regulator_77802_desc_p_ldo(25, 9, 1),
> +	regulator_77802_desc_p_ldo(26, 9, 1),
> +	regulator_77802_desc_n_ldo(27, 2, 1),
> +	regulator_77802_desc_p_ldo(28, 7, 1),
> +	regulator_77802_desc_p_ldo(29, 7, 1),
> +	regulator_77802_desc_n_ldo(30, 2, 1),
> +	regulator_77802_desc_p_ldo(32, 9, 1),
> +	regulator_77802_desc_p_ldo(33, 6, 1),
> +	regulator_77802_desc_p_ldo(34, 9, 1),
> +	regulator_77802_desc_n_ldo(35, 2, 1),
> +};
> +
> +#ifdef CONFIG_OF
> +static int max77802_pmic_dt_parse_pdata(struct platform_device *pdev,
> +					struct max77802_platform_data *pdata)
> +{
> +	struct max77802_dev *iodev = dev_get_drvdata(pdev->dev.parent);
> +	struct device_node *pmic_np, *regulators_np;
> +	struct max77802_regulator_data *rdata;
> +	struct of_regulator_match rmatch;
> +	unsigned int i;
> +
> +	pmic_np = iodev->dev->of_node;
> +	regulators_np = of_get_child_by_name(pmic_np, "regulators");
> +	if (!regulators_np) {
> +		dev_err(&pdev->dev, "could not find regulators sub-node\n");
> +		return -EINVAL;
> +	}
> +
> +	pdata->num_regulators = ARRAY_SIZE(regulators);
> +	rdata = devm_kzalloc(&pdev->dev, sizeof(*rdata) *
> +			     pdata->num_regulators, GFP_KERNEL);
> +	if (!rdata) {
> +		of_node_put(regulators_np);
> +		return -ENOMEM;
> +	}
> +
> +	for (i = 0; i < pdata->num_regulators; i++) {
> +		rmatch.name = regulators[i].name;
> +		rmatch.init_data = NULL;
> +		rmatch.of_node = NULL;
> +		if (of_regulator_match(&pdev->dev, regulators_np, &rmatch,
> +				       1) != 1) {
> +			dev_warn(&pdev->dev, "No matching regulator for '%s'\n",
> +				 rmatch.name);
> +			continue;
> +		}
> +		rdata[i].initdata = rmatch.init_data;
> +		rdata[i].of_node = rmatch.of_node;
> +		rdata[i].id = regulators[i].id;
> +	}

I think instead of matching one by one you can alternatively match
everything at once:

static struct of_regulator_match regulator_matches[] = {
	{ .name = "LDO1", },
	....
};

if (of_regulator_match(&pdev->dev, regulators_np, regulator_matches,
			ARRAY_SIZE(regulator_matches)) {

The code would be smaller although you would have to create an array
with names of regulators. I'll leave it up to you since I don't have
preference for it.

Best regards,
Krzysztof



