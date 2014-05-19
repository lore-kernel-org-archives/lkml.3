Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964881AbaESThm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 15:37:42 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:58161 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbaESThk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 15:37:40 -0400
MIME-Version: 1.0
In-Reply-To: <20140519191206.GH949@pengutronix.de>
References: <1400169891-29546-1-git-send-email-tthayer@altera.com>
	<1400169891-29546-2-git-send-email-tthayer@altera.com>
	<20140516075344.GF949@pengutronix.de>
	<CAF03EBfOrBWsGVkwYHQt9Pm858LtkgUThkM6dFjksa93ETo_bw@mail.gmail.com>
	<20140519191206.GH949@pengutronix.de>
Date: Mon, 19 May 2014 14:37:38 -0500
Message-ID: <CAF03EBfwFC7bK=j0W3K+no9TK7xe2nF1ZXH9bMBRNzVErB5EjQ@mail.gmail.com>
Subject: Re: [PATCHv5 1/3] dts: socfpga: Add bindings for Altera SoC SDRAM controller
From: Thor Thayer <tthayer.linux@gmail.com>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: Thor Thayer <tthayer@altera.com>, Rob Herring <robherring2@gmail.com>,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, Kumar Gala <galak@codeaurora.org>,
        Rob Landley <rob@landley.net>, linux@arm.linux.org.uk,
        Dinh Nguyen <dinguyen@altera.com>, dougthompson@xmission.com,
        Grant Likely <grant.likely@linaro.org>, Borislav Petkov <bp@alien8.de>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-edac@vger.kernel.org, atull@altera.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 2:12 PM, Steffen Trumtrar
<s.trumtrar@pengutronix.de> wrote:
> Hi Thor!
>
> On Mon, May 19, 2014 at 01:36:30PM -0500, Thor Thayer wrote:
>> On Fri, May 16, 2014 at 2:53 AM, Steffen Trumtrar
>> <s.trumtrar@pengutronix.de> wrote:
>> > Hi!
>> >
>> > On Thu, May 15, 2014 at 11:04:49AM -0500, tthayer@altera.com wrote:
>> >> From: Thor Thayer <tthayer@altera.com>
>> >>
>> >> Addition of the Altera SDRAM controller bindings and device
>> >> tree changes to the Altera SoC project.
>> >>
>> >> v2: Changes to SoC SDRAM EDAC code.
>> >>
>> >> v3: Implement code suggestions for SDRAM EDAC code.
>> >>
>> >> v4: Remove syscon from SDRAM controller bindings.
>> >>
>> >> v5: No Change, bump version for consistency.
>> >>
>> >> Signed-off-by: Thor Thayer <tthayer@altera.com>
>> >> ---
>> >>  .../bindings/arm/altera/socfpga-sdram.txt          |   11 +++++++++++
>> >>  arch/arm/boot/dts/socfpga.dtsi                     |    5 +++++
>> >>  2 files changed, 16 insertions(+)
>> >>  create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt
>> >>
>> >> diff --git a/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt
>> >> new file mode 100644
>> >> index 0000000..8f8746b
>> >> --- /dev/null
>> >> +++ b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt
>> >> @@ -0,0 +1,11 @@
>> >> +Altera SOCFPGA SDRAM Controller
>> >> +
>> >> +Required properties:
>> >> +- compatible : "altr,sdr-ctl";
>> >> +- reg : Should contain 1 register ranges(address and length)
>> >> +
>> >> +Example:
>> >> +     sdrctl@ffc25000 {
>> >> +             compatible = "altr,sdr-ctl";
>> >> +             reg = <0xffc25000 0x1000>;
>> >> +     };
>> >> diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
>> >> index df43702..6ce912e 100644
>> >> --- a/arch/arm/boot/dts/socfpga.dtsi
>> >> +++ b/arch/arm/boot/dts/socfpga.dtsi
>> >> @@ -676,6 +676,11 @@
>> >>                       clocks = <&l4_sp_clk>;
>> >>               };
>> >>
>> >> +             sdrctl@ffc25000 {
>> >> +                     compatible = "altr,sdr-ctl", "syscon";
>> >                                                    ^^^^^^^^^^
>> >
>> > Get rid of that, too, please.
>>
>> Hi Steffan,
>>
>> I believe I need to keep the "syscon". The same register (ctrlcfg)
>> that has the ECC enable bitfield also includes the DRAM configuration
>> bitfields that other drivers will want to access (specifically the
>> FPGA bridge needs this information). Since this register will be
>> shared between drivers,  syscon seems like the best solution.
>>
>
> Hm, from looking at the documentation of the ctrlcfg I can't really
> understand which bits you would need for the FPGA brigde and why.
> That all sounds like stuff you would want to set for the specific
> RAM you are dealing with on a specific board.
> What bridge are you talking about? The SDRAM bridge?
>
> I can see the problem with the ECC enable, though.
>
> Regards,
> Steffen
>

Hi Steffen,

I'll get more details from the guy working on the FPGA bridge when he
gets back in the office. When I started working on EDAC, that register
had been allocated by the FPGA bridge driver so we decided to use the
syscon to allow sharing of the register.

My understanding was that the FPGA bridge as an SDRAM master would
allow FPGA devices to access the SDRAM.  As part of that process, they
may want to read the SDRAM configuration.

I'll need to get more details from the driver developer because the
FPGA driver is in flux while the appropriate driver architecture is
being discussed.

Thor


>> >                 sdrctl@ffc25000 {
>> >                         compatible = "altr,sdr-ctl";
>> >                         reg = <0xffc25000 0x1000>;
>> >                         ranges;
>> >
>> >                         edac@ffc2502c {
>> >                                 compatible = "altr,sdram-edac";
>> >                                 reg = <0xffc2502c 0x50>;
>> >                                 interrupts = <0 39 4>;
>> >                         };
>> >                 };
>> >
>> > Then we can later add:
>> >
>> >                         sdr-ports: ports@ffc2507c {
>> >                                 #reset-cells = <1>;
>> >                                 compatible = "altr,sdr-ports";
>> >                                 reg = <0xffc2507c 0x10>;
>> >                                 clocks = <&ddr_dqs_clk>;
>> >                                 ...
>> >                         };
>
> --
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
