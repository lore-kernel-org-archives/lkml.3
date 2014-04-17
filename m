Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751239AbaDQWaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 18:30:13 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:54854 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbaDQWaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 18:30:09 -0400
Date: Thu, 17 Apr 2014 18:30:04 -0400
From: Matt Porter <mporter@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Devicetree List <devicetree@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Tim Kryger <tim.kryger@linaro.org>,
        Markus Mayer <markus.mayer@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/4] mfd: bcm590xx: add support for second i2c slave
 address space
Message-ID: <20140417223004.GL23695@beef>
References: <1397501428-8857-1-git-send-email-mporter@linaro.org>
 <1397501428-8857-3-git-send-email-mporter@linaro.org>
 <20140416110603.GA19671@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140416110603.GA19671@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 12:06:03PM +0100, Lee Jones wrote:
> On Mon, 14 Apr 2014, Matt Porter wrote:
> 
> > BCM590xx utilizes a second i2c slave address to access additional
> 
> s/i2c/I2C
> 
> > register space. Add support for the second address space by
> > instantiated a dummy i2c device with the appropriate secondary
> 
> s/instantiated/instantiating
> 
> > i2c slave address. Expose a second regmap register space so that
> 
> s/i2c/I2C
> 
> Exposing?
> 
> s/regmap/Regmap
> 
> > mfd drivers can access this secondary i2c slave address space.
> 
> s/mfd/MFD
> 
> s/i2c/I2C

Ok, I'll fix the capitalization and wording..except for regmap as
noted by Mark.

> 
> > Signed-off-by: Matt Porter <mporter@linaro.org>
> > ---
> >  drivers/mfd/bcm590xx.c       | 60 +++++++++++++++++++++++++++++++++-----------
> >  include/linux/mfd/bcm590xx.h |  9 ++++---
> >  2 files changed, 52 insertions(+), 17 deletions(-)
> > 
> > diff --git a/drivers/mfd/bcm590xx.c b/drivers/mfd/bcm590xx.c
> > index e9a33c7..b710ffa 100644
> > --- a/drivers/mfd/bcm590xx.c
> > +++ b/drivers/mfd/bcm590xx.c
> > @@ -28,39 +28,71 @@ static const struct mfd_cell bcm590xx_devs[] = {
> >  	},
> >  };
> >  
> > -static const struct regmap_config bcm590xx_regmap_config = {
> > +static const struct regmap_config bcm590xx_regmap_config_0 = {
> 
> Not loving _0 and _1 appendages.
> 
> Is one of them {primary|master} and the other {secondary|slave}?

I guess from a Linux I2C subsystem, we can view _1 as the
"secondary"...it does correspond the the i2c_new_dummy() device
that we create in the mfd probe. That device corresponds to the
ADDMAP=1 address on the PMU. This is why I used those appendages.

-Matt
