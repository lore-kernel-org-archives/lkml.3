Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702AbbAKLVr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 06:21:47 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:42788 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbbAKLVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 06:21:45 -0500
Date: Sun, 11 Jan 2015 13:21:41 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 4/8] irqchip: devicetree: document Conexant Digicolor
 irq binding
Message-ID: <20150111112141.GO2481@sapphire.tkos.co.il>
References: <cover.1420744368.git.baruch@tkos.co.il>
 <3bdf8fa0bf971b4881024e72312c3c9d29298e79.1420744369.git.baruch@tkos.co.il>
 <20150109115014.GC12942@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150109115014.GC12942@leverpostej>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Jan 09, 2015 at 11:50:14AM +0000, Mark Rutland wrote:
> On Thu, Jan 08, 2015 at 07:40:00PM +0000, Baruch Siach wrote:
> > Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> > ---
> >  .../bindings/interrupt-controller/digicolor-ic.txt   | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/interrupt-controller/digicolor-ic.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/interrupt-controller/digicolor-ic.txt b/Documentation/devicetree/bindings/interrupt-controller/digicolor-ic.txt
> > new file mode 100644
> > index 000000000000..fdf9a4c59bf3
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/interrupt-controller/digicolor-ic.txt
> > @@ -0,0 +1,20 @@
> > +Conexant Digicolor Interrupt Controller
> > +
> > +Required properties:
> > +
> > +- compatible : should be "cnxt,cx92755-ic"
> 
> I didn't spot "cnxt" in
> Documentation/devicetree/bindings/vendor-prefixes.txt in mainline, nor
> did I spot it added as part of this series. Please add it, assuming a
> patch doing so is not already queued elsewhere.

I sent a vendor-prefixes.txt update earlier as part of the UART driver series. 
Greg has it queued in the tty-testing branch of his tty tree 
(https://git.kernel.org/cgit/linux/kernel/git/gregkh/tty.git/commit/?h=tty-testing&id=48c738631753186e0ec7dd0079beffb3a6f4bb5c).

> > +- reg : Specifies base physical address and size of the MISC area, that is
> > +  where the interrupt controller registers are located
> 
> Is this area shared with other devices?

Yes. The interrupt controller uses just a small area in this registers space 
(offsets 0x40 - 0x80). This trouble is that I also need access to the system 
global UC_IRQ_CONTROL register (offset 0x3a4), to configure interrupts channel 
and routing (IRQ/FIQ). I wonder whether register access via syscon is better.

> > +- interrupt-controller : Identifies the node as an interrupt controller
> > +- #interrupt-cells : Specifies the number of cells needed to encode an
> > +  interrupt source. The value shall be 1.
> 
> There is no configuration that can be applied to individual interrupt
> lines (e.g. trigger type)?

No. There is none.

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
