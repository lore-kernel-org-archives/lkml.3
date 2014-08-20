Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbaHTOjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 10:39:12 -0400
Received: from mail.abilis.ch ([195.70.19.74]:55981 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbaHTOjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 10:39:10 -0400
Date: Wed, 20 Aug 2014 16:38:33 +0200 (CEST)
From: Romain Baeriswyl <Romain.Baeriswyl@abilis.com>
To: atull <atull@opensource.altera.com>
Cc: Mark Rutland <mark.rutland@arm.com>, wsa@the-dreams.de, baruch@tkos.co.il,
        mika westerberg <mika.westerberg@linux.intel.com>,
        grant likely <grant.likely@linaro.org>, robh+dt@kernel.org,
        skuribay@pobox.com, rafael j wysocki <rafael.j.wysocki@intel.com>,
        alan@linux.intel.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        delicious quinoa <delicious.quinoa@gmail.com>,
        dinguyen@opensource.altera.com, yvanderv@opensource.altera.com
Message-ID: <1791089693.2989.1408545513401.JavaMail.root@abilis.com>
In-Reply-To: <alpine.DEB.2.02.1408200922590.11079@atx-linux-37>
Subject: Re: [PATCH] i2c: designware: deduce speed mode from device tree
 setting
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 7.2.4_GA_2900 (ZimbraWebClient - FF3.0 (Linux)/7.2.4_GA_2900)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

We got board issue using I2C and they were solved by changing the i2c timing.

It is possible to change the tLOW and tHIGH period with the following parameters:
  i2c-sda-hold-time-ns
  i2c-sda-falling-time-ns
  i2c-scl-falling-time-ns

Romain

----- Original Message -----
From: "atull" <atull@opensource.altera.com>
To: "Romain Baeriswyl" <Romain.Baeriswyl@abilis.com>
Cc: "Mark Rutland" <mark.rutland@arm.com>, wsa@the-dreams.de, baruch@tkos.co.il, "mika westerberg" <mika.westerberg@linux.intel.com>, "grant likely" <grant.likely@linaro.org>, robh+dt@kernel.org, skuribay@pobox.com, "rafael j wysocki" <rafael.j.wysocki@intel.com>, alan@linux.intel.com, linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, "delicious quinoa" <delicious.quinoa@gmail.com>, dinguyen@opensource.altera.com, yvanderv@opensource.altera.com
Sent: Wednesday, August 20, 2014 4:24:45 PM
Subject: Re: [PATCH] i2c: designware: deduce speed mode from device tree setting



On Wed, 20 Aug 2014, Romain Baeriswyl wrote:

> Hi,
> 
> With the patch "i2c designware add support of I2C standard mode" I already proposed:
> - I2C standard mode is selected with 100kHz clock frequency.
> - I2C fast mode is selected with 400kHy clock frequency.
> - EINVAL error is returned if clock frequency is not 100000 and not 400000.
> 
> but this patch seems not available yet.
> What about the other patch "i2c designware make SCL and SDA falling time configurable" ?
> 
> In i2c-designware_platdrv.c the flag DW_IC_CON_SPEED_xxx is well set
> depending on the mode:
> 
>   if (clk_freq == 100000)

Romain,

I'm really happy if your patches get accepted.  Can this be <= 100000?
It is really common to run I2C at a lower speed if you have some
board issues with the i2c bus.

Alan

>      dev->master_cfg =  DW_IC_CON_MASTER | DW_IC_CON_SLAVE_DISABLE |
>        DW_IC_CON_RESTART_EN | DW_IC_CON_SPEED_STD;
>    else
>      dev->master_cfg =  DW_IC_CON_MASTER | DW_IC_CON_SLAVE_DISABLE |
>        DW_IC_CON_RESTART_EN | DW_IC_CON_SPEED_FAST;
> 
> 
> So for me everything should be fine if there patches are applied.
> 
> Regards,
> 
> Romain
> 
> ----- Original Message -----
> From: "Mark Rutland" <mark.rutland@arm.com>
> To: atull@opensource.altera.com
> Cc: wsa@the-dreams.de, baruch@tkos.co.il, "mika westerberg" <mika.westerberg@linux.intel.com>, "grant likely" <grant.likely@linaro.org>, robh+dt@kernel.org, skuribay@pobox.com, "Romain Baeriswyl" <Romain.Baeriswyl@abilis.com>, "rafael j wysocki" <rafael.j.wysocki@intel.com>, alan@linux.intel.com, linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, "delicious quinoa" <delicious.quinoa@gmail.com>, dinguyen@opensource.altera.com, yvanderv@opensource.altera.com
> Sent: Wednesday, August 20, 2014 11:22:57 AM
> Subject: Re: [PATCH] i2c: designware: deduce speed mode from device tree setting
> 
> On Tue, Aug 19, 2014 at 09:18:49PM +0100, atull@opensource.altera.com wrote:
> > From: Alan Tull <atull@opensource.altera.com>
> > 
> > Use the documented, but unimplemented "clock-frequency"
> > Device Tree setting as a guide on whether to set the speed
> > mode bits in DW_IC_CON to standard or fast i2c mode.
> > 
> > Previously, the driver was hardwired to fast mode.  Default
> > to fast mode if the "clock-frequency" property is not present
> > for backwards compatiblity.
> > 
> > Signed-off-by: Alan Tull <atull@opensource.altera.com>
> > ---
> >  drivers/i2c/busses/i2c-designware-platdrv.c |   10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
> > index bc87733..18cd3d9 100644
> > --- a/drivers/i2c/busses/i2c-designware-platdrv.c
> > +++ b/drivers/i2c/busses/i2c-designware-platdrv.c
> > @@ -122,7 +122,8 @@ static int dw_i2c_probe(struct platform_device *pdev)
> >  	struct dw_i2c_dev *dev;
> >  	struct i2c_adapter *adap;
> >  	struct resource *mem;
> > -	int irq, r;
> > +	int irq, r, ret, speed = DW_IC_CON_SPEED_FAST;
> > +	u32 bus_rate;
> >  
> >  	irq = platform_get_irq(pdev, 0);
> >  	if (irq < 0) {
> > @@ -167,6 +168,11 @@ static int dw_i2c_probe(struct platform_device *pdev)
> >  		of_property_read_u32(pdev->dev.of_node,
> >  				     "i2c-scl-falling-time-ns",
> >  				     &dev->scl_falling_time);
> > +
> > +		ret = of_property_read_u32(pdev->dev.of_node,
> > +					   "clock-frequency", &bus_rate);
> > +		if (!ret && (bus_rate <= 100000))
> > +			speed = DW_IC_CON_SPEED_STD;
> 
> This looks a bit odd.
> 
> If the device only supports two particular speeds why do we accept any
> other speed in the clock-frequency property? Surely we should at least
> warn that something was off?
> 
> Thanks,
> Mark
> 
> >  	}
> >  
> >  	dev->functionality =
> > @@ -177,7 +183,7 @@ static int dw_i2c_probe(struct platform_device *pdev)
> >  		I2C_FUNC_SMBUS_WORD_DATA |
> >  		I2C_FUNC_SMBUS_I2C_BLOCK;
> >  	dev->master_cfg =  DW_IC_CON_MASTER | DW_IC_CON_SLAVE_DISABLE |
> > -		DW_IC_CON_RESTART_EN | DW_IC_CON_SPEED_FAST;
> > +		DW_IC_CON_RESTART_EN | speed;
> >  
> >  	/* Try first if we can configure the device from ACPI */
> >  	r = dw_i2c_acpi_configure(pdev);
> > -- 
> > 1.7.9.5
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe devicetree" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
