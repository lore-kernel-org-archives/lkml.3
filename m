Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933013AbaBUN5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:57:22 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39657 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932210AbaBUN5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 08:57:18 -0500
Date: Fri, 21 Feb 2014 13:57:13 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Michal Simek <monstr@monstr.eu>
Cc: Felipe Balbi <balbi@ti.com>,
        Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH RFC] usb: gadget: Add xilinx axi usb2 device support
Message-ID: <20140221135713.GB20449@e106331-lin.cambridge.arm.com>
References: <774153d4-d33f-4bb4-813b-582762bc3af9@TX2EHSMHS021.ehs.local>
 <20140220182257.GF23217@saruman.home>
 <20140221120454.GD8783@e106331-lin.cambridge.arm.com>
 <5307576F.5050506@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5307576F.5050506@monstr.eu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 01:41:03PM +0000, Michal Simek wrote:
> Hi Mark,
> 
> On 02/21/2014 01:04 PM, Mark Rutland wrote:
> > 
> > On Thu, Feb 20, 2014 at 06:23:13PM +0000, Felipe Balbi wrote:
> >> Hi,
> >>
> >> On Wed, Feb 19, 2014 at 03:10:45PM +0530, Subbaraya Sundeep Bhatta wrote:
> >>> This patch adds xilinx axi usb2 device driver support
> >>>
> >>> Signed-off-by: Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
> >>> ---
> >>>  .../devicetree/bindings/usb/xilinx_usb.txt         |   21 +
> >>>  drivers/usb/gadget/Kconfig                         |   14 +
> >>>  drivers/usb/gadget/Makefile                        |    1 +
> >>>  drivers/usb/gadget/xilinx_udc.c                    | 2045 ++++++++++++++++++++
> >>>  4 files changed, 2081 insertions(+), 0 deletions(-)
> >>>  create mode 100644 Documentation/devicetree/bindings/usb/xilinx_usb.txt
> >>>  create mode 100644 drivers/usb/gadget/xilinx_udc.c
> >>>
> >>> diff --git a/Documentation/devicetree/bindings/usb/xilinx_usb.txt b/Documentation/devicetree/bindings/usb/xilinx_usb.txt
> >>> new file mode 100644
> >>> index 0000000..acf03ab
> >>> --- /dev/null
> >>> +++ b/Documentation/devicetree/bindings/usb/xilinx_usb.txt
> >>> @@ -0,0 +1,21 @@
> >>> +Xilinx AXI USB2 device controller
> >>> +
> >>> +Required properties:
> >>> +- compatible		: Should be "xlnx,axi-usb2-device-4.00.a"
> > 
> > Is "axi-usb2-device" the official device name?
> 
> It is the name of IP which Xilinx have and we are using names in this format.
> 
> 
> >>> +- reg			: Physical base address and size of the Axi USB2
> >>> +			  device registers map.
> >>> +- interrupts		: Property with a value describing the interrupt
> >>> +			  number.
> > 
> > Does the device only have a single interrupt?
> 
> I believe so.
> 
> 
> >>> +- interrupt-parent	: Must be core interrupt controller
> > 
> > Is this strictly necessary?
> 
> I am not sure what do you mean by that. If you mean that interrupt-parent
> can be written to the root of DTS file then we can setup system with more
> interrupt controllers that's why it is required.

At which point it's not a required property of the node...

> If we can point to standard interrupt description then please point me to
> exact description you would like to see here and we can change it.

Unfortunately I'm not aware of a generic interrupts document. I just
don't see the point in each document listing interrupt-parent as a
requiredp roeprty when it's not. That said this is a trivial detail and
not really a blocker.

Cheers,
Mark
