Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbaE0TnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 15:43:23 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59956 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbaE0TnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 15:43:22 -0400
Date: Tue, 27 May 2014 21:42:28 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Alan Tull <delicious.quinoa@gmail.com>
Cc: Thor Thayer <tthayer.linux@gmail.com>, Thor Thayer <tthayer@altera.com>,
        Rob Herring <robherring2@gmail.com>, pawel.moll@arm.com,
        Mark Rutland <mark.rutland@arm.com>, ijc+devicetree@hellion.org.uk,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        linux@arm.linux.org.uk, Dinh Nguyen <dinguyen@altera.com>,
        dougthompson@xmission.com, Grant Likely <grant.likely@linaro.org>,
        Borislav Petkov <bp@alien8.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        Alan Tull <atull@altera.com>
Subject: Re: [PATCHv5 1/3] dts: socfpga: Add bindings for Altera SoC SDRAM
 controller
Message-ID: <20140527194228.GB13172@pengutronix.de>
References: <1400169891-29546-2-git-send-email-tthayer@altera.com>
 <20140516075344.GF949@pengutronix.de>
 <CAF03EBfOrBWsGVkwYHQt9Pm858LtkgUThkM6dFjksa93ETo_bw@mail.gmail.com>
 <20140519191206.GH949@pengutronix.de>
 <CAF03EBfwFC7bK=j0W3K+no9TK7xe2nF1ZXH9bMBRNzVErB5EjQ@mail.gmail.com>
 <CANk1AXTdSheUkNtF2fSmtcYaUrd2CnTjBxGitmSy88H4VRVbnw@mail.gmail.com>
 <20140520144446.GJ949@pengutronix.de>
 <CAF03EBe+G8EpZSU7vhu4QZ3E-Nq4WnHw7DRM7=EyxHkjzp5cqg@mail.gmail.com>
 <20140527071157.GC20695@pengutronix.de>
 <CANk1AXTMHuWeaxn_hVi+AH=aXbbSNov=894YmSYfvfvpWM+eSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANk1AXTMHuWeaxn_hVi+AH=aXbbSNov=894YmSYfvfvpWM+eSg@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 21:22:32 up 34 days, 12:53, 35 users,  load average: 0,08, 0,11,
 0,13
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 02:12:17PM -0500, Alan Tull wrote:
> On Tue, May 27, 2014 at 2:11 AM, Steffen Trumtrar
> <s.trumtrar@pengutronix.de> wrote:
> > On Wed, May 21, 2014 at 10:38:34AM -0500, Thor Thayer wrote:
> >> On Tue, May 20, 2014 at 9:44 AM, Steffen Trumtrar
> >> <s.trumtrar@pengutronix.de> wrote:
> >> > Hi!
> >> >
> >> > On Tue, May 20, 2014 at 09:31:06AM -0500, Alan Tull wrote:
> >> >> On Mon, May 19, 2014 at 2:37 PM, Thor Thayer <tthayer.linux@gmail.com> wrote:
> >> >>
> >> >> >>> >> diff --git a/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt
> >> >> >>> >> new file mode 100644
> >> >> >>> >> index 0000000..8f8746b
> >> >> >>> >> --- /dev/null
> >> >> >>> >> +++ b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt
> >> >> >>> >> @@ -0,0 +1,11 @@
> >> >> >>> >> +Altera SOCFPGA SDRAM Controller
> >> >> >>> >> +
> >> >> >>> >> +Required properties:
> >> >> >>> >> +- compatible : "altr,sdr-ctl";
> >> >> >>> >> +- reg : Should contain 1 register ranges(address and length)
> >> >> >>> >> +
> >> >> >>> >> +Example:
> >> >> >>> >> +     sdrctl@ffc25000 {
> >> >> >>> >> +             compatible = "altr,sdr-ctl";
> >> >> >>> >> +             reg = <0xffc25000 0x1000>;
> >> >> >>> >> +     };
> >> >> >>> >> diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
> >> >> >>> >> index df43702..6ce912e 100644
> >> >> >>> >> --- a/arch/arm/boot/dts/socfpga.dtsi
> >> >> >>> >> +++ b/arch/arm/boot/dts/socfpga.dtsi
> >> >> >>> >> @@ -676,6 +676,11 @@
> >> >> >>> >>                       clocks = <&l4_sp_clk>;
> >> >> >>> >>               };
> >> >> >>> >>
> >> >> >>> >> +             sdrctl@ffc25000 {
> >> >> >>> >> +                     compatible = "altr,sdr-ctl", "syscon";
> >> >> >>> >                                                    ^^^^^^^^^^
> >> >> >>> >
> >> >> >>> > Get rid of that, too, please.
> >> >> >>>
> >> >> >>> Hi Steffan,
> >> >> >>>
> >> >> >>> I believe I need to keep the "syscon". The same register (ctrlcfg)
> >> >> >>> that has the ECC enable bitfield also includes the DRAM configuration
> >> >> >>> bitfields that other drivers will want to access (specifically the
> >> >> >>> FPGA bridge needs this information). Since this register will be
> >> >> >>> shared between drivers,  syscon seems like the best solution.
> >> >> >>>
> >> >> >>
> >> >> >> Hm, from looking at the documentation of the ctrlcfg I can't really
> >> >> >> understand which bits you would need for the FPGA brigde and why.
> >> >>
> >> >> Hi Steffen,
> >> >>
> >> >> Offset 0x80 in the sdr-ctl is the "fpgaportrst" register.  14 bits
> >> >> wide, defaults to 0.  When appropriate bits set to 1 in that reg, it
> >> >> allows an FPGA port to come out of reset (enables that port).  Has no
> >> >> other effect on SDRAM configuration.
> >> >>
> >> >> >> That all sounds like stuff you would want to set for the specific
> >> >> >> RAM you are dealing with on a specific board.
> >> >> >> What bridge are you talking about? The SDRAM bridge?
> >> >>
> >> >> Yes, the port allows the FPGA a direct path to the SDRAM.  This one
> >> >> register the only register in the sdr that the bridge driver needs.
> >> >>
> >> >
> >> > So, what I suggested down ...
> >> >
> >> >> >>
> >> >> >> I can see the problem with the ECC enable, though.
> >> >> >>
> >> >> >> Regards,
> >> >> >> Steffen
> >> >> >>
> >> >> >
> >> >> >>> >                 sdrctl@ffc25000 {
> >> >> >>> >                         compatible = "altr,sdr-ctl";
> >> >> >>> >                         reg = <0xffc25000 0x1000>;
> >> >> >>> >                         ranges;
> >> >> >>> >
> >> >> >>> >                         edac@ffc2502c {
> >> >> >>> >                                 compatible = "altr,sdram-edac";
> >> >> >>> >                                 reg = <0xffc2502c 0x50>;
> >> >> >>> >                                 interrupts = <0 39 4>;
> >> >> >>> >                         };
> >> >> >>> >                 };
> >> >> >>> >
> >> >> >>> > Then we can later add:
> >> >> >>> >
> >> >> >>> >                         sdr-ports: ports@ffc2507c {
> >> >> >>> >                                 #reset-cells = <1>;
> >> >> >>> >                                 compatible = "altr,sdr-ports";
> >> >> >>> >                                 reg = <0xffc2507c 0x10>;
> >> >> >>> >                                 clocks = <&ddr_dqs_clk>;
> >> >> >>> >                                 ...
> >> >> >>> >                         };
> >> >>
> >> >
> >> > ... here should work. No?! Just a simple driver that registers with the
> >> > reset-framework. I would add 0x7c to that driver and than that driver could
> >> > "configure" the port and let it out of reset.
> >> >
> >> > I have done the same thing for the other 3 bridges, but am not finished yet.
> >> > Especially the GPV-stuff needs to at least be able to be added later if not now.
> >> >
> >
> > Hi Thor!
> >
> >> I'm not clear on how the EDAC driver will interact with the registers
> >> allocated to the SDRAM controller. If the group of registers from
> >> 0xffc25000 to 0xffc26000 is exclusively allocated to the SDRAM
> >> controller, how does the EDAC driver cleanly access that single
> >> register inside this range?
> >>
> >
> > The compatible in the example is wrong. I didn't mean to map the whole address space
> > to some driver.
> > I think for the configuration register syscon is the right approach. It is a
> > bag of bits that don't necessitate an own driver, so syscon is perfect.
> >
> > So, let me change my proposal to
> >
> >         sdr-ctl: sdram@ffc25000 {
> >                 compatible = "altr,sdr-ctl", "syscon";
> >                 reg = <0xffc25000 0x1>;
> >         };
> >
> >         edac: edac@ffc2502c {
> >                 compatible = "altr,sdram-edac";
> >                 reg = <0xffc2502c 0x50>;
> >                 interrupts = <0 39 4>;
> >                 config = <&sdr-ctl>;
> >                 ...
> >         };
> >
> >         sdr-ports: ports@ffc2507c {
> >                 compatible = "altr,sdr-ports";
> >                 reg = <0xffc2507c 0x10>;
> >                 clocks = <&ddr_dqs_clk>;
> >                 ...
> >         };
> >
> > Maybe we can just skip the outer node that combines all the others.
> > So, if we do it like that, you can still use syscon, but only for the register
> > that needs it. And the EDAC definitely needs access to the config register, so
> > all is good.
> >
> >> Is the solution that I don't use request_region() (and therefore not
> >> request exclusive access) when setting up the SDRAM controller?
> >>
> >> If you could point me to your drivers for the other bridges that you
> >> reference, your code may answer my question.
> >>
> >
> > The other bridges don't need access to any SDRAM controller registers and
> > I haven't even started to implement the GPV-stuff with the lw2hps-bridge :-(
> >
> > Regards,
> > Steffen
> >
> > --
> > Pengutronix e.K.                           |                             |
> > Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> > Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> > Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
> 
> OK now I understand.  For register offset 0x0, that's all stuff set up
> in the bootloader.  We won't be touching that register except for the
> EDAC.  So syscon isn't needed here.
> 
> Each driver that uses some sdr registers can specify which registers
> it uses in the device tree.  So far we don't have any cases of two
> drivers that share a register.
> 
> The ECC driver will need two ranges: offset 0x00 and 0x38 through 0x50.
> The fpga bridges just needs offset 0x80.
> 

Well, almost ;-)
Use syscon for 0x0 and reference that in the ECC driver, which only is
responsible for 0x38 to 0x50. Then flip the two EDAC bits via the syscon-phandle.
Then a bootloader can probe with the same dts and have a driver match on the
config-register and one for all the DRAM setup (< 0x38), which we don't need in
the kernel. On the other hand the EDAC seems unneccessary for the bootloader.
And this all matches the partitioning of the SDR register space, so I think it
is also a correct hardware description.

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
