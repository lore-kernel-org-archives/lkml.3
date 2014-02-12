Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbaBLPrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 10:47:41 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:44572 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbaBLPrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 10:47:40 -0500
Date: Wed, 12 Feb 2014 15:46:38 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH 08/14] mfd: sec: Add support for S2MPS14
Message-ID: <20140212154638.GA20026@lee--X1>
References: <1392123837-5517-1-git-send-email-k.kozlowski@samsung.com>
 <1392123837-5517-9-git-send-email-k.kozlowski@samsung.com>
 <20140212091724.GS15081@lee--X1>
 <1392199417.22265.12.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392199417.22265.12.camel@AMDC1943>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Add support for S2MPS14 PMIC device to the MFD sec-core driver.
> > > The S2MPS14 is similar to S2MPS11 but it has fewer regulators, two
> > > clocks instead of three and a little different registers layout.
> > > 
> > > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > > ---
> > >  drivers/mfd/sec-core.c              |   48 +++++++++--
> > >  drivers/mfd/sec-irq.c               |   89 +++++++++++++++++++-
> > >  include/linux/mfd/samsung/core.h    |    1 +
> > >  include/linux/mfd/samsung/irq.h     |   27 +++++++
> > >  include/linux/mfd/samsung/rtc.h     |   56 +++++++++++--
> > >  include/linux/mfd/samsung/s2mps14.h |  152 +++++++++++++++++++++++++++++++++++
> > >  6 files changed, 361 insertions(+), 12 deletions(-)
> > >  create mode 100644 include/linux/mfd/samsung/s2mps14.h
> > > 
> > > diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
> > 
> > <snip>
> > 
> > > +static const struct mfd_cell s2mps14_devs[] = {
> > > +	{
> > > +		.name = "s2mps14-pmic",
> > > +	}, {
> > > +		.name = "s2mps14-rtc",
> > > +	}, {
> > > +		.name = "s2mps14-clk",
> > > +	}
> > > +};
> > 
> > No device tree support for the children?
> 
> There aren't any compatibles also for other devices (s2mps11, s5m876X)
> so I didn't want to introduce different behavior for S2MPS14. If you
> want of_compatible here then it should be added for all devices.

Fair enough.

> > <Snip>
> > 
> > > +#define S2MPS14_LDO_VSEL_MASK	0x3F
> > > +#define S2MPS14_BUCK_VSEL_MASK	0xFF
> > > +#define S2MPS14_ENABLE_MASK	(0x03 << S2MPS14_ENABLE_SHIFT)
> > > +#define S2MPS14_ENABLE_SHIFT	6
> > > +#define S2MPS14_LDO_N_VOLTAGES	(S2MPS14_LDO_VSEL_MASK + 1)
> > > +#define S2MPS14_BUCK_N_VOLTAGES (S2MPS14_BUCK_VSEL_MASK + 1)
> > 
> > Nit: Can you line these up using tabs please?

When you submit, please add my:
  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
