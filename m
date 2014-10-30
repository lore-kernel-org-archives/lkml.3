Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249AbaJ3HuE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 03:50:04 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:28837 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaJ3HuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 03:50:01 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-8d-5451eda525d9
Message-id: <1414655396.5114.10.camel@AMDC1943>
Subject: Re: [RFT v2 2/8] regulator: max77802: Remove support for board files
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Date: Thu, 30 Oct 2014 08:49:56 +0100
In-reply-to: <54517B37.9010305@collabora.co.uk>
References: <1414595206-1437-1-git-send-email-k.kozlowski@samsung.com>
 <1414595206-1437-3-git-send-email-k.kozlowski@samsung.com>
 <54517B37.9010305@collabora.co.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsVy+t/xa7pL3waGGGyfa22xccZ6VotJ6w4w
	WUx9+ITN4vqX56wW84+cY7U4+rvAonfBVTaLs01v2C3ufz3KaPHtSgeTxabH11gtLu+aw2Yx
	4/w+Jovbl3kt1h65y25xupvVQcCjpbmHzePv8+ssHn9XvWD22DnrLrvHplWdbB53ru1h85h3
	MtBj85J6j74tqxg9Pm+SC+CK4rJJSc3JLEst0rdL4MroWN7OWvBMvOLN20amBsYLQl2MnBwS
	AiYSzY9esUPYYhIX7q1n62Lk4hASWMoosevQPHYI5zOjxIdzh1m7GDk4eAX0JZZPywZpEBbw
	lbh19hBYM5uAscTm5UvYQGwRATuJG6sfMoP0MgscZpFY9OA6WIJFQFXizqWpzCA2J9CcBWcv
	skIsWMEoseHQVrBJzALqEpPmLWIGWSYhoCzR2O8GEuYVEJT4MfkeC0SJvMTmNW+ZJzAKzELS
	MQtJ2SwkZQsYmVcxiqaWJhcUJ6XnGukVJ+YWl+al6yXn525ihETa1x2MS49ZHWIU4GBU4uGN
	OBYQIsSaWFZcmXuIUYKDWUmEN/FyYIgQb0piZVVqUX58UWlOavEhRiYOTqkGxplJK/Ze+72p
	vvf+TWmtum6HiitOl5sErTg+KT4xPHzSSOKrz3Tel4su7mi9/HPlydfGjufNtX0WXb5iaKn1
	/lqc6/W3t6boNN93F9myrSZ5CtcBtiTGzGvV776bLz3wZgeL/gHpe/9u7md8Ya/oWNJ8acrn
	vRp3Iji35S6JT5RkkS7siO/vOqrEUpyRaKjFXFScCACQJkd9kgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-10-30 at 00:41 +0100, Javier Martinez Canillas wrote:
> Hello Krzysztof,
> 
> On 10/29/2014 04:06 PM, Krzysztof Kozlowski wrote:
> >  
> >  static int max77802_pmic_probe(struct platform_device *pdev)
> >  {
> >  	struct max77686_dev *iodev = dev_get_drvdata(pdev->dev.parent);
> > -	struct max77686_platform_data *pdata = dev_get_platdata(iodev->dev);
> >  	struct max77802_regulator_prv *max77802;
> >  	int i, ret = 0, val;
> >  	struct regulator_config config = { };
> > -
> > -	/* This is allocated by the MFD driver */
> > -	if (!pdata) {
> > -		dev_err(&pdev->dev, "no platform data found for regulator\n");
> > -		return -ENODEV;
> > -	}
> > +	struct of_regulator_match *rdata;
> >  
> >  	max77802 = devm_kzalloc(&pdev->dev,
> >  				sizeof(struct max77802_regulator_prv),
> > @@ -586,24 +558,29 @@ static int max77802_pmic_probe(struct platform_device *pdev)
> >  	if (!max77802)
> >  		return -ENOMEM;
> >  
> > -	if (iodev->dev->of_node) {
> > -		ret = max77802_pmic_dt_parse_pdata(pdev, pdata);
> > -		if (ret)
> > -			return ret;
> > -	}
> > -
> >  	config.dev = iodev->dev;
> >  	config.regmap = iodev->regmap;
> >  	config.driver_data = max77802;
> >  	platform_set_drvdata(pdev, max77802);
> >  
> > +	rdata = kzalloc(sizeof(*rdata) * MAX77802_REG_MAX, GFP_KERNEL);
> > +	if (!rdata)
> > +		return -ENOMEM;
> > +
> > +	for (i = 0; i < MAX77802_REG_MAX; i++)
> > +		rdata[i].name = regulators[i].name;
> > +
> > +	ret = max77802_pmic_dt_parse(pdev, rdata);
> > +	if (ret)
> > +		goto out;
> > +
> >  	for (i = 0; i < MAX77802_REG_MAX; i++) {
> >  		struct regulator_dev *rdev;
> > -		int id = pdata->regulators[i].id;
> > +		int id = regulators[i].id;
> >  		int shift = max77802_get_opmode_shift(id);
> >  
> > -		config.init_data = pdata->regulators[i].initdata;
> > -		config.of_node = pdata->regulators[i].of_node;
> > +		config.init_data = rdata[i].init_data;
> > +		config.of_node = rdata[i].of_node;
> >  
> >  		ret = regmap_read(iodev->regmap, regulators[i].enable_reg, &val);
> >  		val = val >> shift & MAX77802_OPMODE_MASK;
> > @@ -621,13 +598,17 @@ static int max77802_pmic_probe(struct platform_device *pdev)
> >  		rdev = devm_regulator_register(&pdev->dev,
> >  					       &regulators[i], &config);
> 
> Thanks for your patch. It's indeed an improvement over the old code and I can
> test it tomorrow when I've access to my machine with a max77802 PMIC.
> 
> However, I don't think this is the change that Mark asked. AFAIU what he wanted
> is to fill the struct regulator_desc .of_match and .regulators_node fields so
> the init_data is extracted by the core on regulator registration.
> 
> Look at commits a0c7b164 ("regulator: of: Provide simplified DT parsing method")
> and 93a127b ("regulator: isl9305: Convert to new style DT parsing") to see what
> I'm talking about.

Ooo, I missed these changes. This should simplify the code even more.
I'll re-spin, so don't hurry with testing :)

Best regards,
Krzysztof

