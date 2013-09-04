Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762613Ab3IDNvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 09:51:50 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:55616 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760059Ab3IDNvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 09:51:49 -0400
Date: Wed, 4 Sep 2013 14:51:43 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Rutland <mark.rutland@arm.com>
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
Message-ID: <20130904135143.GJ20150@lee--X1>
References: <1378287103-21765-1-git-send-email-lee.jones@linaro.org>
 <1378287103-21765-3-git-send-email-lee.jones@linaro.org>
 <20130904123850.GI18206@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130904123850.GI18206@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Sep 2013, Mark Rutland wrote:

> Hi Lee,
> 
> On Wed, Sep 04, 2013 at 10:31:34AM +0100, Lee Jones wrote:
> > After applying this node the LPS001WP sensor chip should probe
> > successfully once the driver support has also been applied.
> > 
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  arch/arm/boot/dts/ste-snowball.dts | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/arch/arm/boot/dts/ste-snowball.dts b/arch/arm/boot/dts/ste-snowball.dts
> > index cf9b16e..aad8f54 100644
> > --- a/arch/arm/boot/dts/ste-snowball.dts
> > +++ b/arch/arm/boot/dts/ste-snowball.dts
> > @@ -153,6 +153,16 @@
> >  			status = "okay";
> >  		};
> >  
> > +		i2c@80128000 {
> > +			lps001wp@5c {
> > +				compatible = "lps001wp";
> > +				reg = <0x5c>;
> > +
> > +				vdd-supply = <&ab8500_ldo_aux1_reg>;
> > +				vms-supply = <&db8500_vsmps2_reg>;
> > +			};
> > +		};
> > +
> 
> This appears to be missing a binding document. I couldn't see one
> anywhere in this series, or in mainline already).
> 
> As far as I can see, the compatible string should be "st,lps001wp".
> 
> Please produce a binding document.

Patch sent, most of you are on CC.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
