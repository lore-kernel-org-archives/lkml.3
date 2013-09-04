Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934911Ab3IDOJo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:09:44 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52917 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756296Ab3IDOJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:09:42 -0400
Date: Wed, 4 Sep 2013 15:08:44 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "denis.ciocca@st.com" <denis.ciocca@st.com>,
        "arnd@arndb.de" <arnd@arndb.de>
Subject: Re: [PATCH 02/11] ARM: ux500: Enable the LPS001WP Pressure &
 Temperature sensor from DT
Message-ID: <20130904140844.GL18206@e106331-lin.cambridge.arm.com>
References: <1378287103-21765-1-git-send-email-lee.jones@linaro.org>
 <1378287103-21765-3-git-send-email-lee.jones@linaro.org>
 <20130904123850.GI18206@e106331-lin.cambridge.arm.com>
 <20130904133654.GH20150@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130904133654.GH20150@lee--X1>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 02:36:54PM +0100, Lee Jones wrote:
> On Wed, 04 Sep 2013, Mark Rutland wrote:
> 
> > Hi Lee,
> > 
> > On Wed, Sep 04, 2013 at 10:31:34AM +0100, Lee Jones wrote:
> > > After applying this node the LPS001WP sensor chip should probe
> > > successfully once the driver support has also been applied.
> > > 
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > ---
> > >  arch/arm/boot/dts/ste-snowball.dts | 10 ++++++++++
> > >  1 file changed, 10 insertions(+)
> > > 
> > > diff --git a/arch/arm/boot/dts/ste-snowball.dts b/arch/arm/boot/dts/ste-snowball.dts
> > > index cf9b16e..aad8f54 100644
> > > --- a/arch/arm/boot/dts/ste-snowball.dts
> > > +++ b/arch/arm/boot/dts/ste-snowball.dts
> > > @@ -153,6 +153,16 @@
> > >  			status = "okay";
> > >  		};
> > >  
> > > +		i2c@80128000 {
> > > +			lps001wp@5c {
> > > +				compatible = "lps001wp";
> > > +				reg = <0x5c>;
> > > +
> > > +				vdd-supply = <&ab8500_ldo_aux1_reg>;
> > > +				vms-supply = <&db8500_vsmps2_reg>;
> > > +			};
> > > +		};
> > > +
> > 
> > This appears to be missing a binding document. I couldn't see one
> > anywhere in this series, or in mainline already).
> > 
> > As far as I can see, the compatible string should be "st,lps001wp".
> 
> The I2C subsystem doesn't actually care about vendor prefixes. They
> are all stripped before use in all cases. However, I'm happy to
> provide one if for no other reason than to stick to convention.

I'd prefer if we did document this. Just because Linux doesn't care
about this at the moment doesn't mean we (or another OS) might want to
handle it differently in future. It also gives us a semblance of
consistency.

> 
> > Please produce a binding document.
> 
> Again, I'm happy to provide a boilerplate document, but there's
> nothing special happening here.

That's not true. The names of the regulators should be documented. One
seems to be optional for some reason.

> 
> > Is there any publicly available documentation on the chip?
> 
> If you Google the device name, it will be the first hit.

Ok, I'll take a look.

> 
> > >  		uart@80120000 {
> > >  			status = "okay";
> > >  		};
> 
> Kind regards,
> Lee

Cheers,
Mark.
