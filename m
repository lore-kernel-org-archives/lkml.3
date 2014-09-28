Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbaI1DPK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 23:15:10 -0400
Received: from mga14.intel.com ([192.55.52.115]:46045 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180AbaI1DPH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 23:15:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="392577643"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: Mark Brown <broonie@kernel.org>
CC: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Tan, Raymond" <raymond.tan@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: RE: [PATCH] SPI: spi-pxa2xx: SPI support for Intel Quark X1000
Thread-Topic: [PATCH] SPI: spi-pxa2xx: SPI support for Intel Quark X1000
Thread-Index: AQHP2splkx0ZBJe9NUiWssulYNYxFw==
Date: Sun, 28 Sep 2014 03:15:04 +0000
Message-ID: <4656BEB6164FC34F8171C6538F1A595B2E9970F8@SHSMSX101.ccr.corp.intel.com>
References: <1411752349-31490-1-git-send-email-alvin.chen@intel.com>
 <1411752349-31490-2-git-send-email-alvin.chen@intel.com>
 <20140926100832.GE27755@sirena.org.uk>
In-Reply-To: <20140926100832.GE27755@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> > +static u32 pxa2xx_spi_get_ssrc1_change_mask(const struct driver_data
> > +*drv_data) {
> > +	if (!is_quark_x1000_ssp(drv_data))
> > +		return SSCR1_CHANGE_MASK;
> > +
> > +	return QUARK_X1000_SSCR1_CHANGE_MASK; }
> 
> These functions would be much better written as switch statements - think
> how they're going to look when we've got another controller which needs
> custom values.  It might also be helpful for review to have two patches, one
> splitting things out into the functions and another adding the Quark support.
> 
OK. Let me use switch. BTW, for two patches, actually, using helpers is due to we support quark.
Do you mean the first patch just introduce helpers, maybe it only support one type, then another patch to add
quark supporting. Am I right?

> > +/*  see Quark SPI data sheet for implementation rationale */ static
> > +u32 quark_x1000_set_clk_regvals(u32 rate, u32 *dds, u32 *clk_div) {
> 
> Please document this in the driver - I don't know if this datasheet is public but
> even if it is it may not stay that way.
OK. I will document it.

> 
> > @@ -613,6 +759,8 @@ static void pump_transfers(unsigned long data)
> >  	u32 cr1;
> >  	u32 dma_thresh = drv_data->cur_chip->dma_threshold;
> >  	u32 dma_burst = drv_data->cur_chip->dma_burst_size;
> > +	u32 change_mask = pxa2xx_spi_get_ssrc1_change_mask(drv_data);
> > +
> >
> 
> Extra blank line being added here.
> 
I will remove it.

> > @@ -145,6 +147,9 @@ static inline int pxa25x_ssp_comp(struct driver_data
> *drv_data)
> >  		return 1;
> >  	if (drv_data->ssp_type == CE4100_SSP)
> >  		return 1;
> > +	if (drv_data->ssp_type == QUARK_X1000_SSP)
> > +		return 1;
> > +
> >  	return 0;
> >  }
> 
> Things like this should also be refactored into switch statements - in general
> anything that's deciding what to do based on ssp_type probably ought to be
> using switch statements.
OK. I will use switch.
