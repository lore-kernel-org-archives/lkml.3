Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab3KUNeZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 08:34:25 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:45918 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab3KUNeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 08:34:22 -0500
X-AuditID: cbfec7f5-b7fe66d00000432e-5a-528e0bdc9884
Message-id: <1385040858.748.27.camel@AMDC1943>
Subject: Re: [PATCH v2 1/5] mfd: max14577: Add max14577 MFD driver core
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
Date: Thu, 21 Nov 2013 14:34:18 +0100
In-reply-to: <20131121122011.GD23067@lee--X1>
References: <1384956732-19526-1-git-send-email-k.kozlowski@samsung.com>
 <1384956732-19526-2-git-send-email-k.kozlowski@samsung.com>
 <20131121103408.GA22536@lee--X1> <1385034199.748.21.camel@AMDC1943>
 <20131121122011.GD23067@lee--X1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsVy+t/xK7p3uPuCDA4uk7M4uFXTYuOM9awW
	Ux8+YbO4/uU5q8X8I+dYLSaunMxsceDPDkaLc69WMlqcbXrDbnH/61FGi29XOpgsNj2+xmqx
	sG0Ji8XlXXPYLNYeuctucbtxBZvFhOlrWSwOrzjAZLHu5XQWi9PdrBavDraxOIh6rJm3htFj
	wecr7B4T+j8xeuycdZfdY+XyL2wem1doeWxa1cnm8Wr1TFaPO9f2sHnMOxnosXlJvUffllWM
	Hp83yXlsnBsawBfFZZOSmpNZllqkb5fAlTH54Eamgt3sFXf27mRpYHzB2sXIySEhYCIxd14n
	E4QtJnHh3nq2LkYuDiGBpYwSO/5dZoRwPjNKND7dDFTFwcEroCex7bUOSIOwgLvEu1k97CA2
	m4CxxOblS9hASkQEVCTOvTEHaWUW6GGT6H+yCWwZi4CqxLJ/09hAbE4BXYlrRx+yQsx/xyjx
	7cE5ZpAEs4C6xKR5i5ghLlKS2N3eyQ4Rl5fYvOYtWJxXQFDix+R7LBMYBWYhaZmFpGwWkrIF
	jMyrGEVTS5MLipPSc430ihNzi0vz0vWS83M3MUIi+OsOxqXHrA4xCnAwKvHwPnjaEyTEmlhW
	XJl7iFGCg1lJhDfyY2+QEG9KYmVValF+fFFpTmrxIUYmDk6pBsb5BZ2nGAwv8LyYbLG9WPNE
	5tOHk9Tq/8+Zvi05J/aYlePuMwa2zIsvdXCxTErRv5jKUPf90VJdDY5PR8tPLmLYvMpArXRn
	qqzCXifLjiJdg67GY+85rsS27p13wl2kYXLCXaFjB17q33/if5drd8yk6803bgvNXPrZ8pbD
	I0/bENnXV4TUjdKUWIozEg21mIuKEwEPYzbzvgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2013-11-21 at 12:20 +0000, Lee Jones wrote:
(...)
> > > > +struct max14577_regulator_platform_data {
> > > > +	int id;
> > > > +	struct regulator_init_data *initdata;
> > > > +	struct device_node *of_node;
> > > 
> > > Do you ever set this? What's the point of it is it's set in the device?
> > 
> > Do you mean the whole struct max14577_regulator_platform_data or only
> > some member of it (of_node?)?
> 
> Initially only the of_node. Usually MFD children are able to call back
> into their parent to fetch these details. Also mfd_add_device() goes
> out of its way to fill in the child's own of_node.

The of_node is needed for regulator driver. It is passed in struct regulator_config
to devm_regulator_register():
	config.of_node = pdata->regulators[i].of_node;
	info->regulators[i] = devm_regulator_register(&pdev->dev,
	                              &supported_regulators[id], &config);


Best regards,
Krzysztof

