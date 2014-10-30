Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759777AbaJ3MmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 08:42:25 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:33449 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759431AbaJ3MmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 08:42:23 -0400
Message-ID: <54523224.3010407@collabora.co.uk>
Date: Thu, 30 Oct 2014 13:42:12 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
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
Subject: Re: [RFT v3 06/14] regulator: max77802: Remove support for board
 files
References: <1414668053-31370-1-git-send-email-k.kozlowski@samsung.com> <1414668053-31370-7-git-send-email-k.kozlowski@samsung.com> <54522615.7040002@collabora.co.uk> <1414671037.23399.2.camel@AMDC1943> <54522D2C.9050002@collabora.co.uk> <1414672235.23399.7.camel@AMDC1943>
In-Reply-To: <1414672235.23399.7.camel@AMDC1943>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

On 10/30/2014 01:30 PM, Krzysztof Kozlowski wrote:
tor_of_get_init_data() function?
>> > 
>> > The regulator_of_get_init_data() searches from dev->of_node or its child
>> > node.
>> > 
>> > But dev->of_node is NULL.
>> > 
>> > That's why of_compatible is needed.
>> 
>> Yes but regulator_register() does dev = config->dev and config->dev is set
>> to config.dev = iodev->dev in the driver probe function which is the
>> pdev->dev.parent (the PMIC struct device) that has an associated of_node.
>> 
>> So, regulator_of_get_init_data() will call of_get_child_by_name() passing
>> the PMIC of_node and the sub-node name that contains the regulators. That
>> is, whatever was set in desc->regulators_node and that should be enough.
> 
> I missed that one in max77802 (in max77686: config.dev = &pdev->dev).
> Now I wonder if it is proper to attach regulators to driver's parent
> device. Consider regulator_register, around line 3640:
> 	rdev->dev.parent = dev;
> The parent of regulators will be equal to parent of regulator driver -
> main MFD driver.
>

An early version of the max77802 regulator driver also set config.dev to
&pdev->dev but then Mark asked me if I was sure that it should not be the
MFD device instead.

I then read in regulator_register() that the rdev->dev.parent was set
to the device passed in config.dev as you said so I was convinced that it
should be the parent device instead.

Please take a look at [0] for that discussion.

Best regards,
Javier

[0]: https://lkml.org/lkml/2014/6/17/174
