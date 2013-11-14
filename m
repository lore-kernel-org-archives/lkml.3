Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab3KNJRj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 04:17:39 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:43263 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab3KNJRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 04:17:36 -0500
X-AuditID: cbfec7f4-b7fee6d000004b2d-07-5284952e7086
Message-id: <1384420652.17137.3.camel@AMDC1943>
Subject: Re: [PATCH 4/4] regulator: max14577: Add regulator driver for Maxim
 14577
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Date: Thu, 14 Nov 2013 10:17:32 +0100
In-reply-to: <20131113132338.GG878@sirena.org.uk>
References: <1384328457-5147-1-git-send-email-k.kozlowski@samsung.com>
 <1384328457-5147-5-git-send-email-k.kozlowski@samsung.com>
 <20131113132338.GG878@sirena.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsVy+t/xq7p6U1uCDNo2i1sc3KppsXHGelaL
	qQ+fsFlc//Kc1WL+kXOsFhNXTma2OPBnB6PF2aY37Bb3vx5ltPh2pYPJ4vKuOWwWa4/cZbe4
	3biCzeLwigNMFqe7WR34PRZ8vsLuMaH/E6PHzll32T02r9Dy2LSqk83jzrU9bB7zTgZ69G1Z
	xejxeZNcAGcUl01Kak5mWWqRvl0CV8anPwtYClZLVsze9o+tgXGJSBcjJ4eEgIlE19O5rBC2
	mMSFe+vZuhi5OIQEljJKTLx8igXC+cwocWX+YxaQKl4BfYm5fZvZQWxhgRCJhXf2MIPYbALG
	EpuXL2EDsUUElCWuft8L1swssIFF4tvzZ4wgCRYBVYmts6eCreMUMJSYvfo4I8SGVYwSa448
	BitiFlCXmDRvETPETUoSu9s72SHi8hKb17xlhrhCUOLH5HssExgFZiFpmYWkbBaSsgWMzKsY
	RVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQmLryw7GxcesDjEKcDAq8fAW7GwOEmJNLCuuzD3E
	KMHBrCTC+6ixJUiINyWxsiq1KD++qDQntfgQIxMHp1QDI4u3TZfh5ZifC1rXzVbca7HK9Pe5
	d+E7723N7C3sWeoS86zM8quv9cz2ZyfV4x1nuMmeC3vO9LeS/fadhpgDem+VnL+cY91V2xj/
	M9hv/5viO6X2Xv4bs+Vk5Nb22JkI3Eg9HWN85MHNZiZGEQ7bQlfjLatTXNa+UtKdxRYy8deE
	usfZZxdvV2Ipzkg01GIuKk4EAOSZGiKLAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-11-13 at 13:23 +0000, Mark Brown wrote:
> On Wed, Nov 13, 2013 at 08:40:57AM +0100, Krzysztof Kozlowski wrote:
> 
> > +static inline int max14577_reg_set_safeout(struct regmap *rmap, int on)
> > +{
> > +	u8 reg_data = (on ? 0x1 << CTRL2_SFOUTORD_SHIFT : 0x0);
> 
> The ternery operator is rarely helpful for legibility.
> 
> > +	case MAX14577_SAFEOUT:
> > +		max14577_read_reg(rmap, MAX14577_REG_CONTROL2, &reg_data);
> > +		return (reg_data & CTRL2_SFOUTORD_MASK) != 0;
> 
> regulator_is_enabled_regmap() and the other helpers should be used for
> this regulator.
> 
> > +static int max14577_reg_disable(struct regulator_dev *rdev)
> > +{
> > +	int rid = rdev_get_id(rdev);
> > +
> > +	switch (rid) {
> > +	case MAX14577_CHARGER:
> > +		return max14577_reg_set_charging(rdev->regmap, 0);
> > +	case MAX14577_SAFEOUT:
> > +		return max14577_reg_set_safeout(rdev->regmap, 0);
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +}
> 
> This sort of indirection isn't adding anything, just make the ops
> directly callable (and in the case of SAFEOUT use the helpers).
> 
> > +static int max14577_reg_get_current_limit(struct regulator_dev *rdev)
> > +{
> > +	if (rdev_get_id(rdev) != MAX14577_CHARGER)
> > +		return -EINVAL;
> > +
> > +	return max14577_reg_calc_charge_current(rdev->regmap);
> 
> Just inline the function, it's only called once.
> 
> > +	if (rdev_get_id(rdev) != MAX14577_CHARGER)
> > +		return -EINVAL;
> > +
> > +	dev_info(max14577->dev, "Requested current <%d, %d>\n", min_uA, max_uA);
> 
> Don't spam the logs like this, there's problems like this throughout the
> rest of the code.
> 
> > +static int max14577_regulator_dt_parse_pdata(struct platform_device *pdev,
> > +					struct max14577_platform_data *pdata)
> 
> No DT binding document.
> 
> > +static int max14577_regulator_probe(struct platform_device *pdev)
> > +{
> > +	struct max14577_regulator *max14577_reg;
> > +	struct max14577 *max14577 = dev_get_drvdata(pdev->dev.parent);
> > +	struct max14577_platform_data *pdata = dev_get_platdata(max14577->dev);
> > +	int i, ret, size;
> > +	struct regulator_config config = {};
> > +
> > +	if (!pdata) {
> > +		dev_err(&pdev->dev, "No platform data found.\n");
> > +		return -ENODEV;
> > +	}
> > +
> > +	if (max14577->dev->of_node) {
> > +		ret = max14577_regulator_dt_parse_pdata(pdev, pdata);
> > +		if (ret)
> > +			return ret;
> > +	}
> 
> The driver insists on platform data but then requires DT...
> 
> > +	size = sizeof(struct regulator_dev *) * pdata->num_regulators;
> > +	max14577_reg->regulators = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
> 
> You shouldn't be getting the number of regulators from platform data,
> the number of regulators physically present in the silicon isn't going
> to vary.
> 
> > +		max14577_reg->regulators[i] =
> > +			regulator_register(&supported_regulators[id], &config);
> 
> devm_regulator_register().

Thanks for review. I'll start working on issues.

> > +subsys_initcall(max14577_regulator_init);
> 
> Why is this subsys_initcall()?

Just like other regulators it should start before any other devices, for
example USB drivers.


Best regards,
Krzysztof

