Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197Ab3KVPzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 10:55:55 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:38704 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079Ab3KVPzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 10:55:52 -0500
X-AuditID: cbfec7f4-b7fee6d000004b2d-7e-528f7e86c95a
Message-id: <1385135748.27216.1.camel@AMDC1943>
Subject: Re: [PATCH v3 4/5] regulator: max14577: Add regulator driver for Maxim
 14577
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Date: Fri, 22 Nov 2013 16:55:48 +0100
In-reply-to: <20131122101551.GJ23067@lee--X1>
References: <1385109972-28059-1-git-send-email-k.kozlowski@samsung.com>
 <1385109972-28059-5-git-send-email-k.kozlowski@samsung.com>
 <20131122101551.GJ23067@lee--X1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYRjHeT1Xl8vjvPCiUDAKUVCTit5SRiDhC0GYFYZf8qRDhU1lpw2N
	Lho08zrNQpuXtGbOeUzcsrQ05l0TxXIopM4sKRMjULOgsprrg99+z8Pvz/+BhyVkIhnIpmdc
	UmoyeJWclpBjW8OOMP01Q/wB4xCDejtCUHtVG4XuLi7RaGbjE4XuD0xQqLy5gkD2X50ATaw0
	AzR+Y5VBC98GAdp03PJA1g/TFGrQm0g09byGRq0D8wyazTPTqKyylUT9ZrsHevy5kkRjRRRa
	6dWTx/2xWCcCXL/uYHCZYQ3gLuM8g5ubNmhsM4diq6WAxist9yg8N91N47rR09hmuo5Ln1gA
	Xrfuwe215+J2J0qiU5SqdJ1SE6FIkqRZxnuorBaY3bhcDHJBjW8h8GQhdwguOlooNwfASWcb
	XQgkrIxrBHDm++j/YR1AuzmfdFlSLgIWftUzLvblEmBetZFwMc0dhLYm078Ay/px++DE6hFX
	luCKaWhYsm43kNx+2GNxAhd7cmFwrvYp5S4wAyi+rd6WCC4Y3q57QLhPksMX+QWMe78X2sQv
	hPsIH/ijwkmWAc64I2LcoRl3aPWAsAB/pTY5S7iYqo4MF3i1oM1IDU/OVFuB+8MbneDh0LE+
	wLFA7iXtPFoaL6N4nZCj7gOQJeR+UvaqIV4mTeFzLis1mRc0WpVS6AMerGdgLlDc7CmKjRH/
	jEjGzO8bTOi1ZmRyfkZRPp66nLi5xjb59NtDXqmyf3Z4O7sHc6oW1s566RuGBa6LeiQmNGad
	rGgPmIreUghvfHVFv23ErqCopNiPL2enh7fOM8m6pTt83OEYKiq83Kq98izo1NSZ4FBDXAlZ
	MBQWVHLinTfql5NCGh8ZSmgE/i9TUVurvwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-22 at 10:15 +0000, Lee Jones wrote:
> > +#ifdef CONFIG_OF
> > +static int max14577_regulator_dt_parse_pdata(struct platform_device *pdev,
> > +					struct max14577_platform_data *pdata)
> > +{
> > +	struct max14577 *max14577 = dev_get_drvdata(pdev->dev.parent);
> > +	struct device_node *np;
> > +	struct max14577_regulator_platform_data *reg_pdata;
> > +	struct of_regulator_match rmatch;
> > +	int i, ret;
> > +
> > +	np = of_get_child_by_name(max14577->dev->of_node, "regulators");
> > +	if (!np)
> > +		return -EINVAL;
> 
> No need to do this. If instead you use a compatible string and set
> it's MFD cell's .of_compatible property, the MFD core will set
> pdev->dev.of_node for you.
> 
> > +	reg_pdata = devm_kzalloc(&pdev->dev, sizeof(*reg_pdata) *
> > +			     ARRAY_SIZE(supported_regulators), GFP_KERNEL);
> > +	if (!reg_pdata)
> > +		return -ENOMEM;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(supported_regulators); i++) {
> > +		rmatch.name = supported_regulators[i].name;
> > +		ret = of_regulator_match(&pdev->dev, np, &rmatch, 1);
> > +		if (ret != 1)
> > +			continue;
> > +		dev_dbg(&pdev->dev, "Found regulator %d/%s\n",
> > +				supported_regulators[i].id,
> > +				supported_regulators[i].name);
> > +		reg_pdata[i].id = supported_regulators[i].id;
> > +		reg_pdata[i].initdata = rmatch.init_data;
> > +		reg_pdata[i].of_node = rmatch.of_node;
> > +	}
> > +
> > +	pdata->regulators = reg_pdata;
> > +
> > +	return 0;
> > +}
> > +#else
> > +static int max14577_regulator_dt_parse_pdata(struct platform_device *pdev,
> > +					struct max14577_platform_data *pdata)
> > +{
> > +	return 0;
> > +}
> > +#endif
> 
> No need for this either. Just check for the device's of_node.
> 
> > +static int max14577_regulator_probe(struct platform_device *pdev)
> > +{
> > +	struct max14577 *max14577 = dev_get_drvdata(pdev->dev.parent);
> > +	struct max14577_platform_data *pdata = dev_get_platdata(max14577->dev);
> > +	int i, size;
> > +	struct regulator_config config = {};
> > +	struct regulator_dev **regulators;
> > +
> > +	if (!pdata) {
> > +		/* Parent must provide pdata */
> > +		dev_err(&pdev->dev, "No MFD driver platform data found.\n");
> > +		return -ENODEV;
> > +	}
> > +
> > +	if (max14577->dev->of_node) {
> > +		int ret = max14577_regulator_dt_parse_pdata(pdev, pdata);
> 
> This will overwrite pdata which is wrong.
> 
> pdata should always take precedence over DT.
> 
> <snip>
> 
> > +	for (i = 0; i < ARRAY_SIZE(supported_regulators); i++) {
> > +		/*
> > +		 * Index of supported_regulators[] is also the id and must
> > +		 * match index of pdata->regulators[].
> > +		 */
> > +		config.init_data = pdata->regulators[i].initdata;
> > +		config.of_node = pdata->regulators[i].of_node;
> 
> I still thing this is superfluous. Why don't you run though the nodes
> here instead of doing it in MFD and passing this stuff through?

I have rewritten the regulator init code (and DT parsing). I think it
reflects your comments. Please look at version 4 of patches.

Best regards,
Krzysztof

