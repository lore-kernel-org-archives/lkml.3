Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab3G3Ozr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 10:55:47 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63058 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752940Ab3G3Ozq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 10:55:46 -0400
Date: Tue, 30 Jul 2013 15:55:01 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Gururaja Hebbar <gururaja.hebbar@ti.com>
Cc: "benoit.cousson@linaro.org" <benoit.cousson@linaro.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "khilman@linaro.org" <khilman@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "benoit.cousson@gmail.com" <benoit.cousson@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vaibhav.bedia@ti.com" <vaibhav.bedia@ti.com>,
        "sudhakar.raj@ti.com" <sudhakar.raj@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Patch V2 4/4] ARM: dts: AM33XX: update rtc node compatibility
Message-ID: <20130730145501.GA29859@e106331-lin.cambridge.arm.com>
References: <1372841225-18813-1-git-send-email-gururaja.hebbar@ti.com>
 <1372841225-18813-5-git-send-email-gururaja.hebbar@ti.com>
 <51F749B0.7020802@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F749B0.7020802@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 06:05:52AM +0100, Gururaja Hebbar wrote:
> Hi,
> 
> On 7/3/2013 2:17 PM, Hebbar Gururaja wrote:
> > Since AM33xx  RTC IP has RTC_IRQWAKEEN to support Alarm Wake-up.
> >
> > Update the rtc compatible property to "ti,am3352-rtc" to enable handling
> > of this feature inside rtc-omap driver.
> 
> The other 2 rtc driver related patches have been pulled up. If you have 
> no comments, can you please pull this up.
> 
> Regards
> Gururaja
> 
> >
> > Signed-off-by: Hebbar Gururaja <gururaja.hebbar@ti.com>
> > ---
> > :100644 100644 77aa1b0... dde180a... M	arch/arm/boot/dts/am33xx.dtsi
> >   arch/arm/boot/dts/am33xx.dtsi |    2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> > index 77aa1b0..dde180a 100644
> > --- a/arch/arm/boot/dts/am33xx.dtsi
> > +++ b/arch/arm/boot/dts/am33xx.dtsi
> > @@ -297,7 +297,7 @@
> >   		};
> >
> >   		rtc@44e3e000 {
> > -			compatible = "ti,da830-rtc";
> > +			compatible = "ti,am3352-rtc";

Given that this is backwards compatible with the old binding, it would
be nicer to have this as:

	compatible = "ti,am3352-rtc", "ti,da830-rtc";

We must get into the habit of changing dts files in a
backwards-compatible fashion.

Thanks,
Mark.
