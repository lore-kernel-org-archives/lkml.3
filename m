Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129Ab3GBFVN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 01:21:13 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44390 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488Ab3GBFVM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 01:21:12 -0400
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: Kevin Hilman <khilman@linaro.org>
CC: "tony@atomide.com" <tony@atomide.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "Bedia, Vaibhav" <vaibhav.bedia@ti.com>,
        "Rajashekhara, Sudhakar" <sudhakar.raj@ti.com>,
        "Nori, Sekhar" <nsekhar@ti.com>, Russell King <linux@arm.linux.org.uk>
Subject: RE: [PATCH 2/4] davinci: da8xx/omap-l1: Remove hard coding of rtc
 device wakeup
Thread-Topic: [PATCH 2/4] davinci: da8xx/omap-l1: Remove hard coding of rtc
 device wakeup
Thread-Index: AQHOdrgx6EB/ZyWS2UKTmTgcwIyCA5lQ2h6g
Date: Tue, 2 Jul 2013 05:20:29 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EC4E6EE@DBDE04.ent.ti.com>
References: <1372412109-986-1-git-send-email-gururaja.hebbar@ti.com>
	<1372412109-986-3-git-send-email-gururaja.hebbar@ti.com>
 <87a9m5omcw.fsf@linaro.org>
In-Reply-To: <87a9m5omcw.fsf@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 05:37:43, Kevin Hilman wrote:
> Hebbar Gururaja <gururaja.hebbar@ti.com> writes:
> 
> > Since now rtc-omap driver itself calls deice_init_wakeup(dev, true),
> > duplicate call from the rtc device registration can be removed.
> >
> > This is basically a partial revert of the prev commit
> >
> > commit 75c99bb0006ee065b4e2995078d779418b0fab54
> > Author: Sekhar Nori <nsekhar@ti.com>
> >
> >     davinci: da8xx/omap-l1: mark RTC as a wakeup source
> >
> > Signed-off-by: Hebbar Gururaja <gururaja.hebbar@ti.com>
> > Cc: Sekhar Nori <nsekhar@ti.com>
> > Cc: Kevin Hilman <khilman@linaro.org>
> > Cc: Russell King <linux@arm.linux.org.uk>
> >
> > ---
> > :100644 100644 bf57252... 85a900c... M	arch/arm/mach-davinci/devices-da8xx.c
> >  arch/arm/mach-davinci/devices-da8xx.c |    9 +--------
> >  1 file changed, 1 insertion(+), 8 deletions(-)
> >
> > diff --git a/arch/arm/mach-davinci/devices-da8xx.c b/arch/arm/mach-davinci/devices-da8xx.c
> > index bf57252..85a900c 100644
> > --- a/arch/arm/mach-davinci/devices-da8xx.c
> > +++ b/arch/arm/mach-davinci/devices-da8xx.c
> > @@ -827,14 +827,7 @@ static struct platform_device da8xx_rtc_device = {
> >  
> >  int da8xx_register_rtc(void)
> >  {
> > -	int ret;
> > -
> > -	ret = platform_device_register(&da8xx_rtc_device);
> > -	if (!ret)
> > -		/* Atleast on DA850, RTC is a wakeup source */
> > -		device_init_wakeup(&da8xx_rtc_device.dev, true);
> > -
> > -	return ret;
> > +	return  platform_device_register(&da8xx_rtc_device);
> 
> nit: extra space between 'return' and 'platform_'

Thanks for the review. V2 will soon follow.

> 
> >  }
> >  
> >  static void __iomem *da8xx_ddr2_ctlr_base;
> 
> Otherwise,
> 
> Acked-by: Kevin Hilman <khilman@linaro.org>
> 
> 


Regards, 
Gururaja
