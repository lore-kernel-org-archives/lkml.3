Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbaIVASU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 20:18:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:26679 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594AbaIVAST convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 20:18:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,568,1406617200"; 
   d="scan'208";a="479054306"
From: "Chang, Rebecca Swee Fun" <rebecca.swee.fun.chang@intel.com>
To: "'Mika Westerberg'" <mika.westerberg@linux.intel.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/3] gpio: sch: Add support for Intel Quark X1000 SoC
Thread-Topic: [PATCH 2/3] gpio: sch: Add support for Intel Quark X1000 SoC
Thread-Index: AQHP0zLfqb6ksj0GvUC28p3wBeVGTpwMTk8Q
Date: Mon, 22 Sep 2014 00:16:48 +0000
Message-ID: <50B33AC5ED75F74F991980326F1C438D0FBDAFC3@PGSMSX108.gar.corp.intel.com>
References: <1410943745-9354-1-git-send-email-rebecca.swee.fun.chang@intel.com>
 <1410943745-9354-3-git-send-email-rebecca.swee.fun.chang@intel.com>
 <20140918112247.GN10854@lahna.fi.intel.com>
In-Reply-To: <20140918112247.GN10854@lahna.fi.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Mika Westerberg [mailto:mika.westerberg@linux.intel.com]
> Sent: 18 September, 2014 7:23 PM
> To: Chang, Rebecca Swee Fun
> Cc: Linus Walleij; linux-gpio@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 2/3] gpio: sch: Add support for Intel Quark X1000 SoC
> 
> On Wed, Sep 17, 2014 at 04:49:04PM +0800, Chang Rebecca Swee Fun wrote:
> > Intel Quark X1000 provides a total of 16 GPIOs. The GPIOs are split
> > between the legacy I/O bridge and the GPIO controller.
> >
> > GPIO-SCH is the GPIO pins on legacy bridge for Intel Quark SoC.
> > Intel Quark X1000 has 2 GPIOs powered by the core power well and 6
> > from the suspend power well.
> >
> > This piece of work is derived from Dan O'Donovan's initial work for
> > Quark
> > X1000 enabling.
> >
> > Signed-off-by: Chang Rebecca Swee Fun
> > <rebecca.swee.fun.chang@intel.com>
> 
> One question, see below. But in general looks good, so
> 
> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> > ---
> >  drivers/gpio/Kconfig    |   11 +++++++++--
> >  drivers/gpio/gpio-sch.c |    6 ++++++
> >  2 files changed, 15 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig index
> > 690904a..64683a9 100644
> > --- a/drivers/gpio/Kconfig
> > +++ b/drivers/gpio/Kconfig
> > @@ -356,25 +356,32 @@ config GPIO_VR41XX
> >  	  Say yes here to support the NEC VR4100 series General-purpose I/O
> > Uint
> >
> >  config GPIO_SCH
> > -	tristate "Intel SCH/TunnelCreek/Centerton GPIO"
> > +	tristate "Intel SCH/TunnelCreek/Centerton/Quark X1000 GPIO"
> >  	depends on PCI && X86
> >  	select MFD_CORE
> >  	select LPC_SCH
> >  	help
> >  	  Say yes here to support GPIO interface on Intel Poulsbo SCH,
> > -	  Intel Tunnel Creek processor or Intel Centerton processor.
> > +	  Intel Tunnel Creek processor, Intel Centerton processor or
> > +	  Intel Quark X1000 SoC.
> > +
> >  	  The Intel SCH contains a total of 14 GPIO pins. Ten GPIOs are
> >  	  powered by the core power rail and are turned off during sleep
> >  	  modes (S3 and higher). The remaining four GPIOs are powered by
> >  	  the Intel SCH suspend power supply. These GPIOs remain
> >  	  active during S3. The suspend powered GPIOs can be used to wake the
> >  	  system from the Suspend-to-RAM state.
> > +
> >  	  The Intel Tunnel Creek processor has 5 GPIOs powered by the
> >  	  core power rail and 9 from suspend power supply.
> > +
> >  	  The Intel Centerton processor has a total of 30 GPIO pins.
> >  	  Twenty-one are powered by the core power rail and 9 from the
> >  	  suspend power supply.
> >
> > +	  The Intel Quark X1000 SoC has 2 GPIOs powered by the core
> > +	  power well and 6 from the suspend power well.
> > +
> >  config GPIO_ICH
> >  	tristate "Intel ICH GPIO"
> >  	depends on PCI && X86
> > diff --git a/drivers/gpio/gpio-sch.c b/drivers/gpio/gpio-sch.c index
> > 2189c22..38d6e74 100644
> > --- a/drivers/gpio/gpio-sch.c
> > +++ b/drivers/gpio/gpio-sch.c
> > @@ -241,6 +241,12 @@ static int sch_gpio_probe(struct platform_device
> *pdev)
> >  		sch->chip.ngpio = 30;
> >  		break;
> >
> > +	case PCI_DEVICE_ID_INTEL_QUARK_X1000_ILB:
> 
> Is this PCI ID provided by some other patch series?

Yes, this PCI ID has been submitted to upstream through MFD subsystem tree.

Rebecca
