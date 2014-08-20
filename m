Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaHTOaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 10:30:23 -0400
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:45515
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751292AbaHTOaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 10:30:18 -0400
Date: Wed, 20 Aug 2014 09:24:45 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: Romain Baeriswyl <Romain.Baeriswyl@abilis.com>
CC: Mark Rutland <mark.rutland@arm.com>, <wsa@the-dreams.de>,
        <baruch@tkos.co.il>, mika westerberg <mika.westerberg@linux.intel.com>,
        grant likely <grant.likely@linaro.org>, <robh+dt@kernel.org>,
        <skuribay@pobox.com>, rafael j wysocki <rafael.j.wysocki@intel.com>,
        <alan@linux.intel.com>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        delicious quinoa <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>
Subject: Re: [PATCH] i2c: designware: deduce speed mode from device tree
 setting
In-Reply-To: <944257148.1724.1408528177642.JavaMail.root@abilis.com>
Message-ID: <alpine.DEB.2.02.1408200922590.11079@atx-linux-37>
References: <944257148.1724.1408528177642.JavaMail.root@abilis.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BN1PR08CA0012.namprd08.prod.outlook.com (10.242.217.140) To
 DM2PR03MB318.namprd03.prod.outlook.com (10.141.54.17)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03094A4065
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(377454003)(24454002)(13464003)(51704005)(164054003)(189002)(199003)(107046002)(83072002)(19580405001)(83322001)(47776003)(20776003)(76176999)(99396002)(53416004)(92566001)(79102001)(85852003)(69596002)(81342001)(86152002)(19580395003)(92726001)(95666004)(102836001)(54356999)(4396001)(50986999)(42186005)(64706001)(33716001)(105586002)(77982001)(83506001)(15975445006)(85306004)(21056001)(74662001)(80022001)(86362001)(81542001)(74502001)(31966008)(81156004)(15202345003)(106356001)(46406003)(101416001)(23726002)(110136001)(50466002)(77096002)(87976001)(76482001)(46102001)(66066001)(21314002);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB318;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



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
