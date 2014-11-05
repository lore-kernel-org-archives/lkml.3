Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678AbaKERH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:07:56 -0500
Received: from mail-bn1bon0093.outbound.protection.outlook.com ([157.56.111.93]:21760
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754617AbaKERHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:07:54 -0500
Date: Wed, 5 Nov 2014 09:07:37 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Andreas =?utf-8?Q?F=C3=A4rber?= <afaerber@suse.de>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Heiko Stuebner <heiko@sntech.de>, <linux-sh@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        <linux-rockchip@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>
Subject: Re: [PATCH 4/7] pinctrl: zynq: Document DT binding
References: <1415041531-15520-1-git-send-email-soren.brinkmann@xilinx.com>
 <1415041531-15520-5-git-send-email-soren.brinkmann@xilinx.com>
 <54599AF6.1030404@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54599AF6.1030404@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21076.007
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <bd330b9362414af486fedccacbfe5ba1@BN1BFFO11FD018.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(199003)(24454002)(189002)(377424004)(52604005)(51704005)(31966008)(44976005)(21056001)(83506001)(87936001)(104016003)(76176999)(50986999)(47776003)(20776003)(64706001)(74316001)(23676002)(92566001)(19580405001)(19580395003)(85182001)(6806004)(110136001)(86362001)(54356999)(108616004)(95666004)(50466002)(4396001)(99396003)(46102003)(120916001)(107046002)(33646002)(77156002)(77096003)(85202003)(106466001)(53416004)(62966003)(102836001)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB013;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB013;
X-Forefront-PRVS: 0386B406AA
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-05 at 04:35AM +0100, Andreas Färber wrote:
> Am 03.11.2014 um 20:05 schrieb Soren Brinkmann:
> > Add documentation for the devicetree binding for the Zynq pincontroller.
> > 
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > ---
> >  .../bindings/pinctrl/xlnx,zynq-pinctrl.txt         | 90 ++++++++++++++++++++++
> >  1 file changed, 90 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/pinctrl/xlnx,zynq-pinctrl.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/pinctrl/xlnx,zynq-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/xlnx,zynq-pinctrl.txt
> > new file mode 100644
> > index 000000000000..86a86b644e6c
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/pinctrl/xlnx,zynq-pinctrl.txt
> > @@ -0,0 +1,90 @@
> > +	Binding for Xilinx Zynq Pinctrl
> > +
> > +Required properties:
> > +- compatible: "xlnx,zynq-pinctrl"
> > +- syscon: phandle to SLCR
> > +- reg: Offset and length of pinctrl space in SLCR
> > +
> > +Please refer to pinctrl-bindings.txt in this directory for details of the
> > +common pinctrl bindings used by client devices, including the meaning of the
> > +phrase "pin configuration node".
> > +
> > +Zynq's pin configuration nodes act as a container for an abitrary number of
> 
> "arbitrary"

I'll fix that.

> 
> > +subnodes. Each of these subnodes represents some desired configuration for a
> > +pin, a group, or a list of pins or groups. This configuration can include the
> > +mux function to select on those pin(s)/group(s), and various pin configuration
> > +parameters, such as pull-up, slew rate, etc.
> > +
> > +The name of each subnode is not important; all subnodes should be enumerated
> > +and processed purely based on their content.
> > +
> > +Each subnode only affects those parameters that are explicitly listed. In
> > +other words, a subnode that lists a mux function but no pin configuration
> > +parameters implies no information about any pin configuration parameters.
> > +Similarly, a pin subnode that describes a pullup parameter implies no
> > +information about e.g. the mux function.
> > +
> > +
> > +The following generic properties as defined in pinctrl-bindings.txt are valid
> > +to specify in a pin configuration subnode:
> > + groups, pins, function, bias-disable, bias-high-impedance, bias-pull-up,
> > + slew-rate, low-power-disable, low-power-enable
> > +
> > + Valid arguments for 'slew-rate' are '0' and '1' to select between slow and fast
> > + respectively.
> > +
> > + Valid values for groups are:
> > +   ethernet0_0_grp, ethernet1_0_grp, mdio0_0_grp, mdio1_0_grp,
> > +   qspi0_0_grp, qspi1_0_grp, qspi_fbclk, qspi_cs1_grp, spi0_0_grp,
> > +   spi0_1_grp - spi0_2_grp, spi1_0_grp - spi1_3_grp, sdio0_0_grp - sdio0_2_grp,
> > +   sdio1_0_grp - sdio1_3_grp, sdio0_emio_wp, sdio0_emio_cd, sdio1_emio_wp,
> > +   sdio1_emio_cd, smc0_nor, smc0_nor_cs1_grp, smc0_nor_addr25_grp, smc0_nand,
> > +   can0_0_grp - can0_10_grp, can1_0_grp - can1_11_grp, uart0_0_grp - uart0_10_grp,
> > +   uart1_0_grp - uart1_11_grp, i2c0_0_grp - i2c0_10_grp, i2c1_0_grp - i2c1_10_grp,
> > +   ttc0_0_grp - ttc0_2_grp, ttc1_0_grp - ttc1_2_grp, swdt0_0_grp - swdt0_4_grp,
> > +   gpio0_0_grp - gpio0_53_grp
> > +
> > + Valid values for pins are:
> > +   MIO0 - MIO53
> 
> What about the four EMIO_SD* pins?

You can't do any pinconf on those and the config_(set|get) return some
error code when you pass anything but the 54 MIO pins to those
functions. So, they are actually not valid for PINs. They are only used
as group for pinmuxing where the respective group needs to be used.

> 
> > +
> > + Valid values for function are:
> > +   ethernet0, ethernet1, mdio0, mdio1, qspi0, qspi1, qspi_fbclk, qspi_cs1,
> > +   spi0, spi1, sdio0, sdio0_pc, sdio0_cd, sdio0_wp,
> > +   sdio1, sdio1_pc, sdio1_cd, sdio1_wp,
> > +   smc0_nor, smc0_nor_cs1, smc0_nor_addr25, smc0_nand, can0, can1, uart0, uart1,
> > +   i2c0, i2c1, ttc0, ttc1, swdt0, gpio0
> > +
> > +The following driver-specific properties as defined here are valid to specify in
> > +a pin configuration subnode:
> > + - io-standard: Configure the pin to use the selected IO standard according to
> > +   this mapping:
> > +    1: LVCMOS18
> > +    2: LVCMOS25
> > +    3: LVCMOS33
> > +    4: HSTL
> > +
> > +Example:
> > +	pinctrl0: pinctrl@700 {
> > +		compatible = "xlnx,pinctrl-zynq";
> > +		reg = <0x700 0x200>;
> > +		syscon = <&slcr>;
> > +
> > +		pinctrl_uart1_default: pinctrl-uart1-default {
> 
> Nit: Is it really necessary to prefix subnodes of "pinctrl@700" with
> "pinctrl-", here and in .dts?

Guess not. Is there any best practice for naming pinctrl-state nodes?
I might shorten it.

> 
> > +			common {
> > +				groups = "uart1_10_grp";
> > +				function = "uart1";
> > +				slew-rate = <0>;
> > +				io-standard = <1>;
> > +			};
> > +
> > +			rx {
> > +				pins = "MIO49";
> > +				bias-high-impedance;
> > +			};
> > +
> > +			tx {
> > +				pins = "MIO48";
> > +				bias-disable;
> > +			};
> > +		};
> > +	};
> 
> Otherwise looks good.

Thanks for reviewing.

	Sören
