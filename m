Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbaGDQkl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 12:40:41 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40990 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752257AbaGDQkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 12:40:39 -0400
Date: Fri, 4 Jul 2014 17:40:28 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: sundeep subbaraya <sundeep.lkml@gmail.com>
Cc: Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        "balbi@ti.com" <balbi@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Simek <michals@xilinx.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
Subject: Re: [PATCH v3 1/2] usb: doc: udc-xilinx: Add devicetree bindings
Message-ID: <20140704164028.GC7106@leverpostej>
References: <b0dfcba4-7319-4687-a455-bfcddf61b7d1@BN1AFFO11FD028.protection.gbl>
 <CALHRZup3_eFiw8iSJJmxy0dHDeHLnb2fAfRtKPTW1UQ2U+cEig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALHRZup3_eFiw8iSJJmxy0dHDeHLnb2fAfRtKPTW1UQ2U+cEig@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 07:44:10AM +0100, sundeep subbaraya wrote:
> Ping
> 
> Thanks,
> Sundeep.B.S.
> 
> On Tue, Jun 10, 2014 at 5:34 PM,  <subbaraya.sundeep.bhatta@xilinx.com> wrote:
> > From: Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
> >
> > Add devicetree bindings for Xilinx axi udc driver.
> >
> > Signed-off-by: Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
> > ---
> > Changes for v3:
> >         - None
> > Changes for v2:
> >         - replaced xlnx,include-dma with xlnx,has-builtin-dma
> >
> >  .../devicetree/bindings/usb/udc-xilinx.txt         |   20 ++++++++++++++++++++
> >  1 files changed, 20 insertions(+), 0 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/usb/udc-xilinx.txt
> >
> > diff --git a/Documentation/devicetree/bindings/usb/udc-xilinx.txt b/Documentation/devicetree/bindings/usb/udc-xilinx.txt
> > new file mode 100644
> > index 0000000..7c24fac
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/usb/udc-xilinx.txt
> > @@ -0,0 +1,20 @@
> > +Xilinx AXI USB2 device controller
> > +
> > +Required properties:
> > +- compatible           : Should be "xlnx,axi-usb2-device-4.00.a"

That's an interesting name. What's the product name? Is the a manual?

> > +- reg                  : Physical base address and size of the Axi USB2
> > +                         device registers map.
> > +- interrupts           : Property with a value describing the interrupt
> > +                         number.

Describe what this logically is. Everyone knows that this is a property
with a value, and everyone knows that an interrupts property describes
interrupts.

The ket point is _which_ interrupts this describes.

> > +- interrupt-parent     : Must be core interrupt controller

This isn't strictly necessary anyway.

> > +- xlnx,include-dma     : if DMA is included

You appear to have forgotten to fix this name, judging by the changelog
and example.

> > +
> > +Example:
> > +               axi-usb2-device@42e00000 {
> > +                        compatible = "xlnx,axi-usb2-device-4.00.a";
> > +                        interrupt-parent = <0x1>;

Huh? Who writes a raw phandle value?

> > +                        interrupts = <0x0 0x39 0x1>;
> > +                        reg = <0x42e00000 0x10000>;
> > +                        xlnx,has-builtin-dma;

As mentioned above, this conflicts with the binding documentation.
Please ensure the example is aligned with the documentation.

Thanks,
Mark.
