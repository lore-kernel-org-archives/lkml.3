Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab3KVNA6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 08:00:58 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:39427 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560Ab3KVNA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 08:00:56 -0500
X-AuditID: cbfee61a-b7f4b6d00000761f-20-528f5585c7e4
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
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
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v3 4/5] regulator: max14577: Add regulator driver for Maxim
 14577
Date: Fri, 22 Nov 2013 14:00:44 +0100
Message-id: <5314519.ORHTDE3qkF@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1385109972-28059-5-git-send-email-k.kozlowski@samsung.com>
References: <1385109972-28059-1-git-send-email-k.kozlowski@samsung.com>
 <1385109972-28059-5-git-send-email-k.kozlowski@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA03RbUhTURjAcc7u3d11ujoulyeNgoGIYuYw4mBmhV9uEJUDCwTJqTeVNh27
	vhbUlNQ2wU3E1JUvRaFbWjmVmUnOOcmQ7EVTa75UitkKkbQSEqk5Ar/9nvP8eb4cmhA/J4Po
	rOxcVpOtUEopITmyOQ8PlCUa5FFarRAPdIfhmk8LFJ5c+8LHTc5RPq4yVxPYvtED8KjbDPC3
	JRl+WfJdgOd+DgH8a/wGD1vnJ/j4Ttk9Eo/13qZwu3NGgF3FrRQ21raTeLDVzsMPv9aSeKSC
	j90DZeRxCdPW2AaY5tVxAWM0/ADME9OMgDG3rFFMZ2s4Y7XoKMb9oJ7PTE/0UUzjiwSm8941
	prLLAphV6z6moyHx7I4kYWw6q8zKZzUH41KEmZMrfZTatrNwfGOJ0II6Pz3woRE8hKY+mkiv
	d6PXs48oPRDSYngXoDejbYR3uM5Dc+1OwlNRMAZVlVuAxwFQhgae2ngeE3CdjyrdJzzeBc+j
	4lumrZ6EIai61/7PNC2CYchQf9HzLIEnUY/NTHnsAxlkdtRt5WJYClDX0BmPRdAfrVfPkt7z
	+9Gz/hq+1xGov/QmZQTQtC0zbctM27JmQFiAhFWnqbnUDJUsklOouLzsjMi0HJUVbH3vYlAP
	MGuxA0AaSP1EMLZSLuYr8rkilQMgmpAGiMqPGuRiUbqi6DKrybmgyVOynAME06Q0UGQvPZIg
	hhmKXPYSy6pZzf8tj/YJ0oLCEbUrWDp4/3Ryo/+xprFuY0pEQmpHaEXS5wXBe4Z7tclVDIUm
	j9p8P+gKVmKi4vuvLF4NcGrrNVr9nsXDyyWyiLaJ1YaQ4d63LV3FI1PK5VNZczqdc6/etRRn
	fVwQ6BymVepz8Tkuf5D6+92gUCf25f5EFxDREscEmpVPS0kuUyELJzSc4i+1ORI92gIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Friday, November 22, 2013 09:46:11 AM Krzysztof Kozlowski wrote:

[...]

> +static int max14577_regulator_probe(struct platform_device *pdev)
> +{
> +	struct max14577 *max14577 = dev_get_drvdata(pdev->dev.parent);
> +	struct max14577_platform_data *pdata = dev_get_platdata(max14577->dev);
> +	int i, size;
> +	struct regulator_config config = {};
> +	struct regulator_dev **regulators;
> +
> +	if (!pdata) {
> +		/* Parent must provide pdata */
> +		dev_err(&pdev->dev, "No MFD driver platform data found.\n");
> +		return -ENODEV;
> +	}
> +
> +	if (max14577->dev->of_node) {
> +		int ret = max14577_regulator_dt_parse_pdata(pdev, pdata);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	size = sizeof(struct regulator_dev *) * ARRAY_SIZE(supported_regulators);
> +	regulators = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
> +	if (!regulators) {
> +		dev_err(&pdev->dev, "Cannot allocate memory for regulators\n");
> +		return -ENOMEM;
> +	}
> +
> +	config.dev = &pdev->dev;
> +	config.regmap = max14577->regmap;
> +
> +	for (i = 0; i < ARRAY_SIZE(supported_regulators); i++) {
> +		/*
> +		 * Index of supported_regulators[] is also the id and must
> +		 * match index of pdata->regulators[].
> +		 */
> +		config.init_data = pdata->regulators[i].initdata;
> +		config.of_node = pdata->regulators[i].of_node;
> +
> +		regulators[i] = devm_regulator_register(&pdev->dev,
> +				&supported_regulators[i], &config);
> +		if (IS_ERR(regulators[i])) {
> +			int ret = PTR_ERR(regulators[i]);

This can be cleaned up further.  The code just needs a single "struct
regulator_dev *regulator" (which can be declared inside "for" loop)
instead of an array.

> +			dev_err(&pdev->dev,
> +					"Regulator init failed for ID %d with error: %d\n",
> +					i, ret);
> +			return ret;
> +		}
> +	}
> +
> +	return 0;
> +}

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

