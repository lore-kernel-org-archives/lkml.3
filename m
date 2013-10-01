Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab3JALgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 07:36:31 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:58817 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab3JALg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 07:36:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Simon Horman <horms@verge.net.au>
Cc: takasi-y@ops.dti.ne.jp, SH-Linux <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, ben.dooks@codethink.co.uk,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        devicetree@vger.kernel.org, linux-serial@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] ARM: shmobile: emev2: Define SMU clock DT bindings
Date: Tue, 01 Oct 2013 13:36:33 +0200
Message-ID: <21574726.tiJa6Opb1k@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130924045215.GE3619@verge.net.au>
References: <52410F86.4040301@renesas.com> <20130924131331.0e9a5f830f531655b2ea0ebe@ops.dti.ne.jp> <20130924045215.GE3619@verge.net.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yoshii-san and Simon,

On Tuesday 24 September 2013 13:52:15 Simon Horman wrote:
> [ Cc Laurent ]
> 
> On Tue, Sep 24, 2013 at 01:13:31PM +0900, takasi-y@ops.dti.ne.jp wrote:
> > Device tree clock binding document for EMMA Mobile EV2 SMU.
> > Following nodes are defined to describe clock tree.
> > - renesas,emev2-smu
> > - renesas,emev2-smu-clkdiv
> > - renesas,emev2-smu-gclk
> 
> I realise this has been entirely consistent in the past and
> even as recently as Linus' pre v3.12-rc2 master branch.
> However, after some recent discussion we are now trying to make our
> compatibility strings consistently of the form renesas,<unit>-<soc>.
> 
> With this in mind I believe the strings should be:
> 
> - renesas,smu-emev2
> - renesas,smu-clkdiv-emev2
> - renesas,smu-gclk-emev2
> 
> To be honest I am not quite sure about the "-clkdiv" and "-gclk"
> bits and I would appreciate some review from others.

I don't have access to the EMEV2 datasheet so my ability to comment on this is 
somehow limited. However, given that the clock hardware is very SoC-specific, 
it might make sense to keep the names proposed by Yoshii-san. This would be 
consistent with the other clock bindings.

> I have CCed Laurent as he may have some advice to offer here.
> 
> > These bindings are designed manually based on
> > 
> >  19UH0037EJ1000_SMU : System Management Unit User's Manual
> > 
> > Signed-off-by: Takashi Yoshii <takashi.yoshii.zj@renesas.com>
> > ---
> > 
> >  .../devicetree/bindings/clock/emev2-clock.txt      | 99 +++++++++++++++++
> >  1 file changed, 99 insertions(+)
> >  create mode 100644
> >  Documentation/devicetree/bindings/clock/emev2-clock.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/clock/emev2-clock.txt
> > b/Documentation/devicetree/bindings/clock/emev2-clock.txt new file mode
> > 100644
> > index 0000000..f8649eb
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/clock/emev2-clock.txt
> > @@ -0,0 +1,99 @@
> > +Device tree Clock bindings for Renesas EMMA Mobile EV2
> > +
> > +This binding uses the common clock binding.
> > +
> > +* SMU
> > +System Management Unit described in user's manual R19UH0037EJ1000_SMU.
> > +This is not a clock provider, but clocks under SMU depend on it.
> > +
> > +Required properties:
> > +- compatible: Should be "renesas,emev2-smu"
> > +- reg: Address and Size of SMU registers
> > +
> > +* SMU_CLKDIV
> > +Function block with an input mux and a divider, which corresponds to
> > +"Serial clock generator" in fig."Clock System Overview" of the manual,
> > +and "xxx frequency division setting register" (XXXCLKDIV) registers.
> > +This makes internal (neither input nor output) clock that is provided
> > +to input of xxxGCLK block.
> > +
> > +Required properties:
> > +- compatible: Should be "renesas,emev2-smu-clkdiv"
> > +- reg: Byte offset from SMU base and Bit position in the register
> > +- clocks: Parent clocks. Input clocks as described in clock-bindings.txt
> > +- #clock-cells: Should be <0>
> > +
> > +* SMU_GCLK
> > +Clock gating node shown as "Clock stop processing block" in the
> > +fig."Clock System Overview" of the manual.
> > +Registers are "xxx clock gate control register" (XXXGCLKCTRL).
> > +
> > +Required properties:
> > +- compatible: Should be "renesas,emev2-smu-gclk"
> > +- reg: Byte offset from SMU base and Bit position in the register
> > +- clocks: Input clock as described in clock-bindings.txt
> > +- #clock-cells: Should be <0>
> > +
> > +Example of provider:
> > +
> > +usia_u0_sclkdiv: usia_u0_sclkdiv {
> > +	compatible = "renesas,emev2-smu-clkdiv";
> > +	reg = <0x610 0>;

Is the registers space really 0 bytes long ?

> > +	clocks = <&pll3_fo>, <&pll4_fo>, <&pll1_fo>, <&osc1_fo>;
> > +	#clock-cells = <0>;
> > +};
> > +
> > +usia_u0_sclk: usia_u0_sclk {
> > +	compatible = "renesas,emev2-smu-gclk";
> > +	reg = <0x4a0 1>;
> > +	clocks = <&usia_u0_sclkdiv>;
> > +	#clock-cells = <0>;
> > +};
> > +
> > +Example of consumer:
> > +
> > +uart@e1020000 {
> > +	compatible = "renesas,em-uart";
> > +	reg = <0xe1020000 0x38>;
> > +	interrupts = <0 8 0>;
> > +	clocks = <&usia_u0_sclk>;
> > +	clock-names = "sclk";
> > +};
> > +
> > +Example of clock-tree description:
> > +
> > + This describes a clock path in the clock tree
> > +  c32ki -> pll3_fo -> usia_u0_sclkdiv -> usia_u0_sclk
> > +
> > +smu {
> > +	compatible = "renesas,emev2-smu";
> > +	reg = <0xe0110000 0x10000>;
> > +	#address-cells = <2>;
> > +	#size-cells = <0>;
> > +
> > +	c32ki: c32ki {
> > +		compatible = "fixed-clock";
> > +		clock-frequency = <32768>;
> > +		#clock-cells = <0>;
> > +	};
> > +	pll3_fo: pll3_fo {
> > +		compatible = "fixed-factor-clock";
> > +		clocks = <&c32ki>;
> > +		clock-div = <1>;
> > +		clock-mult = <7000>;
> > +		#clock-cells = <0>;
> > +	};
> > +	usia_u0_sclkdiv: usia_u0_sclkdiv {
> > +		compatible = "renesas,emev2-smu-clkdiv";
> > +		reg = <0x610 0>;
> > +		clocks = <&pll3_fo>;
> > +		#clock-cells = <0>;
> > +	};
> > +	usia_u0_sclk: usia_u0_sclk {
> > +		compatible = "renesas,emev2-smu-gclk";
> > +		reg = <0x4a0 1>;
> > +		clocks = <&usia_u0_sclkdiv>;
> > +		#clock-cells = <0>;
> > +	};
> > +};
> > +

There's an extra blank line at the end of the file.

-- 
Regards,

Laurent Pinchart

