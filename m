Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbaGCLqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 07:46:00 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:36208 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbaGCLp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 07:45:59 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-42-53b54274634a
Message-id: <1404387957.21377.9.camel@AMDC1943>
Subject: Re: [RESEND PATCH 3/5] charger: max14577: Configure battery-dependent
 settings from DTS
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Jenny Tc <jenny.tc@intel.com>
Date: Thu, 03 Jul 2014 13:45:57 +0200
In-reply-to: <20140703113645.GB28504@leverpostej>
References: <1404198121-22989-1-git-send-email-k.kozlowski@samsung.com>
 <1404198121-22989-4-git-send-email-k.kozlowski@samsung.com>
 <20140703113645.GB28504@leverpostej>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu1
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42I5/e/4Fd0Sp63BBlueyFlsnLGe1WLqwyds
	FpOevGe2mLhyMrNF/5uFrBbnXq1ktFj7tYfd4mzTG3aL+1+PMlp8u9LBZHF51xw2i7VH7rJb
	LL1+kcliwvS1LBate4+wW5zuZnUQ8Fgzbw2jx+W+XiaPnbPusnusXP6FzWPzCi2PxXteMnls
	WtXJ5nHn2h42j3knAz36tqxi9Pi8SS6AO4rLJiU1J7MstUjfLoEr48WuPewF+8UqFh1+y9rA
	uFKgi5GTQ0LAROLuzdNMELaYxIV769m6GLk4hASWMkqsuDqdHcL5zChx4OdRdpAqXgF9ibeb
	FrOA2MICSRJbH09hBbHZBIwlNi9fwgZiiwioS/Ts+sIC0sws8JtF4t3np2ArWARUJfbd3gnW
	zClgKHHh5wyoDWsYJc6s3Q42iRmoe9K8RcwQNylLzNt/jAlis6DEj8n3WCBq5CU2r3nLPIFR
	YBaSlllIymYhKVvAyLyKUTS1NLmgOCk911CvODG3uDQvXS85P3cTIyT2vuxgXHzM6hCjAAej
	Eg9v44oNwUKsiWXFlbmHGCU4mJVEeE84bA0W4k1JrKxKLcqPLyrNSS0+xMjEwSnVwLj4/CHv
	4ndPnl698U8tK/2s5jr/CXuiMt/bX4jsSeNS/75oTvotsakHvvvO+rJNqbD2XprcRK7+dUXc
	Jfy/3c3OvJp3QiNlzuHelN/CR9LuqbK6CKnNX8U5m28Fp+Hlab6JfIGbNim3SsXPn1LJZmYh
	sY3z7JXcdU/2c/X/Yimf7us4aUZlzTIlluKMREMt5qLiRABmjcZAmwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-07-03 at 12:36 +0100, Mark Rutland wrote:
> On Tue, Jul 01, 2014 at 08:01:58AM +0100, Krzysztof Kozlowski wrote:
> > Remove hard-coded values for:
> >  - Fast Charge current,
> >  - End Of Charge current,
> >  - Fast Charge timer,
> >  - Overvoltage Protection Threshold,
> >  - Battery Constant Voltage,
> > and use DTS to configure them. This allows using the max14577 charger
> > driver with different batteries.
> > 
> > Now the charger driver requires valid configuration data from DTS. In
> > case of wrong configuration data it fails during probe. Patch adds
> > of_compatible to the charger mfd cell in MFD driver core.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> > Cc: David Woodhouse <dwmw2@infradead.org>
> > Cc: Jenny Tc <jenny.tc@intel.com>
> > Acked-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/mfd/max14577.c               |   5 +-
> >  drivers/power/max14577_charger.c     | 232 +++++++++++++++++++++++++++++++----
> >  include/linux/mfd/max14577-private.h |  16 +++
> >  include/linux/mfd/max14577.h         |   8 ++
> >  4 files changed, 233 insertions(+), 28 deletions(-)
> 
> [...]
> 
> > +       pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
> > +       if (!pdata) {
> > +               dev_err(&pdev->dev, "Memory alloc for charger pdata failed\n");
> > +               return ERR_PTR(-ENOMEM);
> > +       }
> > +
> > +       ret = of_property_read_u32(np, "maxim,fast-charge-timer",
> > +                       &pdata->fast_charge_timer);
> > +       if (ret)
> > +               return ERR_PTR(ret);
> > +
> > +       ret = of_property_read_u32(np, "maxim,constant-uvolt",
> > +                       &pdata->constant_uvolt);
> > +       if (ret)
> > +               return ERR_PTR(ret);
> > +
> > +       ret = of_property_read_u32(np, "maxim,fast-charge-uamp",
> > +                       &pdata->fast_charge_uamp);
> > +       if (ret)
> > +               return ERR_PTR(ret);
> > +
> > +       ret = of_property_read_u32(np, "maxim,eoc-uamp", &pdata->eoc_uamp);
> > +       if (ret)
> > +               return ERR_PTR(ret);
> > +
> > +       ret = of_property_read_u32(np, "maxim,ovp-uvolt", &pdata->ovp_uvolt);
> > +       if (ret)
> > +               return ERR_PTR(ret);
> 
> None of the fields being read into are u32 per the structure definition
> below. Please use a u32 temporary variable or make the fields u32
> values.
> 
> It would also be a good idea to print a warning as to _which_ field is
> missing and/or invalid as that really helps someone writing a DTS to
> figure out why the device isn't probing.

Sure, thanks for feedback. I'll fix this and re-spin.

Best regards,
Krzysztof


