Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbaBUQNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:13:19 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42721 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755796AbaBUQNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:13:17 -0500
Date: Fri, 21 Feb 2014 16:13:12 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "michals@xilinx.com" <michals@xilinx.com>,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH RFC] usb: gadget: Add xilinx axi usb2 device support
Message-ID: <20140221161312.GA28555@e106331-lin.cambridge.arm.com>
References: <774153d4-d33f-4bb4-813b-582762bc3af9@TX2EHSMHS021.ehs.local>
 <20140220182257.GF23217@saruman.home>
 <20140221120454.GD8783@e106331-lin.cambridge.arm.com>
 <20140221154103.GF31902@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140221154103.GF31902@saruman.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 03:41:03PM +0000, Felipe Balbi wrote:
> Hi,
> 
> On Fri, Feb 21, 2014 at 12:04:54PM +0000, Mark Rutland wrote:
> > > > +Example:
> > > > + 		axi-usb2-device@42e00000 {
> > > > +                        compatible = "xlnx,axi-usb2-device-4.00.a";
> > > > +                        interrupt-parent = <0x1>;
> > > > +                        interrupts = <0x0 0x39 0x1>;
> > > > +                        reg = <0x42e00000 0x10000>;
> > > > +                        xlnx,include-dma = <0x1>;
> > > > +                };
> > > > +
> > > 
> > > you need to Cc devicetree@vger.kernel.org for this.
> > 
> > Cheers Filipe; thanks for adding us to Cc :)
> 
> sure, but it's "Felipe" ;-)

Whoops; sorry Felipe :)

> 
> > > > +	/* Map the registers */
> > > > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > > > +	udc->base_address = devm_ioremap_nocache(&pdev->dev, res->start,
> > > > +						 resource_size(res));
> > > 
> > > use devm_ioremap_resource() instead.
> > 
> > Also, res might be NULL. You should check that before dereferencing it.
> 
> not needed when using devm_ioremap_resource(), see the implementation.

Ah, good to know.

Cheers,
Mark.
