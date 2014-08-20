Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbaHTMmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:42:42 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47033 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753516AbaHTMmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 08:42:39 -0400
Date: Wed, 20 Aug 2014 13:42:31 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: "atull@opensource.altera.com" <atull@opensource.altera.com>,
        "baruch@tkos.co.il" <baruch@tkos.co.il>,
        "mika.westerberg@linux.intel.com" <mika.westerberg@linux.intel.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "skuribay@pobox.com" <skuribay@pobox.com>,
        "Romain.Baeriswyl@abilis.com" <Romain.Baeriswyl@abilis.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "delicious.quinoa@gmail.com" <delicious.quinoa@gmail.com>,
        "dinguyen@opensource.altera.com" <dinguyen@opensource.altera.com>,
        "yvanderv@opensource.altera.com" <yvanderv@opensource.altera.com>
Subject: Re: [PATCH] i2c: designware: deduce speed mode from device tree
 setting
Message-ID: <20140820124231.GD21734@leverpostej>
References: <1408479529-24249-1-git-send-email-atull@opensource.altera.com>
 <20140820092257.GA21174@leverpostej>
 <20140820123617.GB1373@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140820123617.GB1373@katana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 01:36:18PM +0100, Wolfram Sang wrote:
> > > +
> > > +		ret = of_property_read_u32(pdev->dev.of_node,
> > > +					   "clock-frequency", &bus_rate);
> > > +		if (!ret && (bus_rate <= 100000))
> > > +			speed = DW_IC_CON_SPEED_STD;
> > 
> > This looks a bit odd.
> > 
> > If the device only supports two particular speeds why do we accept any
> > other speed in the clock-frequency property?
> 
> "clock-frequency" is the default binding for specifying i2c bus speeds
> today. Some controllers can be programmed to do various speeds, some can
> only do a set of fixed values.

Sure. My complaint was that the driver would accept invalid values.
That wasn't meant to be suggestion to use a property other than the
standard clock-freqeuncy.

> > Surely we should at least warn that something was off?
> 
> Yes, I was going to say the same until Romain's old patch showed up
> which does that.

Cool. Sounds like we can use Romain's patch to handle this then.

Cheers,
Mark.
