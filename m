Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760509AbaGRHq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 03:46:29 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:36707 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbaGRHq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 03:46:27 -0400
Date: Fri, 18 Jul 2014 16:46:21 +0900
From: Simon Horman <horms@verge.net.au>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>, devicetree@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eduardo Valentin <eduardo.valentin@ti.com>, linux-pm@vger.kernel.org
Subject: Re: [PATCH 05/13] thermal: rcar: Document SoC-specific bindings
Message-ID: <20140718074619.GA12613@verge.net.au>
References: <1404908623-909-1-git-send-email-geert+renesas@glider.be>
 <1404908623-909-6-git-send-email-geert+renesas@glider.be>
 <20140711091358.GK12420@verge.net.au>
 <1405435735.28592.50.camel@rzhang1-toshiba>
 <87mwcakpzw.wl%kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mwcakpzw.wl%kuninori.morimoto.gx@renesas.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 07:16:06PM -0700, Kuninori Morimoto wrote:
> 
> Hi
> 
> > > > The documentation only mentioned the generic fallback compatible property.
> > > > Add the missing SoC-specific compatible properties, some of which are
> > > > already in use.
> > > > 
> > > > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > > > Cc: Zhang Rui <rui.zhang@intel.com>
> > > > Cc: Eduardo Valentin <eduardo.valentin@ti.com>
> > > > Cc: linux-pm@vger.kernel.org
> > > 
> > > Acked-by: Simon Horman <horms+renesas@verge.net.au>
> > 
> > Kuninori,
> > 
> > what' your opinion of this patch?
> > 
> > thanks,
> > rui
> > > 
> > > > ---
> > > >  .../devicetree/bindings/thermal/rcar-thermal.txt       | 18 ++++++++++++------
> > > >  1 file changed, 12 insertions(+), 6 deletions(-)
> > > > 
> > > > diff --git a/Documentation/devicetree/bindings/thermal/rcar-thermal.txt b/Documentation/devicetree/bindings/thermal/rcar-thermal.txt
> > > > index 28ef498a66e5..0ef00be44b01 100644
> > > > --- a/Documentation/devicetree/bindings/thermal/rcar-thermal.txt
> > > > +++ b/Documentation/devicetree/bindings/thermal/rcar-thermal.txt
> > > > @@ -1,7 +1,13 @@
> > > >  * Renesas R-Car Thermal
> > > >  
> > > >  Required properties:
> > > > -- compatible		: "renesas,rcar-thermal"
> > > > +- compatible		: "renesas,thermal-<soctype>", "renesas,rcar-thermal"
> > > > +			  as fallback.
> > > > +			  Examples with soctypes are:
> > > > +			    - "renesas,thermal-r8a73a4" (R-Mobile AP6)
> > > > +			    - "renesas,thermal-r8a7779" (R-Car H1)
> > > > +			    - "renesas,thermal-r8a7790" (R-Car H2)
> > > > +			    - "renesas,thermal-r8a7791" (R-Car M2)
> > > >  - reg			: Address range of the thermal registers.
> > > >  			  The 1st reg will be recognized as common register
> > > >  			  if it has "interrupts".
> > > > @@ -12,18 +18,18 @@ Option properties:
> > > >  
> > > >  Example (non interrupt support):
> > > >  
> > > > -thermal@e61f0100 {
> > > > -	compatible = "renesas,rcar-thermal";
> > > > -	reg = <0xe61f0100 0x38>;
> > > > +thermal@ffc48000 {
> > > > +	compatible = "renesas,thermal-r8a7779", "renesas,rcar-thermal";
> > > > +	reg = <0xffc48000 0x38>;
> > > >  };
> > > >  
> > > >  Example (interrupt support):
> > > >  
> > > >  thermal@e61f0000 {
> > > > -	compatible = "renesas,rcar-thermal";
> > > > +	compatible = "renesas,thermal-r8a73a4", "renesas,rcar-thermal";
> > > >  	reg = <0xe61f0000 0x14
> > > >  		0xe61f0100 0x38
> > > >  		0xe61f0200 0x38
> > > >  		0xe61f0300 0x38>;
> > > > -	interrupts = <0 69 4>;
> > > > +	interrupts = <0 69 IRQ_TYPE_LEVEL_HIGH>;
> > > >  };
> 
> This patch and [12/13] are adding SoC-specific compatible name.
> Of course we don't know future request,
> and, adding SoC-specific compatible name for
> fallbacking is nice safety for us.
> So, I don't have strong objection about it.
> 
> But, thermal driver side do nothing for each
> SoC-specific compatible name at this point.
> This means
> 
>  -> There is no trouble in driver/SoC
>  -> Add new (and not used) compatible name
>  -> Nothing happen in driver/SoC
> 
> My questions are...
>  1) How to verify this patch ?
>  2) Do we need to update example SoC "specific name" list in rcar-thermal.txt.
>     Few example codes are very enough ?

Hi Morimoto-san,

I believe that the approach taken with this patch is similar to the
approach that has been taken for several other drivers used by Renesas
SoCs. The implication of this approach is:

1. That the (in this case thermal) IP on the SoC's listed is known
   to work with the driver using the generic (in this case
   renesas,rcar-thermal) compatibility string.

2. That if some incompatibility is subsequently found such that the
   IP on SoC does function correctly using the generic compatibility
   string or some new feature is to be enabled which is not generic
   then it the driver should be updated with code that is triggered
   by the SoC-specific compat string.

3. That Soc dts(i) files should list the more specific SoC compat string
   followed bu the generic compat string. In this way so long as the
   driver only matches on the generic compat string it will be used. But
   if the driver is updated match on the SoC-specific compat string
   then it will be used instead. In this way dtbs should be forwards
   compatible with driver updates.

   I believe that this series includes patches to update the relevant
   dtsi files accordingly.

In relation to verification, I believe all the SoCs listed in this patch
are known to work with the generic compat string. And they should continue
to work with this change because its only an documentation change. In the
future, if a SoC specific compat string is added to the driver code then
verification would need to occur.

>From my point of view the documentation in rcar-thermal.txt is consistent
with the documentation for other drivers that use this binding scheme
(at least the ones that are documented :). I would not have any problems
examples but I don't think its entirely necessary.
