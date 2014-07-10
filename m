Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbaGJUHL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 16:07:11 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:46196 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbaGJUHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 16:07:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAF03EBdBMphBLkGj4=_kGADF4iq_uUpyBbRJ7O63OvSHcR5hSw@mail.gmail.com>
References: <1403730927-16163-1-git-send-email-tthayer@altera.com>
	<1403730927-16163-3-git-send-email-tthayer@altera.com>
	<20140626094507.GM15240@leverpostej>
	<CAF03EBdBMphBLkGj4=_kGADF4iq_uUpyBbRJ7O63OvSHcR5hSw@mail.gmail.com>
Date: Thu, 10 Jul 2014 15:07:04 -0500
Message-ID: <CANk1AXQ1Aw-8Et_XE9BSL42r_DGxLiwOdyjA7YxMJMw6Fc=YUg@mail.gmail.com>
Subject: Re: [PATCHv7 2/3] devicetree: Addition of the Altera SDRAM EDAC.
From: Alan Tull <delicious.quinoa@gmail.com>
To: Thor Thayer <tthayer.linux@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "tthayer@altera.com" <tthayer@altera.com>,
        "robherring2@gmail.com" <robherring2@gmail.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "dinguyen@altera.com" <dinguyen@altera.com>,
        "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "bp@alien8.de" <bp@alien8.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 9, 2014 at 3:07 PM, Thor Thayer <tthayer.linux@gmail.com> wrote:
>
> On Thu, Jun 26, 2014 at 4:45 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> > On Wed, Jun 25, 2014 at 10:15:26PM +0100, tthayer@altera.com wrote:
> >> From: Thor Thayer <tthayer@altera.com>
> >>
> >> Add the Altera SDRAM EDAC bindings and device tree changes to the Altera SoC project.
> >>
> >> Signed-off-by: Thor Thayer <tthayer@altera.com>
> >> ---
> >> v2: Changes to SoC EDAC source code.
> >>
> >> v3: Fix typo in device tree documentation.
> >>
> >> v4,v5: No changes - bump version for consistency.
> >>
> >> v6: Assign ECC registers in SDRAM controller to EDAC
> >>
> >> v7: Fix SDRAM EDAC base address.
> >> ---
> >>  .../bindings/arm/altera/socfpga-sdram-edac.txt     |   15 +++++++++++++++
> >>  arch/arm/boot/dts/socfpga.dtsi                     |    6 ++++++
> >>  2 files changed, 21 insertions(+)
> >>  create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt
> >>
> >> diff --git a/Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt
> >> new file mode 100644
> >> index 0000000..d68e033
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt
> >> @@ -0,0 +1,15 @@
> >> +Altera SOCFPGA SDRAM Error Detection & Correction [EDAC]
> >> +
> >> +Required properties:
> >> +- compatible : should contain "altr,sdram-edac";
> >> +- reg : should contain the ECC register range in sdram
> >> +        controller (address and length).
> >> +- interrupts : Should contain the SDRAM ECC IRQ in the
> >> +     appropriate format for the IRQ controller.
> >> +
> >> +Example:
> >> +     sdramedac@ffc2502c {
> >> +             compatible = "altr,sdram-edac";
> >> +             reg = <0xffc2502c 0x28>;
> >> +             interrupts = <0 39 4>;
> >> +     };
> >> diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
> >> index 310292e..da0785d 100644
> >> --- a/arch/arm/boot/dts/socfpga.dtsi
> >> +++ b/arch/arm/boot/dts/socfpga.dtsi
> >> @@ -687,6 +687,12 @@
> >>                       reg = <0xffc25000 0x4>;
> >>               };
> >>
> >> +             sdramedac@ffc2502c {
> >> +                     compatible = "altr,sdram-edac";
> >> +                     reg = <0xffc2502c 0x28>;
> >> +                     interrupts = <0 39 4>;
> >> +             };
> >
> > I'm not sure I understand this. The ECC register existing within the
> > SDRAM controller, which we have a binding for. Why do we need a separate
> > binding for a subset of registers within an IP block?
> >
> > Why can we not have a single binding for the entire SDRAM controlelr and
> > decompse that within Linux as it makes sense for the appropriate
> > subsystyems?
> >
> > Leaking Linux design into bindings is a bad idea; it makes it harder to
> > change things.
> >
> > Mark.
>
> Hi Mark,
>
> How would we decompose this within Linux. MFD? Is there an example
> that I can look at?
>
> We originally used syscon for the entire sdram controller register
> block but we got dinged on it.

I think it is good feedback that we don't want the devicetree to break
up this register range (unless someone wants to argue that).

The problem we need to solve here is that the sdram controller
register range has registers that are needed for at least 3 different
functions/drivers: edac, fpga bridges, and loe power mode (putting ddr
in self-refresh).  We would not want to do that in one driver.
Originally we had the whole sdram controller as 'syscon' and that was
frowned upon.  I think someone suggested a MFD.  We can do that and
will do that if that will move things forward.  But that would just be
a mfd that ioremaps the range and provides read/write functions for
other drivers to use (which starts looking very similar to syscon
except that it adds more code to the kernel to do what syscon does).
It seems like that's what syscon was for (looking at
Documentation/devicetree/bindings/mfd/syscon.txt).

So can we have a consensus here on syscon or a very minimal mfd or
some other clear way of moving forward?

Alan

>
> Thanks for your help.
>
> Thor
