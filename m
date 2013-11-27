Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700Ab3K0RZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 12:25:09 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:57318 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757257Ab3K0RZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 12:25:06 -0500
Date: Wed, 27 Nov 2013 12:24:58 -0500
From: Matt Porter <matt.porter@linaro.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>, Tomasz Figa <t.figa@samsung.com>,
        Kamil Debski <k.debski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: Re: [PATCH v3 9/9] ARM: dts: add usb udc support to bcm281xx
Message-ID: <20131127172458.GH31091@beef>
References: <1385403367-18144-1-git-send-email-matt.porter@linaro.org>
 <1385403367-18144-10-git-send-email-matt.porter@linaro.org>
 <5295B3EF.8010602@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5295B3EF.8010602@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 02:27:19PM +0530, Kishon Vijay Abraham I wrote:
> Hi,
> 
> On Monday 25 November 2013 11:46 PM, Matt Porter wrote:
> > Adds USB OTG/PHY and clock support to BCM281xx and enables
> > UDC support on the bcm11351-brt and bcm28155-ap boards.
> > 
> > Signed-off-by: Matt Porter <matt.porter@linaro.org>
> > Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> > Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
> > ---
> >  arch/arm/boot/dts/bcm11351-brt.dts |  6 ++++++
> >  arch/arm/boot/dts/bcm11351.dtsi    | 18 ++++++++++++++++++
> >  arch/arm/boot/dts/bcm28155-ap.dts  |  8 ++++++++
> >  3 files changed, 32 insertions(+)
> > 
> > diff --git a/arch/arm/boot/dts/bcm11351-brt.dts b/arch/arm/boot/dts/bcm11351-brt.dts
> > index 23cd16d..396b704 100644
> > --- a/arch/arm/boot/dts/bcm11351-brt.dts
> > +++ b/arch/arm/boot/dts/bcm11351-brt.dts
> > @@ -44,5 +44,11 @@
> >  		status = "okay";
> >  	};
> >  
> > +	usbotg: usb@3f120000 {
> > +		status = "okay";
> > +	};
> 
> using &usbotg could have been better. I mean if you have something like
> &usbotg, you realise that the node has been created somewhere and we are just
> referencing it here to add more properties.

That's normally my preference, but Christian owns this file and doesn't
like that syntax. Instead, I'm conforming with the rest of the .dts
entries. He and I discussed moving to &label references a while back and
that's a no go.

Thanks,
Matt
