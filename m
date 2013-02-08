Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760060Ab3BHKEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 05:04:35 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:54896 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623Ab3BHKEc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 05:04:32 -0500
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: Mark Rutland <mark.rutland@arm.com>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "Porter, Matt" <mporter@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "hs@denx.de" <hs@denx.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v2 2/3] mmc: davinci_mmc: add DT support
Thread-Topic: [PATCH v2 2/3] mmc: davinci_mmc: add DT support
Thread-Index: AQHOBQiaR4i2K3bQekeNtxNjukEnzZht2qAAgABeknCAASB5AIAAX6Ig
Date: Fri, 8 Feb 2013 10:04:04 +0000
Message-ID: <A73F36158E33644199EB82C5EC81C7BC3EA466AF@DBDE01.ent.ti.com>
References: <1360223825-23929-1-git-send-email-prakash.pm@ti.com>
 <1360223825-23929-3-git-send-email-prakash.pm@ti.com>
 <20130207104656.GE16987@e106331-lin.cambridge.arm.com>
 <A73F36158E33644199EB82C5EC81C7BC3EA465FE@DBDE01.ent.ti.com>
 <20130208093754.GA27859@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130208093754.GA27859@e106331-lin.cambridge.arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Feb 08, 2013 at 15:07:54, Mark Rutland wrote:
> Hi,
> 
> [...]
> 
> > > > diff --git a/Documentation/devicetree/bindings/mmc/davinci_mmc.txt b/Documentation/devicetree/bindings/mmc/davinci_mmc.txt
> > > > new file mode 100644
> > > > index 0000000..6717ab1
> > > > --- /dev/null
> > > > +++ b/Documentation/devicetree/bindings/mmc/davinci_mmc.txt
> > > > @@ -0,0 +1,30 @@
> > > > +* TI Highspeed MMC host controller for DaVinci
> > > > +
> > > > +The Highspeed MMC Host Controller on TI DaVinci family
> > > > +provides an interface for MMC, SD and SDIO types of memory cards.
> > > > +
> > > > +This file documents the properties used by the davinci_mmc driver.
> > > > +
> > > > +Required properties:
> > > > +- compatible:
> > > > + Should be "ti,davinci-mmc-da830": for da830, da850, dm365
> > > > + Should be "ti,davinci-mmc-dm355": for dm355, dm644x
> > > > +
> > > > +Optional properties:
> > > > +- bus-width: Number of data lines, can be <4>, or <8>, default <1>
> > > > +- max-frequency: Maximum operating clock frequency, default 25MHz.
> > > > +- mmc-cap-mmc-highspeed: Indicates support for MMC in high speed mode
> > > > +- mmc-cap-sd-highspeed: Indicates support for SD in high speed mode
> 
> [...]
> 
> 
> > > > +static struct davinci_mmc_config
> > > > +	*mmc_parse_pdata(struct platform_device *pdev)
> > > >  {
> > > > +	struct device_node *np;
> > > >  	struct davinci_mmc_config *pdata = pdev->dev.platform_data;
> > > > +	const struct of_device_id *match =
> > > > +		of_match_device(of_match_ptr(davinci_mmc_dt_ids), &pdev->dev);
> > > > +	u32 data;
> > > > +
> > > > +	np = pdev->dev.of_node;
> > > > +	if (!np)
> > > > +		return pdata;
> > > > +
> > > > +	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
> > > > +	if (!pdata) {
> > > > +		dev_err(&pdev->dev, "Failed to allocate memory for struct davinci_mmc_config\n");
> > > > +		goto nodata;
> > > > +	}
> > > > +
> > > > +	if (match->data)
> > > > +		pdata->version = (u8)((int)match->data);
> > > > +
> > > > +	of_property_read_u32(np, "max-frequency", &pdata->max_freq);
> > > > +	if (!pdata->max_freq)
> > > > +		dev_info(&pdev->dev, "'max-frequency' property not specified, defaulting to 25MHz\n");
> > > > +
> > > > +	if (of_get_property(np, "mmc-cap-mmc-highspeed", NULL))
> > > > +		pdata->caps |= MMC_CAP_MMC_HIGHSPEED;
> > > > +	if (of_get_property(np, "mmc-cap-sd-highspeed", NULL))
> > > > +		pdata->caps |= MMC_CAP_SD_HIGHSPEED;
> > > 
> > > If these aren't derivable from max-frequency, you could use
> > > of_property_read_bool to make this clearer.
> > > 
> > 
> > Correct, I will decide these based on max-frequency.
> > 
> > > > +
> > > > +	of_property_read_u32(np, "bus-width", &data);
> > > > +	switch (data) {
> > > > +	case 0:
> > > 
> > > Judging by the binding doc, should this be 1 rather than 0?
> > > 
> > 
> > By default driver comes up in 4 bit mode when bus-width is not specified.
> > Bus-width is set to 1 bit for invalid bus-widths. Below are the cases
> > when bus-width 0 or 4, bus-width is set to 4bit mode
> > When bus-width is 8, bus-width is set to 8 bit mode
> 
> Why is 0 a special value that means 4? Why not just use 4?
> 
> Here you just assign 0 to pdata->wires.
> 
> I see the current version of the driver handles this specially in
> davinci_mmcsd_probe, but I don't see why this should leak into the binding.
> 

Yes, I was trying to push in current driver behavior into binding documentation.

> What I was originally trying to get at is that the binding says 8, 4, and 1 are
> acceptable values, but you check the cases 8, 4, or 0. So you're accepting
> something not documented, and producing a warning in a valid case (1).
> 

Valid point.

> > 
> > I thought that if somebody specifies bus-width as 2, 3, 5, 6, 7..., then
> > it should be defaulted to 1 bit mode, so I specified it as 1 bit in binding doc.
> 
> If they specify something invalid, falling back to a sane value with a warning
> sounds good.
> 

True.

> > But I feel that a person who is editing dts file will not make such a mistake.
> > I will change binding document to default as 4 bit mode.
> 
> There have been and inevitably will be plenty of errors in dts files. I think
> it'd be good to provide a warning and either use a value that's guaranteed to
> work, or bail out if that can't be done.
> 
> If it's always valid to use 1 data line even if the hardware has more, I think
> falling back to 1 makes more sense, as it'd be guaranteed to work.
> 

I completely agree with you, thanks for your inputs.
Will add valid case 1:

Thanks,
Prakash

> > 
> > > > +	case 4:
> > > > +	case 8:
> > > > +		pdata->wires = data;
> > > > +		break;
> > > > +	default:
> > > > +		pdata->wires = 1;
> > > > +		dev_info(&pdev->dev, "Unsupported buswidth, defaulting to 1 bit\n");
> > > > +	}
> > > > +nodata:
> > > > +	return pdata;
> > > > +}
> 
> With the first case changed to "case 1:", this block makes sense to me.
> 
> Thanks,
> Mark.
> 
> 

