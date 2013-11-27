Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812Ab3K0Q4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 11:56:18 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:54042 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757724Ab3K0Q4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 11:56:13 -0500
Date: Wed, 27 Nov 2013 11:56:08 -0500
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
Subject: Re: [PATCH v3 2/9] staging: dwc2: update DT binding to add generic
 clock/phy properties
Message-ID: <20131127165608.GC31091@beef>
References: <1385403367-18144-1-git-send-email-matt.porter@linaro.org>
 <1385403367-18144-3-git-send-email-matt.porter@linaro.org>
 <529475B2.9070202@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529475B2.9070202@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 03:49:30PM +0530, Kishon Vijay Abraham I wrote:
> On Monday 25 November 2013 11:46 PM, Matt Porter wrote:
> > dwc2/s3c-hsotg require a single clock to be specified and optionally
> > a generic phy. On the s3c-hsotg driver old style USB phy support is
> > present as a fallback so the generic phy properties are optional.
> > 
> > Signed-off-by: Matt Porter <matt.porter@linaro.org>
> > ---
> >  Documentation/devicetree/bindings/staging/dwc2.txt | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/staging/dwc2.txt b/Documentation/devicetree/bindings/staging/dwc2.txt
> > index 1a1b7cf..b8b42b6 100644
> > --- a/Documentation/devicetree/bindings/staging/dwc2.txt
> > +++ b/Documentation/devicetree/bindings/staging/dwc2.txt
> > @@ -5,6 +5,12 @@ Required properties:
> >  - compatible : "snps,dwc2"
> >  - reg : Should contain 1 register range (address and length)
> >  - interrupts : Should contain 1 interrupt
> > +- clocks: clock provider specifier
> > +- clock-names: shall be "otg"
> > +- phys: phy provider specifier
> > +- phy-names: shall be "device"
> 
> lets mention in the Documentation too that the phy properties are optional.
> apart from that..

Good point, will do so.

> Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
> > +Refer to clk/clock-bindings.txt for generic clock consumer properties
> > +Refer to phy/phy-bindings.txt for generic phy consumer properties
> >  
> >  Example:
> >  
> > @@ -12,4 +18,8 @@ Example:
> >                  compatible = "ralink,rt3050-usb, snps,dwc2";
> >                  reg = <0x101c0000 40000>;
> >                  interrupts = <18>;
> > +		clocks = <&usb_otg_ahb_clk>;
> > +		clock-names = "otg";
> > +		phys = <&usbphy>;
> > +		phy-names = "device";
> >          };
> > 
> 
