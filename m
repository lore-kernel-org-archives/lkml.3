Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab3KVJ6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 04:58:11 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:22562 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242Ab3KVJ6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 04:58:04 -0500
X-AuditID: cbfec7f5-b7fe66d00000432e-ab-528f2aa9f721
Message-id: <1385114279.29083.7.camel@AMDC1943>
Subject: Re: [PATCH v3 3/5] charger: max14577: Add charger support for Maxim
 14577
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Alexander Shiyan <shc_work@mail.ru>
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
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Fri, 22 Nov 2013 10:57:59 +0100
In-reply-to: <1385110476.285183224@f131.i.mail.ru>
References: <1385109972-28059-1-git-send-email-k.kozlowski@samsung.com>
 <1385109972-28059-4-git-send-email-k.kozlowski@samsung.com>
 <1385110476.285183224@f131.i.mail.ru>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsVy+t/xa7ortfqDDLqumFkc3KppsXHGelaL
	qQ+fsFlc//Kc1WL+kXOsFhNXTma2OPBnB6PFuVcrGS3ONr1ht7j/9SijxbcrHUwWmx5fY7VY
	2LaExeLyrjlsFmuP3GW3uN24gs1iwvS1LBaHVxxgslj3cjqLxeluVotJO6QsXh1sY3EQ81gz
	bw2jx4LPV9g9JvR/YvTYOesuu8fK5V/YPDav0PLYtKqTzePV6pmsHneu7WHzmHcy0GPzknqP
	KXOPsHr0bVnF6PF5k5zHxrmhAfxRXDYpqTmZZalF+nYJXBmPr/5hLdjFVbFw4jqWBsYTHF2M
	nBwSAiYSLRfbWCFsMYkL99azdTFycQgJLGWUWNxzhRHC+cwocevqMjaQKl4BfYm7+5+C2cIC
	IRLzz89kArHZBIwlNi9fAhYXEVCXWPRwOwtIM7PABjaJP/vngK1gEVCVuHmgmx3E5hQwkni/
	rA1qw1pGiYePV4IVMQN1T5q3iBniJiWJ3e2d7BBxeYnNa94yQ1whKPFj8j2WCYwCs5C0zEJS
	NgtJ2QJG5lWMoqmlyQXFSem5RnrFibnFpXnpesn5uZsYIXH9dQfj0mNWhxgFOBiVeHh3WPYF
	CbEmlhVX5h5ilOBgVhLh/afaHyTEm5JYWZValB9fVJqTWnyIkYmDU6qBsUlVqSv9yCaRy3WL
	hH4vzcngvcaWeF3nxZaf3/nXZoZ3rJrz5pgEx+3iz92lApV/vBcm/tbuVD5UcfP6aZny9v+x
	1rNiQs5OerFhwZJzPIvfflKTYxCOyj/GYaP8Q1K5x6TM69SLT30VxxxL3xg166TEnTmZxfQh
	tm25nJPwteWr/7Au5cgRVmIpzkg01GIuKk4EAC7RX0rJAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2013-11-22 at 12:54 +0400, Alexander Shiyan wrote:
> > MAX14577 chip is a multi-function device which includes MUIC, charger
> > and voltage regulator. The driver is located in drivers/mfd.
> > 
> > This patch supports battery charging control of MAX14577 chip and
> > provides power supply class information to userspace.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ...
> > diff --git a/drivers/power/max14577_charger.c b/drivers/power/max14577_charger.c
> ...
> > +static struct platform_driver max14577_charger_driver = {
> > +	.driver = {
> > +		.owner	= THIS_MODULE,
> > +		.name	= "max14577-charger",
> > +	},
> > +	.probe		= max14577_charger_probe,
> > +	.remove		= max14577_charger_remove,
> > +};
> > +
> > +static int __init max14577_charger_init(void)
> > +{
> > +	return platform_driver_register(&max14577_charger_driver);
> > +}
> > +
> > +static void __exit max14577_charger_exit(void)
> > +{
> > +	platform_driver_unregister(&max14577_charger_driver);
> > +}
> > +
> > +module_init(max14577_charger_init);
> > +module_exit(max14577_charger_exit);
> 
> Replace "module_init" & "module_exit" with module_platform_driver here.

Sure, thanks for pointing this.

Best regards,
Krzysztof


