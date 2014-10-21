Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630AbaJUMxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 08:53:54 -0400
Received: from down.free-electrons.com ([37.187.137.238]:57823 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755310AbaJUMxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 08:53:52 -0400
Date: Tue, 21 Oct 2014 14:53:44 +0200
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Yassin Jaffer <yassinjaffer@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH v6 2/2] mtd: nand: add sunxi NFC dt bindings doc
Message-ID: <20141021145344.575b19e6@bbrezillon>
In-Reply-To: <20141021024134.GC1193@ld-irv-0074>
References: <1413805520-14947-1-git-send-email-boris.brezillon@free-electrons.com>
	<1413805520-14947-3-git-send-email-boris.brezillon@free-electrons.com>
	<20141021024134.GC1193@ld-irv-0074>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian,

On Mon, 20 Oct 2014 19:41:34 -0700
Brian Norris <computersforpeace@gmail.com> wrote:

> Hi Boris,
> 
> On Mon, Oct 20, 2014 at 01:45:20PM +0200, Boris Brezillon wrote:
> > Add the sunxi NAND Flash Controller dt bindings documentation.
> > 
> > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> > ---
> >  .../devicetree/bindings/mtd/sunxi-nand.txt         | 45 ++++++++++++++++++++++
> >  1 file changed, 45 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/mtd/sunxi-nand.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/mtd/sunxi-nand.txt b/Documentation/devicetree/bindings/mtd/sunxi-nand.txt
> > new file mode 100644
> > index 0000000..0273adb
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/mtd/sunxi-nand.txt
> > @@ -0,0 +1,45 @@
> > +Allwinner NAND Flash Controller (NFC)
> > +
> > +Required properties:
> > +- compatible : "allwinner,sun4i-a10-nand".
> > +- reg : shall contain registers location and length for data and reg.
> > +- interrupts : shall define the nand controller interrupt.
> > +- #address-cells: shall be set to 1. Encode the nand CS.
> > +- #size-cells : shall be set to 0.
> > +- clocks : shall reference nand controller clocks.
> > +- clock-names : nand controller internal clock names. Shall contain :
> > +    * "ahb" : AHB gating clock
> > +    * "mod" : nand controller clock
> > +
> > +Optional children nodes:
> > +Children nodes represent the available nand chips.
> > +
> > +Optional properties:
> > +- allwinner,rb : shall contain the native Ready/Busy ids.
> > + or
> > +- rb-gpios : shall contain the gpios used as R/B pins.
> 
> I think you're relying on a named GPIO in your driver ("nand-rb"). That
> should be documented here.

Actually that's the name I assign to the pin when requesting it, this
has nothing to do with a specific property containing pin names for
specific gpio retrieval (as done for clocks with clock-names).

> 
> > +- nand-ecc-mode : one of the supported ECC modes ("hw", "hw_syndrome", "soft",
> > +  "soft_bch" or "none")
> 
> I think you're utilizing an undocumented 'nand-name' property for this
> node in your driver too. Please document it. (That also goes for any
> other undocumented properties I may have missed.)

I'll drop this nand-name property and let the NAND core code choose a
name for the MTD device according to the discovered NAND chip.

Thanks,

Boris



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
