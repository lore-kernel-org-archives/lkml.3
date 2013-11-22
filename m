Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab3KVJ6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 04:58:21 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:17834 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242Ab3KVJ6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 04:58:16 -0500
X-AuditID: cbfec7f4-b7fee6d000004b2d-6c-528f2ab51144
Message-id: <1385114292.29083.8.camel@AMDC1943>
Subject: Re: [PATCH v3 1/5] mfd: max14577: Add max14577 MFD driver core
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
Date: Fri, 22 Nov 2013 10:58:12 +0100
In-reply-to: <20131122093118.GH23067@lee--X1>
References: <1385109972-28059-1-git-send-email-k.kozlowski@samsung.com>
 <1385109972-28059-2-git-send-email-k.kozlowski@samsung.com>
 <20131122093118.GH23067@lee--X1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsVy+t/xq7pbtfqDDKY3WFkc3KppsXHGelaL
	qQ+fsFlc//Kc1WL+kXOsFhNXTma2OPBnB6PFuVcrGS3ONr1ht7j/9SijxbcrHUwWmx5fY7VY
	2LaExeLyrjlsFmuP3GW3uN24gs1iwvS1LBaHVxxgslj3cjqLxeluVotXB9tYHEQ91sxbw+ix
	4PMVdo8J/Z8YPXbOusvusXL5FzaPzSu0PDat6mTzeLV6JqvHnWt72DzmnQz02Lyk3qNvyypG
	j8+b5Dw2zg0N4IvisklJzcksSy3St0vgypg98RlzwRSOim9tfg2M+9m6GDk5JARMJPYe+cYI
	YYtJXLi3HiwuJLCUUeLVL8cuRi4g+zOjxKk/q1lBErwC+hK71v8GaxAWcJeYseQ9mM0mYCyx
	efkSoGYODhEBFYlzb8xBepkFetgk+p9sYgWJswioSkw6GA9SzimgK3Hi0yRmiPkrGCXmXD3K
	DpJgFlCXmDRvETPEQUoSu9s7oeLyEpvXvGWGuEFQ4sfkeywTGAVmIWmZhaRsFpKyBYzMqxhF
	U0uTC4qT0nMN9YoTc4tL89L1kvNzNzFCovfLDsbFx6wOMQpwMCrx8O6w7AsSYk0sK67MPcQo
	wcGsJML7T7U/SIg3JbGyKrUoP76oNCe1+BAjEwenVAPjlN0m6UUKbyT3pFw35l51ssikb5Ki
	+lsDyc/3Jz0/Fc6/NS6lQuI9KzO3XdGawAj+09NPWfPOjcl9nXX98LttuwslVRc3H8rkne1X
	ZMrceUSPo1WoJavj4OvgVr4DmtNVfMpCZcNX8yw4b9O09JHLgkXnc/wW5yqnnCrm61bW/nJn
	puPheSuVWIozEg21mIuKEwEyL75lvAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2013-11-22 at 09:31 +0000, Lee Jones wrote:
(...)
> > +static struct mfd_cell max14577_devs[] = {
> > +	{ .name = "max14577-muic", },
> > +	{ .name = "max14577-regulator", },
> > +	{ .name = "max14577-charger", },
> > +};
> 
> If these all support device tree, shouldn't you be populating
> max14577_devs[x].of_compatible too? That way the MFD core will
> automatically setup your dev.of_node pointers for you?

Only the regulator driver uses bindings from DT and it searches for
"regulators" node in parent's node:
	np = of_get_child_by_name(max14577->dev->of_node, "regulators");
I can add of_compatible but I think this won't be reflected in actual
DTS.

> <snip>
> 
> > +	max14577->vendor_id = (reg_data & 0x7);
> > +	max14577->device_id = ((reg_data & 0xF8) >> 0x3);
> 
> I'm not too keen on these magic numbers, can you create #defines for
> them please? If there are any other interesting address, it might be
> worth creating some for those too.

OK, I'll define these.

Best regards,
Krzysztof

