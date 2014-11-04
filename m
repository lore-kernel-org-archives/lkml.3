Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961AbaKDMWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 07:22:00 -0500
Received: from mail-bl2on0144.outbound.protection.outlook.com ([65.55.169.144]:4174
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750914AbaKDMV7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 07:21:59 -0500
From: Peter Chen <Peter.Chen@freescale.com>
To: Dmitry Voytik <voytikd@gmail.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] ARM: imx: refactor mxc_iomux_mode()
Thread-Topic: [PATCH] ARM: imx: refactor mxc_iomux_mode()
Thread-Index: AQHP7TzTG8o6DJtqoEG3s5vFMoYlZ5xEB/UAgAxriGA=
Date: Tue, 4 Nov 2014 12:21:55 +0000
Message-ID: <54dc2a9edf554125b2158a1f9edd8adb@BN1PR0301MB0772.namprd03.prod.outlook.com>
References: <1413902151-20255-1-git-send-email-voytikd@gmail.com>
 <20141027142054.GB14033@voytthpd>
In-Reply-To: <20141027142054.GB14033@voytthpd>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [192.88.158.211]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0771;
x-forefront-prvs: 03853D523D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(189002)(199003)(24454002)(21056001)(33646002)(4396001)(106356001)(31966008)(64706001)(106116001)(110136001)(46102003)(105586002)(20776003)(120916001)(66066001)(107046002)(87936001)(95666004)(1411001)(108616004)(50986999)(99396003)(101416001)(76576001)(74316001)(76176999)(54356999)(77096003)(99286002)(2656002)(62966003)(19580395003)(15975445006)(19580405001)(92566001)(86362001)(575784001)(97736003)(15202345003)(77156002)(122556002)(40100003)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0771;H:BN1PR0301MB0772.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> On Tue, Oct 21, 2014 at 06:35:51PM +0400, Dmitry Voytik wrote:
> > Refactor mxc_iomux_mode():
> >  - since it always returns 0 make it to return void
> >  - remove unnecessary ret variable
> >  - declare variables according to the kernel coding style
> >
> > Signed-off-by: Dmitry Voytik <voytikd@gmail.com>
> > ---
> >  arch/arm/mach-imx/iomux-imx31.c | 8 ++++----
> >  arch/arm/mach-imx/iomux-mx3.h   | 2 +-
> >  2 files changed, 5 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/arm/mach-imx/iomux-imx31.c
> > b/arch/arm/mach-imx/iomux-imx31.c index 1657fe6..d6a3075 100644
> > --- a/arch/arm/mach-imx/iomux-imx31.c
> > +++ b/arch/arm/mach-imx/iomux-imx31.c
> > @@ -44,9 +44,11 @@ static unsigned long mxc_pin_alloc_map[NB_PORTS *
> > 32 / BITS_PER_LONG];
> >  /*
> >   * set the mode for a IOMUX pin.
> >   */
> > -int mxc_iomux_mode(unsigned int pin_mode)
> > +void mxc_iomux_mode(unsigned int pin_mode)
> >  {
> > -	u32 field, l, mode, ret = 0;
> > +	u32 field;
> > +	u32 l;
> > +	u32 mode;
> >  	void __iomem *reg;
> >

Why you use three lines to define it, it makes the function longer.
Besides, Shawn's email changes to : <shawn.guo@linaro.org>

Peter

> >  	reg = IOMUXSW_MUX_CTL + (pin_mode & IOMUX_REG_MASK); @@ -
> 61,8 +63,6
> > @@ int mxc_iomux_mode(unsigned int pin_mode)
> >  	__raw_writel(l, reg);
> >
> >  	spin_unlock(&gpio_mux_lock);
> > -
> > -	return ret;
> >  }
> >
> >  /*
> > diff --git a/arch/arm/mach-imx/iomux-mx3.h
> > b/arch/arm/mach-imx/iomux-mx3.h index f79f78a..0a5adba 100644
> > --- a/arch/arm/mach-imx/iomux-mx3.h
> > +++ b/arch/arm/mach-imx/iomux-mx3.h
> > @@ -144,7 +144,7 @@ void mxc_iomux_set_gpr(enum iomux_gp_func, bool
> en);
> >   * It is called by the setup functions and should not be called directly
> anymore.
> >   * It is here visible for backward compatibility
> >   */
> > -int mxc_iomux_mode(unsigned int pin_mode);
> > +void mxc_iomux_mode(unsigned int pin_mode);
> >
> >  #define IOMUX_PADNUM_MASK	0x1ff
> >  #define IOMUX_GPIONUM_SHIFT	9
> > --
> > 1.9.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-kernel" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
