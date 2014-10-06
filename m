Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbaJFN6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 09:58:24 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56042 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750995AbaJFN6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 09:58:22 -0400
Date: Mon, 6 Oct 2014 15:58:18 +0200
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-pwm@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Yao <mark.yao@rock-chips.com>
Subject: Re: [PATCH v7 10/11] ARM: at91/dt: add LCD panel description to
 sama5d3xdm.dtsi
Message-ID: <20141006155818.0bc36b3d@bbrezillon>
In-Reply-To: <20141006133048.GE26921@ulmo>
References: <1412175188-28278-1-git-send-email-boris.brezillon@free-electrons.com>
	<1412175188-28278-11-git-send-email-boris.brezillon@free-electrons.com>
	<20141006110115.GH25202@ulmo>
	<20141006142538.76d2df29@bbrezillon>
	<20141006124014.GD26833@ulmo>
	<20141006151111.446ed7d6@bbrezillon>
	<20141006133048.GE26921@ulmo>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Oct 2014 15:30:59 +0200
Thierry Reding <thierry.reding@gmail.com> wrote:

> On Mon, Oct 06, 2014 at 03:11:11PM +0200, Boris Brezillon wrote:
> > On Mon, 6 Oct 2014 14:40:15 +0200
> > Thierry Reding <thierry.reding@gmail.com> wrote:
> > 
> > > On Mon, Oct 06, 2014 at 02:25:38PM +0200, Boris Brezillon wrote:
> > > > On Mon, 6 Oct 2014 13:01:16 +0200 Thierry Reding <thierry.reding@gmail.com> wrote:
> > > > > On Wed, Oct 01, 2014 at 04:53:07PM +0200, Boris Brezillon wrote:
> > > > > [...]
> > > > > > diff --git a/arch/arm/boot/dts/sama5d3xdm.dtsi b/arch/arm/boot/dts/sama5d3xdm.dtsi
> > > [...]
> > > > > > +		backlight = <&backlight>;
> > > > > > +		power-supply = <&panel_reg>;
> > > > > > +		#address-cells = <1>;
> > > > > > +		#size-cells = <0>;
> > > > > > +		status = "disabled";
> > > > > > +
> > > > > > +		port@0 {
> > > > > > +			#address-cells = <1>;
> > > > > > +			#size-cells = <0>;
> > > > > > +
> > > > > > +			panel_input: endpoint@0 {
> > > > > > +				reg = <0>;
> > > > > > +				remote-endpoint = <&hlcdc_panel_output>;
> > > > > > +			};
> > > > > >  		};
> > > > > 
> > > > > There's no support for OF graphs in simple-panel, so this is unused,
> > > > > isn't it?
> > > > 
> > > > Actually I use it in my atmel_hlcdc_ouput implementation to figure out
> > > > the link between a panel and a device connected on the RGB/DPI bus. 
> > > 
> > > That's kind of weird and one of the reasons why I can't make myself like
> > > the OF graph bindings. It requires drivers for one device to reach into
> > > the device tree node of some other device and look for content. Or put
> > > another way, a DT node for a panel that works on one platform doesn't
> > > work on another because the display controller needs additional DT
> > > content that isn't required by the original binding for the panel.
> > 
> > I also have a working POC of a DPI bus implementation (with DPI support
> > in panel-simple driver).
> > 
> > This is a solution I developed to provide a generic DPI implementation
> > in my HLCDC driver and rely on generic external implementations for
> > slave devices (panels, encoders, ...).
> > 
> > But, IIRC, Laurent was not in favor of a bus approach because the DPI
> > bus is just a data bus and not a control bus.
> > 
> > Anyway, I'll clean it up and post an RFC.
> 
> According to the MIPI website there are also control signals and a
> command set to control display behaviour. Does your implementation
> handle any of that?

No it doesn't, and I'm pretty sure what I call DPI does not exactly
respect the MIPI DPI standard (and as such should not be called DPI,
but this is another problem).

This infrastructure provides a way for devices connected on a DPI bus
to agree on a video_bus_format (in my case RGB888, RGB666, ...).

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
