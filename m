Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494Ab3BKFcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 00:32:20 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:47583 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975Ab3BKFcR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 00:32:17 -0500
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: "Manjunathappa, Prakash" <prakash.pm@ti.com>,
        Mark Rutland <mark.rutland@arm.com>
CC: "Porter, Matt" <mporter@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "hs@denx.de" <hs@denx.de>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v2 2/3] mmc: davinci_mmc: add DT support
Thread-Topic: [PATCH v2 2/3] mmc: davinci_mmc: add DT support
Thread-Index: AQHOBQiaR4i2K3bQekeNtxNjukEnzZht2qAAgABeknCABesuQA==
Date: Mon, 11 Feb 2013 05:31:47 +0000
Message-ID: <A73F36158E33644199EB82C5EC81C7BC3EA46794@DBDE01.ent.ti.com>
References: <1360223825-23929-1-git-send-email-prakash.pm@ti.com>
	<1360223825-23929-3-git-send-email-prakash.pm@ti.com>
	<20130207104656.GE16987@e106331-lin.cambridge.arm.com>
 <A73F36158E33644199EB82C5EC81C7BC3EA465FE@DBDE01.ent.ti.com>
In-Reply-To: <A73F36158E33644199EB82C5EC81C7BC3EA465FE@DBDE01.ent.ti.com>
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

Hi Mark,

On Fri, Feb 08, 2013 at 11:55:09, Manjunathappa, Prakash wrote:
> Hi Mark,
> 
> On Thu, Feb 07, 2013 at 16:16:56, Mark Rutland wrote:
> > Hello,
> > 
> > I have a couple of comments on the dt bindings and the way it's parsed.
> > 
> 
> Thanks for your review comments.
> 
> > On Thu, Feb 07, 2013 at 07:57:04AM +0000, Manjunathappa, Prakash wrote:
> > > Adds device tree support for davinci_mmc. Also add binding documentation.
> > > Tested in non-dma PIO mode and without GPIO card_detect/write_protect
> > > option because of dependencies on EDMA and GPIO module DT support.
> > > 
> > > Signed-off-by: Manjunathappa, Prakash <prakash.pm@ti.com>
> > > Cc: linux-mmc@vger.kernel.org
> > > Cc: linux-arm-kernel@lists.infradead.org
> > > Cc: linux-kernel@vger.kernel.org
> > > Cc: davinci-linux-open-source@linux.davincidsp.com
> > > Cc: devicetree-discuss@lists.ozlabs.org
> > > Cc: cjb@laptop.org
> > > Cc: Sekhar Nori <nsekhar@ti.com>
> > > Cc: mporter@ti.com
> > > ---
> > > Since v1:
> > > Modified DT parse function to take default values and accomodate controller
> > > version in compatible field.
> > > 
> > >  .../devicetree/bindings/mmc/davinci_mmc.txt        |   30 ++++++++
> > >  drivers/mmc/host/davinci_mmc.c                     |   70 +++++++++++++++++++-
> > >  2 files changed, 99 insertions(+), 1 deletions(-)
> > >  create mode 100644 Documentation/devicetree/bindings/mmc/davinci_mmc.txt
> > > 
> > > diff --git a/Documentation/devicetree/bindings/mmc/davinci_mmc.txt b/Documentation/devicetree/bindings/mmc/davinci_mmc.txt
> > > new file mode 100644
> > > index 0000000..6717ab1
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/mmc/davinci_mmc.txt
> > > @@ -0,0 +1,30 @@
> > > +* TI Highspeed MMC host controller for DaVinci
> > > +
> > > +The Highspeed MMC Host Controller on TI DaVinci family
> > > +provides an interface for MMC, SD and SDIO types of memory cards.
> > > +
> > > +This file documents the properties used by the davinci_mmc driver.
> > > +
> > > +Required properties:
> > > +- compatible:
> > > + Should be "ti,davinci-mmc-da830": for da830, da850, dm365
> > > + Should be "ti,davinci-mmc-dm355": for dm355, dm644x
> > > +
> > > +Optional properties:
> > > +- bus-width: Number of data lines, can be <4>, or <8>, default <1>
> > > +- max-frequency: Maximum operating clock frequency, default 25MHz.
> > > +- mmc-cap-mmc-highspeed: Indicates support for MMC in high speed mode
> > > +- mmc-cap-sd-highspeed: Indicates support for SD in high speed mode
> > 
> > I thought the last two were derivable from max-frequency?
> > 
> 
> Yes, but I see below comment that it doesnot support MMC/SD.
> arch/arm/mach-davinci/devices.c: davinci_setup_mmc
> 	   "
>          * FIXME dm6441 (no MMC/SD), dm357 (one), and dm335 (two) are
>          * not handled right here ...
>          */"
> I was wondering how do we support such platforms, so I thought it is necessary
> to have these. But I see that on da850-evm even on skipping above flags EVM is able
> to detect card, does it mean there is no way to specify "no SD/MMC" capability?
> I will remove these and decide highspeed capability based on max-frequency.
> 

Since this comment also applies for existing non-DT driver, I will plan to take
up activity later. For now I will submit next version of DT support patch
excluding highspeed card capability.

Thanks,
Prakash

[...]

