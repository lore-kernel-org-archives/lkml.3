Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643Ab3LJApD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 19:45:03 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:8378 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750750Ab3LJApA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 19:45:00 -0500
Date: Tue, 10 Dec 2013 00:41:41 -0800
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 2/3] pinctrl: Add msm8x74 configuration
Message-ID: <20131210084140.GF11990@sonymobile.com>
References: <1386295805-13708-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1386295805-13708-3-git-send-email-bjorn.andersson@sonymobile.com>
 <52A24E08.706@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <52A24E08.706@codeaurora.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 06 Dec 14:22 PST 2013, Stephen Boyd wrote:

> > +config PINCTRL_MSM8X74
> > +	bool "Qualcomm 8x74 pin controller driver"
> > +	select PINCTRL_MSM
> 
> No help?
> 

I could write something up, although I guess someone will add a
select PINCTRL_MSM8X74 in the mach-msm Kconfig and then we're done
with it.

> > +		.ctl_reg = 0x1000 + 0x10 * id ,		\
> 
> Weird trailing space here.
> 

Oops.

> Also, do we ever plan to have anything more than the gpio pins and the
> sdc pins? It seems like we spend a lot of space describing exactly the
> same thing in these structs for each of the 146 gpio pins when we could
> just know that range 0 to 146 is gpio pins and have different code for
> that part vs the 6 or something sd pins.
> 

We have to have a pingroup list, so I did look at having that list
referencing a common object with the gpio/sdc specific data.

But just having it in one large blob is the way that other pinctrl
drivers does it and hence a common problem to pinctrl and multi-platform
arm support.

I have not seen any code in the open referencing the other pins, so I
left them out for now.

> > +
> > +static struct of_device_id msm8x74_pinctrl_of_match[] = {
> 
> const?
> 

Of course.

> >
> > +
> > +static int __init msm8x74_pinctrl_init(void)
> > +{
> > +	return platform_driver_register(&msm8x74_pinctrl_driver);
> > +}
> > +arch_initcall(msm8x74_pinctrl_init);
> > +
> > +static void __exit msm8x74_pinctrl_exit(void)
> > +{
> > +	platform_driver_unregister(&msm8x74_pinctrl_driver);
> > +}
> > +module_exit(msm8x74_pinctrl_exit);
> 
> Why not module_platform_driver()? I thought pinctrl supported deferred
> probing?
> 

As this pinctrl/gpiochip/interrupt-controller is a fairly central part
of the system there's plenty of things that would just end up being deferred.

Most other pinctrl driver does arch_initcall or core_initcall, so I followed
suit and brought it in early.

Regards,
Bjorn
