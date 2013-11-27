Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab3K0EHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 23:07:36 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44807 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464Ab3K0EH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 23:07:28 -0500
Message-ID: <52956FA6.8020705@ti.com>
Date: Wed, 27 Nov 2013 09:35:58 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>
CC: Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@kernel.crashing.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 07/12] memory: davinci-aemif: introduce AEMIF driver
References: <1384187188-5776-1-git-send-email-ivan.khoronzhuk@ti.com>, <1384187188-5776-8-git-send-email-ivan.khoronzhuk@ti.com> <4F5844B3A985794BA902E12C070812375F8D2E@DNCE04.ent.ti.com> <52944BD3.90105@ti.com> <5294DE17.9080900@ti.com>
In-Reply-To: <5294DE17.9080900@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 November 2013 11:14 PM, ivan.khoronzhuk wrote:

>>> +static int davinci_aemif_probe(struct platform_device *pdev)
>>> +{
>>> +       int ret  = -ENODEV, i;
>>> +       struct resource *res;
>>> +       struct device *dev = &pdev->dev;
>>> +       struct device_node *np = dev->of_node;
>>> +
>>> +       if (np == NULL)
>>> +               return 0;
>>> +
>>> +       if (aemif) {
>>> +               dev_err(dev, "davinci_aemif driver is in use currently\n");
>>> +               return -EBUSY;
>>> +       }
>>
>> Why expressly prevent multiple AEMIF devices? Its entirely conceivable
>> to have two memories like NAND and NOR flash connect to two different
>> AEMIF interfaces.
>>
> 
> It can be, but I'm not sure if it is needed. Currently I've not seen case where
> more than 2 cses were used, I mean we have 2 cs free, why do we need the second AEMIF
> controller?

One usual reason is pinmux constraints. Its probably not a concern on
the device you are working with right now but as devices get smaller,
functionality on pins is multiplexed to handle multiple different use cases.

Thanks,
Sekhar
