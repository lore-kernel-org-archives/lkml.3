Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab3GBFVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 01:21:49 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40936 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379Ab3GBFVq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 01:21:46 -0400
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
        "Grant Likely" <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, "Rob Landley" <rob@landley.net>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: RE: [PATCH 3/4] rtc: omap: add rtc wakeup support to alarm events
Thread-Topic: [PATCH 3/4] rtc: omap: add rtc wakeup support to alarm events
Thread-Index: AQHOdrk4yd0SmsY4NUe7y2uBfi7gq5lQ2low
Date: Tue, 2 Jul 2013 05:20:53 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EC4E6FE@DBDE04.ent.ti.com>
References: <1372412109-986-1-git-send-email-gururaja.hebbar@ti.com>
	<1372412109-986-4-git-send-email-gururaja.hebbar@ti.com>
 <871u7hom0q.fsf@linaro.org>
In-Reply-To: <871u7hom0q.fsf@linaro.org>
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

On Tue, Jul 02, 2013 at 05:45:01, Kevin Hilman wrote:
> Hebbar Gururaja <gururaja.hebbar@ti.com> writes:
> 
> > On some platforms (like AM33xx), a special register (RTC_IRQWAKEEN)
> > is available to enable Alarm Wakeup feature. This register needs to be
> > properly handled for the rtcwake to work properly.
> >
> > Platforms using such IP should set "ti,am3352-rtc" in rtc device dt
> > compatibility node.
> >
> > Signed-off-by: Hebbar Gururaja <gururaja.hebbar@ti.com>
> > Cc: Grant Likely <grant.likely@linaro.org>
> > Cc: Rob Herring <rob.herring@calxeda.com>
> > Cc: Rob Landley <rob@landley.net>
> > Cc: Sekhar Nori <nsekhar@ti.com>
> > Cc: Kevin Hilman <khilman@linaro.org>
> > Cc: Alessandro Zummo <a.zummo@towertech.it>
> > Cc: rtc-linux@googlegroups.com
> > Cc: devicetree-discuss@lists.ozlabs.org
> > Cc: linux-doc@vger.kernel.org
> 
> Acked-by: Kevin Hilman <khilman@linaro.org>
> 
> ...with a minor nit below...
> 
> > ---
> > :100644 100644 b47aa41... 5a0f02d... M	Documentation/devicetree/bindings/rtc/rtc-omap.txt
> > :100644 100644 761919d... 666b0c2... M	drivers/rtc/rtc-omap.c
> >  Documentation/devicetree/bindings/rtc/rtc-omap.txt |    6 ++-
> >  drivers/rtc/rtc-omap.c                             |   56 +++++++++++++++++---
> >  2 files changed, 54 insertions(+), 8 deletions(-)
> >
> > diff --git a/Documentation/devicetree/bindings/rtc/rtc-omap.txt b/Documentation/devicetree/bindings/rtc/rtc-omap.txt
> > index b47aa41..5a0f02d 100644
> > --- a/Documentation/devicetree/bindings/rtc/rtc-omap.txt
> > +++ b/Documentation/devicetree/bindings/rtc/rtc-omap.txt
> > @@ -1,7 +1,11 @@
> >  TI Real Time Clock
> >  
> >  Required properties:
> > -- compatible: "ti,da830-rtc"
> > +- compatible:
> > +	- "ti,da830-rtc"  - for RTC IP used similar to that on DA8xx SoC family.
> > +	- "ti,am3352-rtc" - for RTC IP used similar to that on AM335x SoC family.
> > +			    This RTC IP has special WAKE-EN Register to enable
> > +			    Wakeup generation for event Alarm.
> >  - reg: Address range of rtc register set
> >  - interrupts: rtc timer, alarm interrupts in order
> >  - interrupt-parent: phandle for the interrupt controller
> > diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
> > index 761919d..666b0c2 100644
> > --- a/drivers/rtc/rtc-omap.c
> > +++ b/drivers/rtc/rtc-omap.c
> > @@ -72,6 +72,8 @@
> >  #define OMAP_RTC_KICK0_REG		0x6c
> >  #define OMAP_RTC_KICK1_REG		0x70
> >  
> > +#define OMAP_RTC_IRQWAKEEN		0x7C
> > +
> 
> nit: letters in hex numbers are usually lower-case.

Thanks for the review. V2 will soon follow.

> 
> 
> Kevin
> 


Regards, 
Gururaja
