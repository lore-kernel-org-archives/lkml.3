Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab3KKRif (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 12:38:35 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45596 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754991Ab3KKRiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 12:38:18 -0500
Date: Mon, 11 Nov 2013 17:38:04 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Joel Fernandes <joelf@ti.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        DOCUMENTATION <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] doc: devicetree: Add bindings documentation for
 omap-des driver
Message-ID: <20131111173804.GN21201@e106331-lin.cambridge.arm.com>
References: <1383871035-16608-1-git-send-email-joelf@ti.com>
 <20131111110106.GC21201@e106331-lin.cambridge.arm.com>
 <5281103F.8050407@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5281103F.8050407@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 05:13:35PM +0000, Joel Fernandes wrote:
> On 11/11/2013 05:01 AM, Mark Rutland wrote:
> > Hi Joel,
> > 
> > I realise I'm a little late in replying to this, but there are a few
> > things that would be nice to fix up.
> > 
> > On Fri, Nov 08, 2013 at 12:37:09AM +0000, Joel Fernandes wrote:
> >> Add documentation for the generic OMAP DES crypto module describing the device
> >> tree bindings.
> >>
> >> Signed-off-by: Joel Fernandes <joelf@ti.com>
> >> ---
> >>  .../devicetree/bindings/crypto/omap-des.txt        | 28 ++++++++++++++++++++++
> >>  1 file changed, 28 insertions(+)
> >>  create mode 100644 Documentation/devicetree/bindings/crypto/omap-des.txt
> >>
> >> diff --git a/Documentation/devicetree/bindings/crypto/omap-des.txt b/Documentation/devicetree/bindings/crypto/omap-des.txt
> >> new file mode 100644
> >> index 0000000..0637647
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/crypto/omap-des.txt
> >> @@ -0,0 +1,28 @@
> >> +OMAP SoC DES crypto Module
> >> +
> >> +Required properties:
> >> +
> >> +- compatible : Should be "ti,omap4-des"
> > 
> > Nit: s/Should be/Should contain/
> 
> ok
> 
> > 
> >> +- ti,hwmods: Name of the hwmod associated with the DES module
> >> +- reg : Offset and length of the register set for the module
> >> +- interrupts : the interrupt-specifier for the DES module
> > 
> > Just to check: there's only one interrupt?
> 
> Yes.
> 
> >> +- clocks : phandle to the functional clock node of the DES module
> >> +- clock-names : Name of the functional clock
> > 
> > What name is expected here? The intent of clock-names is to describe
> > which clock input lines the clocks are wired to, so this should be
> > well-defined.
> > 
> > From the looks of the example, the clock input is called "fck". Is that
> > correct?
> 
> Yes. The clock name is used by PM code to get the clock for the particular
> device. Yes the code assumes it to be "fck", I can change doc to be so.
> 
> > When you have clock-names, the nicest thing to do is to define clocks
> > in terms of clock-names. Something like:
> > 
> > - clocks: A phandle + clock-specifier pair for each entry in
> >   clock-names.
> > 
> > - clock-names: Should contain:
> >   * "fck" for the functional clock
> > 
> > Which implies that the correct way to find clocks is to look in
> > clock-names first to find the clock's index, rather than grabbing the
> > clock by index. This makes it far easier to add/remove/change clocks in
> > future.
> 
> Ok. I'll reword documentation of clocks as above.
> 
> > 
> >> +
> >> +Optional properties:
> >> +- dmas: DMA specifiers for tx and rx dma. See the DMA client binding,
> >> +	Documentation/devicetree/bindings/dma/dma.txt
> > 
> > Similarly here it would be nice to have dmas refer to dma-names for
> > the description of which dmas exist.
> 
> Ok, will make the above 3 changes and resubmit, if its ok will add your Reviewed-by.

That would be fine by me.

With the changes:

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Mark.
