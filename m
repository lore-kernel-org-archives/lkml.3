Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774Ab3CFOBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 09:01:06 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:35331 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221Ab3CFOBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 09:01:03 -0500
Date: Wed, 6 Mar 2013 09:01:30 -0500
From: Matt Porter <mporter@ti.com>
To: "Kumar, Anil" <anilkumar.v@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, "Nori, Sekhar" <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 6/9] ARM: dts: add AM33XX EDMA support
Message-ID: <20130306140130.GL6209@beef>
References: <1362516795-6346-1-git-send-email-mporter@ti.com>
 <1362516795-6346-7-git-send-email-mporter@ti.com>
 <a02b3a2e7dff42b0814bb6fa603068ba@DFLE73.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a02b3a2e7dff42b0814bb6fa603068ba@DFLE73.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 04:19:58AM +0000, Kumar, Anil wrote:
> Hi,
> 
> On Wed, Mar 06, 2013 at 02:23:12, Porter, Matt wrote:
> > Adds AM33XX EDMA support to the am33xx.dtsi as documented in
> > Documentation/devicetree/bindings/dma/ti-edma.txt
> > 
> > Signed-off-by: Matt Porter <mporter@ti.com>
> > ---
> >  arch/arm/boot/dts/am33xx.dtsi |   20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> > 
> > diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> > index 0957645..aaf44122 100644
> > --- a/arch/arm/boot/dts/am33xx.dtsi
> > +++ b/arch/arm/boot/dts/am33xx.dtsi
> > @@ -87,6 +87,26 @@
> >  			reg = <0x48200000 0x1000>;
> >  		};
> >  
> > +		edma: edma@49000000 {
> > +			compatible = "ti,edma3";
> > +			ti,hwmods = "tpcc", "tptc0", "tptc1", "tptc2";
> > +			reg =	<0x49000000 0x10000>,
> > +				<0x44e10f90 0x10>;
> > +			interrupt-parent = <&intc>;
> 
> Is it really need of "interrupt-parent = <&intc>" here ?
> as this property is already with root node.  
> I am taking reference of 3.9-rc1

You're correct. It's inherited from the parent node so I'll drop it out.
I also noted that the cpsw node has this wrong so I'll send a patch to
address that separately.

-Matt
