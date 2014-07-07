Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314AbaGGGZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 02:25:20 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:34486 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbaGGGZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 02:25:17 -0400
MIME-Version: 1.0
In-Reply-To: <20140704164028.GC7106@leverpostej>
References: <b0dfcba4-7319-4687-a455-bfcddf61b7d1@BN1AFFO11FD028.protection.gbl>
	<CALHRZup3_eFiw8iSJJmxy0dHDeHLnb2fAfRtKPTW1UQ2U+cEig@mail.gmail.com>
	<20140704164028.GC7106@leverpostej>
Date: Mon, 7 Jul 2014 11:55:15 +0530
Message-ID: <CALHRZupsas7=7NB8PHUub7nB3_Z++yJO0z9RYTU49tx87vSApA@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] usb: doc: udc-xilinx: Add devicetree bindings
From: sundeep subbaraya <sundeep.lkml@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        "balbi@ti.com" <balbi@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Simek <michals@xilinx.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jul 4, 2014 at 10:10 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> On Tue, Jun 24, 2014 at 07:44:10AM +0100, sundeep subbaraya wrote:
>> Ping
>>
>> Thanks,
>> Sundeep.B.S.
>>
>> On Tue, Jun 10, 2014 at 5:34 PM,  <subbaraya.sundeep.bhatta@xilinx.com> wrote:
>> > From: Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
>> >
>> > Add devicetree bindings for Xilinx axi udc driver.
>> >
>> > Signed-off-by: Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
>> > ---
>> > Changes for v3:
>> >         - None
>> > Changes for v2:
>> >         - replaced xlnx,include-dma with xlnx,has-builtin-dma
>> >
>> >  .../devicetree/bindings/usb/udc-xilinx.txt         |   20 ++++++++++++++++++++
>> >  1 files changed, 20 insertions(+), 0 deletions(-)
>> >  create mode 100644 Documentation/devicetree/bindings/usb/udc-xilinx.txt
>> >
>> > diff --git a/Documentation/devicetree/bindings/usb/udc-xilinx.txt b/Documentation/devicetree/bindings/usb/udc-xilinx.txt
>> > new file mode 100644
>> > index 0000000..7c24fac
>> > --- /dev/null
>> > +++ b/Documentation/devicetree/bindings/usb/udc-xilinx.txt
>> > @@ -0,0 +1,20 @@
>> > +Xilinx AXI USB2 device controller
>> > +
>> > +Required properties:
>> > +- compatible           : Should be "xlnx,axi-usb2-device-4.00.a"
>
> That's an interesting name. What's the product name? Is the a manual?

Here is the manual for the IP :

http://www.xilinx.com/support/documentation/ip_documentation/axi_usb2_device/v5_0/pg137-axi-usb2-device.pdf

This driver works with PLB IP version that's why maybe make more sense
to use skip axi from compatible string and use just
xlnx,usb2-device-4.00.a.

>
>> > +- reg                  : Physical base address and size of the Axi USB2
>> > +                         device registers map.
>> > +- interrupts           : Property with a value describing the interrupt
>> > +                         number.
>
> Describe what this logically is. Everyone knows that this is a property
> with a value, and everyone knows that an interrupts property describes
> interrupts.
>
> The ket point is _which_ interrupts this describes.

Ok

>
>> > +- interrupt-parent     : Must be core interrupt controller
>
> This isn't strictly necessary anyway.
>
>> > +- xlnx,include-dma     : if DMA is included
>
> You appear to have forgotten to fix this name, judging by the changelog
> and example.
>
>> > +
>> > +Example:
>> > +               axi-usb2-device@42e00000 {
>> > +                        compatible = "xlnx,axi-usb2-device-4.00.a";
>> > +                        interrupt-parent = <0x1>;
>
> Huh? Who writes a raw phandle value?
>
>> > +                        interrupts = <0x0 0x39 0x1>;
>> > +                        reg = <0x42e00000 0x10000>;
>> > +                        xlnx,has-builtin-dma;
>
> As mentioned above, this conflicts with the binding documentation.
> Please ensure the example is aligned with the documentation.

Thank you for pointing this i sent an old one, will fix this.

Sundeep.B.S.

>
> Thanks,
> Mark.
