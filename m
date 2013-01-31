Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab3AaMZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:25:42 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:45464 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295Ab3AaMZh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:25:37 -0500
From: "Patil, Rachna" <rachna@ti.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>
CC: Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Dmitry Torokhov <dtor@mail.ru>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v4 5/8] MFD: ti_am335x_tscadc: Add DT support
Thread-Topic: [PATCH v4 5/8] MFD: ti_am335x_tscadc: Add DT support
Thread-Index: AQHN+eU4Ait4NoO8mU2XgvHAUfkGNphhXFuAgABfUVCAANSOAIAA11hw
Date: Thu, 31 Jan 2013 12:25:07 +0000
Message-ID: <4CE347531D4CA947960AF71FF095B9323E9B21C5@DBDE01.ent.ti.com>
References: <1358999112-31192-1-git-send-email-rachna@ti.com>
 <1358999112-31192-6-git-send-email-rachna@ti.com>
 <A9839AA2-ABCD-4642-9766-D56824AC27AD@dominion.thruhere.net>
 <4CE347531D4CA947960AF71FF095B9323E9B1EE9@DBDE01.ent.ti.com>
 <79CD15C6BA57404B839C016229A409A83EBEFAE8@DBDE01.ent.ti.com>
In-Reply-To: <79CD15C6BA57404B839C016229A409A83EBEFAE8@DBDE01.ent.ti.com>
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

Vaibhav,

<SNIP>
> > > > 
> > > > -	if (!pdata) {
> > > > +	if (!pdata && !pdev->dev.of_node) {
> > > > 		dev_err(&pdev->dev, "Could not find platform data\n");
> > > > 		return -EINVAL;
> > > > 	}
> > > > 
> > > > -	if (pdata->adc_init)
> > > > -		adc_channels = pdata->adc_init->adc_channels;
> > > > +	if (pdev->dev.platform_data) {
> > > > +		if (pdata->tsc_init)
> > > > +			tsc_wires = pdata->tsc_init->wires;
> > > > +
> > > > +		if (pdata->adc_init)
> > > > +			adc_channels = pdata->adc_init->adc_channels;
> > > > +	} else {
> > > > +		node = of_find_node_by_name(pdev->dev.of_node, "tsc");
> > > > +		of_property_read_u32(node, "ti,wires", &tsc_wires);
> > > > +
> > > > +		node = of_find_node_by_name(pdev->dev.of_node, "adc");
> > > > +		of_property_read_u32(node, "ti,adc-channels", &adc_channels);
> > > > +	}
> > > 
> > > Since AM335x is DT only, why is there a platform data codepath and why is it the first branch it tries? And I guess the next question is related to the first: why doesn't it work when used with DT? When I copy over the nodes from the evm.dts to my board I get "tsc tsc: Missing platform data" in dmesg.
> > 
> > This IP came up 1st on AM335x, but it is not platform dependent. The driver can be used on other platforms where-in DT is not supported.
> > According to the maintainers platform data takes precedence over DT. Hence the order.
> > 
> 
> Rachana,
> 
> I see no point adding support for platform_data when you know that none of older platforms are going to use this driver and all future platforms _must_ follow device-tree model.
> 
> So I agree that you should remove board file dependency from the driver.

Ok. I will remove support for platform data in the next version of patches.

> 
> 
> > I do not see "Missing platform data" error msg in the latest driver. I am not able to trace from where this got populated.
> > 
> 
> Can you share the branch which you have tested?

https://github.com/patilrachna/linux/tree/v3.8_rc3_MFD_TSCADC_DT-v2

Regards,
Rachna


