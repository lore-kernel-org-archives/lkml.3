Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbaBUMFA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:05:00 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37232 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754118AbaBUME6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:04:58 -0500
Date: Fri, 21 Feb 2014 12:04:54 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Felipe Balbi <balbi@ti.com>,
        Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "michals@xilinx.com" <michals@xilinx.com>,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH RFC] usb: gadget: Add xilinx axi usb2 device support
Message-ID: <20140221120454.GD8783@e106331-lin.cambridge.arm.com>
References: <774153d4-d33f-4bb4-813b-582762bc3af9@TX2EHSMHS021.ehs.local>
 <20140220182257.GF23217@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140220182257.GF23217@saruman.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, Feb 20, 2014 at 06:23:13PM +0000, Felipe Balbi wrote:
> Hi,
> 
> On Wed, Feb 19, 2014 at 03:10:45PM +0530, Subbaraya Sundeep Bhatta wrote:
> > This patch adds xilinx axi usb2 device driver support
> > 
> > Signed-off-by: Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
> > ---
> >  .../devicetree/bindings/usb/xilinx_usb.txt         |   21 +
> >  drivers/usb/gadget/Kconfig                         |   14 +
> >  drivers/usb/gadget/Makefile                        |    1 +
> >  drivers/usb/gadget/xilinx_udc.c                    | 2045 ++++++++++++++++++++
> >  4 files changed, 2081 insertions(+), 0 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/usb/xilinx_usb.txt
> >  create mode 100644 drivers/usb/gadget/xilinx_udc.c
> > 
> > diff --git a/Documentation/devicetree/bindings/usb/xilinx_usb.txt b/Documentation/devicetree/bindings/usb/xilinx_usb.txt
> > new file mode 100644
> > index 0000000..acf03ab
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/usb/xilinx_usb.txt
> > @@ -0,0 +1,21 @@
> > +Xilinx AXI USB2 device controller
> > +
> > +Required properties:
> > +- compatible		: Should be "xlnx,axi-usb2-device-4.00.a"

Is "axi-usb2-device" the official device name?

> > +- reg			: Physical base address and size of the Axi USB2
> > +			  device registers map.
> > +- interrupts		: Property with a value describing the interrupt
> > +			  number.

Does the device only have a single interrupt?

> > +- interrupt-parent	: Must be core interrupt controller

Is this strictly necessary?

> > +- xlnx,include-dma	: Must be 1 or 0 based on whether DMA is included
> > +			  in IP or not.

Perhaps xlnx,has-builtin-dma would better describe this?

> > +
> > +Example:
> > + 		axi-usb2-device@42e00000 {
> > +                        compatible = "xlnx,axi-usb2-device-4.00.a";
> > +                        interrupt-parent = <0x1>;
> > +                        interrupts = <0x0 0x39 0x1>;
> > +                        reg = <0x42e00000 0x10000>;
> > +                        xlnx,include-dma = <0x1>;
> > +                };
> > +
> 
> you need to Cc devicetree@vger.kernel.org for this.

Cheers Filipe; thanks for adding us to Cc :)

[...]

> > +	/* Map the registers */
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	udc->base_address = devm_ioremap_nocache(&pdev->dev, res->start,
> > +						 resource_size(res));
> 
> use devm_ioremap_resource() instead.

Also, res might be NULL. You should check that before dereferencing it.

Cheers,
Mark.
