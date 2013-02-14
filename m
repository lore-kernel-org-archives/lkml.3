Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab3BNGUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 01:20:20 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:50972 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126Ab3BNGUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 01:20:18 -0500
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "hs@denx.de" <hs@denx.de>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Porter, Matt" <mporter@ti.com>
Subject: RE: [PATCH v2 2/3] mmc: davinci_mmc: add DT support
Thread-Topic: [PATCH v2 2/3] mmc: davinci_mmc: add DT support
Thread-Index: AQHOBQiaR4i2K3bQekeNtxNjukEnzZh1bCQAgAN/cXA=
Date: Thu, 14 Feb 2013 06:19:44 +0000
Message-ID: <A73F36158E33644199EB82C5EC81C7BC3EA46AE8@DBDE01.ent.ti.com>
References: <1360223825-23929-1-git-send-email-prakash.pm@ti.com>
 <1360223825-23929-3-git-send-email-prakash.pm@ti.com>
 <5119DF6E.9080501@ti.com>
In-Reply-To: <5119DF6E.9080501@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1E6KeM4002908

Hi Sekhar,

This mail reached my inbox after I sent out v3.

On Tue, Feb 12, 2013 at 11:51:34, Nori, Sekhar wrote:
> On 2/7/2013 1:27 PM, Manjunathappa, Prakash wrote:
> > Adds device tree support for davinci_mmc. Also add binding documentation.
> > Tested in non-dma PIO mode and without GPIO card_detect/write_protect
> > option because of dependencies on EDMA and GPIO module DT support.
> > 
> > Signed-off-by: Manjunathappa, Prakash <prakash.pm@ti.com>
> > Cc: linux-mmc@vger.kernel.org
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: linux-kernel@vger.kernel.org
> > Cc: davinci-linux-open-source@linux.davincidsp.com
> > Cc: devicetree-discuss@lists.ozlabs.org
> > Cc: cjb@laptop.org
> > Cc: Sekhar Nori <nsekhar@ti.com>
> > Cc: mporter@ti.com
> > ---
> > Since v1:
> > Modified DT parse function to take default values and accomodate controller
> > version in compatible field.
> > 
> >  .../devicetree/bindings/mmc/davinci_mmc.txt        |   30 ++++++++
> >  drivers/mmc/host/davinci_mmc.c                     |   70 +++++++++++++++++++-
> >  2 files changed, 99 insertions(+), 1 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/mmc/davinci_mmc.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/mmc/davinci_mmc.txt b/Documentation/devicetree/bindings/mmc/davinci_mmc.txt
> > new file mode 100644
> > index 0000000..6717ab1
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/mmc/davinci_mmc.txt
> > @@ -0,0 +1,30 @@
> > +* TI Highspeed MMC host controller for DaVinci
> > +
> > +The Highspeed MMC Host Controller on TI DaVinci family
> > +provides an interface for MMC, SD and SDIO types of memory cards.
> > +
> > +This file documents the properties used by the davinci_mmc driver.
> > +
> > +Required properties:
> > +- compatible:
> > + Should be "ti,davinci-mmc-da830": for da830, da850, dm365
> > + Should be "ti,davinci-mmc-dm355": for dm355, dm644x
> > +
> > +Optional properties:
> > +- bus-width: Number of data lines, can be <4>, or <8>, default <1>
> > +- max-frequency: Maximum operating clock frequency, default 25MHz.
> > +- mmc-cap-mmc-highspeed: Indicates support for MMC in high speed mode
> > +- mmc-cap-sd-highspeed: Indicates support for SD in high speed mode
> > +
> > +Example:
> > +	mmc0: mmc@1c40000 {
> > +		compatible = "ti,davinci-mmc-da830",
> > +		reg = <0x40000 0x1000>;
> > +		interrupts = <16>;
> > +		status = "okay";
> > +		bus-width = <4>;
> > +		max-frequency = <50000000>;
> > +		mmc-cap-sd-highspeed;
> > +		mmc-cap-mmc-highspeed;
> > +	};
> > +
> > diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
> > index 27123f8..3f90316 100644
> > --- a/drivers/mmc/host/davinci_mmc.c
> > +++ b/drivers/mmc/host/davinci_mmc.c
> > @@ -34,6 +34,8 @@
> >  #include <linux/dma-mapping.h>
> >  #include <linux/edma.h>
> >  #include <linux/mmc/mmc.h>
> > +#include <linux/of.h>
> > +#include <linux/of_device.h>
> >  
> >  #include <linux/platform_data/mmc-davinci.h>
> >  
> > @@ -1157,15 +1159,80 @@ static void __init init_mmcsd_host(struct mmc_davinci_host *host)
> >  	mmc_davinci_reset_ctrl(host, 0);
> >  }
> >  
> > -static int __init davinci_mmcsd_probe(struct platform_device *pdev)
> > +static const struct of_device_id davinci_mmc_dt_ids[] = {
> > +	{
> > +		.compatible = "ti,davinci-mmc-dm355",
> > +		.data = (void *)MMC_CTLR_VERSION_1,
> > +	},
> > +	{
> > +		.compatible = "ti,davinci-mmc-da830",
> > +		.data = (void *)MMC_CTLR_VERSION_2,
> > +	},
> > +	{},
> > +};
> > +MODULE_DEVICE_TABLE(of, davinci_mmc_dt_ids);
> 
> If you are doing this why not also kill passing IP version through
> platform data using a platform_device_id table? Look at what Afzal did
> for drivers/rtc/rtc-omap.c
> 

Agreed, I will send out v4 having these changes also in this series.

Thanks,
Prakash

> Thanks,
> Sekhar
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
