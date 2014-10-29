Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136AbaJ2U4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 16:56:38 -0400
Received: from mail-by2on0067.outbound.protection.outlook.com ([207.46.100.67]:60728
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754084AbaJ2U4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 16:56:36 -0400
Date: Wed, 29 Oct 2014 15:49:24 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
CC: <jgunthorpe@obsidianresearch.com>, <hpa@zytor.com>, <monstr@monstr.eu>,
        <michal.simek@xilinx.com>, <rdunlap@infradead.org>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <pantelis.antoniou@konsulko.com>,
        <robh+dt@kernel.org>, <grant.likely@linaro.org>,
        <iws@ovro.caltech.edu>, <linux-doc@vger.kernel.org>, <pavel@denx.de>,
        <broonie@kernel.org>, <philip@balister.org>, <rubini@gnudd.com>,
        <jason@lakedaemon.net>, <kyle.teske@ni.com>, <nico@linaro.org>,
        <balbi@ti.com>, <m.chehab@samsung.com>, <davidb@codeaurora.org>,
        <rob@landley.net>, <davem@davemloft.net>, <cesarb@cesarb.net>,
        <sameo@linux.intel.com>, <akpm@linux-foundation.org>,
        <linus.walleij@linaro.org>, <mgerlach@opensource.altera.com>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v2 2/3] ARM: dts: socfpga: fpga bridges bindings docs
In-Reply-To: <20141029075701.GA10262@pengutronix.de>
Message-ID: <alpine.DEB.2.02.1410291545250.29374@atx-linux-37>
References: <1414108267-22058-1-git-send-email-atull@opensource.altera.com> <1414108267-22058-3-git-send-email-atull@opensource.altera.com> <20141024070042.GL10262@pengutronix.de> <alpine.DEB.2.02.1410281601570.11910@atx-linux-37>
 <20141029075701.GA10262@pengutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: AMSPR02CA0046.eurprd02.prod.outlook.com (10.242.225.174) To
 BY2PR03MB314.namprd03.prod.outlook.com (10.141.139.19)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB314;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(51704005)(189002)(199003)(24454002)(51414003)(40100003)(4396001)(77096002)(93886004)(76176999)(83506001)(50986999)(31966008)(110136001)(15975445006)(122386002)(54356999)(80022003)(76482002)(99396003)(19580395003)(120916001)(19580405001)(69596002)(15202345003)(53416004)(86152002)(97736003)(87976001)(107046002)(101416001)(86362001)(92726001)(85852003)(92566001)(20776003)(106356001)(21056001)(95666004)(81156004)(105586002)(66066001)(46406003)(23726002)(64706001)(50466002)(33716001)(85306004)(42186005)(47776003)(46102003);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB314;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2014, Steffen Trumtrar wrote:

> Hi!
> 
> On Tue, Oct 28, 2014 at 04:19:03PM -0500, atull wrote:
> > On Fri, 24 Oct 2014, Steffen Trumtrar wrote:
> > 
> > > Hi!
> > > 
> > 
> > Hi,
> > 
> > I see that my documentation sucks and needs cleanup.  I'll try to
> > answer some of the flames and get a more coherent version out soon.
> > 
> > > On Thu, Oct 23, 2014 at 06:51:06PM -0500, atull@opensource.altera.com wrote:
> > > > From: Alan Tull <atull@opensource.altera.com>
> > > 
> > > (...)
> > > 
> > > > diff --git a/Documentation/devicetree/bindings/fpga/altera-hps2fpga-bridge.txt b/Documentation/devicetree/bindings/fpga/altera-hps2fpga-bridge.txt
> > > > new file mode 100644
> > > > index 0000000..bc24a2e
> > > > --- /dev/null
> > > > +++ b/Documentation/devicetree/bindings/fpga/altera-hps2fpga-bridge.txt
> > > > @@ -0,0 +1,53 @@
> > > > +Altera FPGA/HPS Bridge Driver
> > > > +
> > > > +This driver manages a bridge between a FPGA and a host processor system (HPS).
> > > > +User space can enable or disable the bridge by writing a "1" or a "0",
> > > > +respectively, to its enable file under bridge's entry in
> > > > +/sys/class/fpga-bridge.  Typically, one disables the bridges before
> > > > +reprogramming the FPGA.  Once the FPGA is reprogrammed, the bridges are
> > > > +reenabled.
> > > > +
> > > 
> > > NAK.
> > > 
> > > This is all linux specific and doesn't belong here.
> > 
> > Right.  This stuff shouldn't be in this document.  While I was squashing
> > patches and cleaning up for posting on the mailing list, I added a sysfs
> > document and forgot to clean up my DT bindings documents.
> > 
> > > 
> > > > +Required properties:
> > > > +
> > > > + - compatible     : should contain one of:
> > > > +                     "altr,socfpga-hps2fpga-bridge"
> > > > +                     "altr,socfpga-lwhps2fpga-bridge"
> > > > +                     "altr,socfpga-fpga2hps-bridge"
> > > > +
> > > > + - clocks         : clocks used by this module
> > > > +
> > > > + - altr,l3-syscon : phandle of the l3 interconnect module
> > > > +
> > > 
> > > L3 shouldn't be a syscon.
> > 
> > L3 is actually a good candidate for syscon.  Lots of registers, each one
> > affects a different hardware block.
> > 
> > > Have you tried dumping the regmap in the debugfs if L3
> > > is a syscon? Doesn't work.
> > 
> > Is that a bug in regmap or is that because the register in L3 that
> > I am actully interested in here is write-only (ugh)?
> >
> 
> That is not a bug in regmap. It is because you only have a register at 0x4008,
> than one at 0x4104, that one at 0x5008, etc.... (values from memory, so might
> be wrong)
> 
> Of course regmap tries to read from the whole register range if specified as
> syscon. Which it can't.
> 
> So, that shouldn't be a problem though, as I already cooked up a driver for
> the L3 with all the ranges specified. The only thing I need to figure out
> before I will post it, is how to nicely handle the WO remap register.
> I think regmap might be able to handle this itself, but am not sure yet.
> 
> > > 
> > > > +Optional properties:
> > > > + - label          : name that you want this bridge to show up as under
> > > > +                    /sys/class/fpga-bridge.  Default is br<device#> if this is
> > > > +                    not specified.
> > > > +
> > > 
> > > Why? Linux-specific.
> > 
> > That was a convience for the user.  I can take that out and won't miss it.
> > 
> > > 
> > > > + - init-val       : 0 if driver should disable bridge at startup
> > > > +                    1 if driver should enable bridge at startup
> > > > +                    driver leaves bridge in current state if property not
> > > > +                    specified.
> > > > +
> > > 
> > > Configuration in the DT? Really?
> > > 
> > > > +Example:
> > > > +	hps_fpgabridge0: fpgabridge@0 {
> > > > +		compatible = "altr,socfpga-hps2fpga-bridge";
> > > > +		label = "hps2fpga";
> > > > +		altr,l3-syscon = <&l3regs>;
> > > > +		clocks = <&l4_main_clk>;
> > > > +		init-val = <1>;
> > > > +	};
> > > > +
> > > > +	hps_fpgabridge1: fpgabridge@1 {
> > > > +		compatible = "altr,socfpga-lwhps2fpga-bridge";
> > > > +		label = "lwhps2fpga";
> > > > +		altr,l3-syscon = <&l3regs>;
> > > > +		clocks = <&l4_main_clk>;
> > > > +		init-val = <0>;
> > > > +	};
> > > > +
> > > > +	hps_fpgabridge2: fpgabridge@2 {
> > > > +		compatible = "altr,socfpga-fpga2hps-bridge";
> > > > +		label = "fpga2hps";
> > > > +		altr,l3-syscon = <&l3regs>;
> > > > +		clocks = <&l4_main_clk>;
> > > > +	};
> > > 
> > > The bridges are the buses into the FPGA. This has to be accomodated.
> > > The bridges have two specified memory ranges: one the address space
> > > of the bus, the second the register space for configuration.
> > > 
> > > This binding does NOT correctly describe the hardware. Sorry.
> > > 
> > 
> > OK that was outdated.  More cleanup needed.  How about this type of
> > binding?  Here's an actual use case for something that has multiple
> > pieces of soft IP in the FPGA (sysid, gpio).  I eliminated a few.
> > 
> > *snippet of DT*
> > sopc@0 {
> > 	device_type = "soc";
> > 	ranges;
> > 	#address-cells = <0x1>;
> > 	#size-cells = <0x1>;
> > 	compatible = "ALTR,avalon", "simple-bus";
> > 	bus-frequency = <0x0>;
> > 
> > 	bridge@0xc0000000 {
> > 		compatible = "altr,bridge-14.0", "simple-bus";
> > 		reg = <0xc0000000 0x20000000 0xff200000 0x200000>;
> > 		reg-names = "axi_h2f", "axi_h2f_lw";
> > 		clocks = <0x2 0x2 0x2>;
> > 		clock-names = "h2f_axi_clock", "h2f_lw_axi_clock",
> > 		              "f2h_sdram0_clock";
> > 		#address-cells = <0x2>;
> > 		#size-cells = <0x1>;
> > 		ranges = <0x0 0x0 0xc0000000 0x10000
> > 		          0x1 0x10000 0xff210000 0x8
> > 			  0x1 0x10040 0xff210040 0x20 
> > 			  0x1 0x10080 0xff210080 0x10 
> > 			  0x1 0x100c0 0xff2100c0 0x10 
> > 			  0x1 0x20000 0xff220000 0x8>;
> > 
> > 		sysid@0x100010000 {
> > 			compatible = "altr,sysid-14.0", "altr,sysid-1.0";
> > 			reg = <0x1 0x10000 0x8>;
> > 			clocks = <0x2>;
> > 			id = <0xacd51402>;
> > 			timestamp = <0x540a048e>;
> > 		};
> > 
> > 		gpio@0x100010040 {
> > 			compatible = "altr,pio-14.0", "altr,pio-1.0";
> > 			reg = <0x1 0x10040 0x20>;
> > 			clocks = <0x2>;
> > 			altr,gpio-bank-width = <0x4>;
> > 			resetvalue = <0x0>;
> > 			#gpio-cells = <0x2>;
> > 			gpio-controller;
> > 			linux,phandle = <0x2a>;
> > 		};
> > 
> > 		/* other hardware that exists on FPGA here */
> > 
> > 	};
> > };
> > 
> 
> Yes, something like this seems appropriate. Again, I also cooked up a driver
> for this. I need to figure out why the GPV register writing sometimes doesn't
> work as expected and will try to marry it to your FPGA manager framework
> before I consider sending it to the list.

Hi Steffen,

I look forward to seeing it.

> 
> My proposed binding at the moment looks like:
> 
> Example:
> 
> 	hps2fpga: axibridge@ff500000 {
> 		#address-cells = <1>;
> 		#size-cells = <1>;
> 		compatible = "altr,hps2fpga-axi-bridge";
> 		reg = <0xff500000 0x100000>,
> 		      <0xc0000000 0x3c000000>;
> 		clocks = <&l4_mp_clk>, <&l3_main_clk>;
> 		clock-names = "gpv_clk", "data_clk";
> 		resets = <&rst HPS2FPGA_RESET>;
> 		reset-names = "hps2fpga";
> 		altr,gpv-master = <&lwhps2fpga>;
> 		altr,l3-gpv = <&l3regs>;
> 		bus-width = <64>;
> 		status = "disabled";
> 		ranges;
> 	};
> 
> Board file example:
> 
> 	&hps2fpga {
> 		bus-width = <32>;
> 		status = "okay";
> 
> 		axi-ip: axi-ip@c0000000 {
> 			compatible = "axi-ip";
> 			reg = <0xc0000000 0x10000>;
> 			clocks = <&h2f_usr2_clk>;
> 			status = "okay";
> 		};
> 	};
> 
> So we seem to be almost on the same page. I first had the simple-bus in
> there, too. But this will lead to all sorts of problems regarding driver
> probing/removing on that bus.
> 

I think the problems we have had was that the bus had to be arch_initcall so
that it would be there before the drivers were.  Are there other problems
you are thinking of?  It would be good if we could get around that problem
as otherwise it will be a problem with the l3-nic not being early enough.

Alan


> Regards,
> Steffen
> 
> -- 
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
