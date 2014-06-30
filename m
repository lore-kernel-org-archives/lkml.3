Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbaF3JYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 05:24:14 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61919 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751514AbaF3JYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 05:24:12 -0400
Date: Mon, 30 Jun 2014 10:23:22 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
Cc: "mturquette@linaro.org" <mturquette@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>,
        Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>
Subject: Re: [PATCH v2 01/14] clk: st: Update ST clock binding documentation
Message-ID: <20140630092322.GQ7262@leverpostej>
References: <1403875511-7710-1-git-send-email-gabriel.fernandez@linaro.org>
 <1403875511-7710-2-git-send-email-gabriel.fernandez@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403875511-7710-2-git-send-email-gabriel.fernandez@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 02:24:58PM +0100, Gabriel FERNANDEZ wrote:
> This patch adds new compatibilities to support STiH407 SoC.

This doesn't seem to match the patch, which seems to relabel nodes,
rename nodes, change clock-output-names, _and_ adds some new compatible
strings.

Therefore this commit message is completely inappropriate for the patch.
It doesn't match the diff and it doesn't tell me why you are making the
changes below.

NAK until that is fixed.

Mark.

> 
> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
> Acked-by: Peter Griffin <peter.griffin@linaro.org>
> ---
>  .../bindings/clock/st/st,clkgen-divmux.txt         | 28 +++++------
>  .../devicetree/bindings/clock/st/st,clkgen-mux.txt |  6 +--
>  .../devicetree/bindings/clock/st/st,clkgen-pll.txt | 17 ++++---
>  .../bindings/clock/st/st,clkgen-prediv.txt         |  8 ++--
>  .../devicetree/bindings/clock/st/st,clkgen-vcc.txt | 34 ++++++++------
>  .../devicetree/bindings/clock/st/st,clkgen.txt     | 54 +++++++++++++---------
>  .../devicetree/bindings/clock/st/st,quadfs.txt     | 15 +++---
>  7 files changed, 94 insertions(+), 68 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/clock/st/st,clkgen-divmux.txt b/Documentation/devicetree/bindings/clock/st/st,clkgen-divmux.txt
> index ae56315..6247652 100644
> --- a/Documentation/devicetree/bindings/clock/st/st,clkgen-divmux.txt
> +++ b/Documentation/devicetree/bindings/clock/st/st,clkgen-divmux.txt
> @@ -24,26 +24,26 @@ Required properties:
>  
>  Example:
>  
> -	clockgenA@fd345000 {
> +	clockgen-a@fd345000 {
>  		reg = <0xfd345000 0xb50>;
>  
> -		CLK_M_A1_DIV1: CLK_M_A1_DIV1 {
> +		clk_m_a1_div1: clk-m-a1-div1 {
>  			#clock-cells = <1>;
>  			compatible = "st,clkgena-divmux-c32-odf1",
>  				     "st,clkgena-divmux";
>  
> -			clocks = <&CLK_M_A1_OSC_PREDIV>,
> -				 <&CLK_M_A1_PLL0 1>, /* PLL0 PHI1 */
> -				 <&CLK_M_A1_PLL1 1>; /* PLL1 PHI1 */
> -
> -			clock-output-names = "CLK_M_RX_ICN_TS",
> -					     "CLK_M_RX_ICN_VDP_0",
> -					     "", /* Unused */
> -					     "CLK_M_PRV_T1_BUS",
> -					     "CLK_M_ICN_REG_12",
> -					     "CLK_M_ICN_REG_10",
> -					     "", /* Unused */
> -					     "CLK_M_ICN_ST231";
> +			clocks = <&clk_m_a1_osc_prediv>,
> +				 <&clk_m_a1_pll0 1>, /* PLL0 PHI1 */
> +				 <&clk_m_a1_pll1 1>; /* PLL1 PHI1 */
> +
> +			clock-output-names = "clk-m-rx-icn-ts",
> +					     "clk-m-rx-icn-vdp-0",
> +					     "", /* unused */
> +					     "clk-m-prv-t1-bus",
> +					     "clk-m-icn-reg-12",
> +					     "clk-m-icn-reg-10",
> +					     "", /* unused */
> +					     "clk-m-icn-st231";
>  		};
>  	};
>  
> diff --git a/Documentation/devicetree/bindings/clock/st/st,clkgen-mux.txt b/Documentation/devicetree/bindings/clock/st/st,clkgen-mux.txt
> index 943e080..f1fa91c 100644
> --- a/Documentation/devicetree/bindings/clock/st/st,clkgen-mux.txt
> +++ b/Documentation/devicetree/bindings/clock/st/st,clkgen-mux.txt
> @@ -17,7 +17,7 @@ Required properties:
>  	"st,stih416-clkgenf-vcc-sd",	"st,clkgen-mux"
>  	"st,stih415-clkgen-a9-mux",	"st,clkgen-mux"
>  	"st,stih416-clkgen-a9-mux",	"st,clkgen-mux"
> -
> +	"st,stih407-clkgen-a9-mux",	"st,clkgen-mux"
>  
>  - #clock-cells : from common clock binding; shall be set to 0.
>  
> @@ -27,10 +27,10 @@ Required properties:
>  
>  Example:
>  
> -	CLK_M_HVA: CLK_M_HVA {
> +	clk_m_hva: clk-m-hva@fd690868 {
>  		#clock-cells = <0>;
>  		compatible = "st,stih416-clkgenf-vcc-hva", "st,clkgen-mux";
>  		reg = <0xfd690868 4>;
>  
> -		clocks = <&CLOCKGEN_F 1>, <&CLK_M_A1_DIV0 3>;
> +		clocks = <&clockgen_f 1>, <&clk_m_a1_div0 3>;
>  	};
> diff --git a/Documentation/devicetree/bindings/clock/st/st,clkgen-pll.txt b/Documentation/devicetree/bindings/clock/st/st,clkgen-pll.txt
> index 81eb385..efb51cf 100644
> --- a/Documentation/devicetree/bindings/clock/st/st,clkgen-pll.txt
> +++ b/Documentation/devicetree/bindings/clock/st/st,clkgen-pll.txt
> @@ -19,11 +19,14 @@ Required properties:
>  	"st,stih415-plls-c32-ddr",	"st,clkgen-plls-c32"
>  	"st,stih416-plls-c32-a9",	"st,clkgen-plls-c32"
>  	"st,stih416-plls-c32-ddr",	"st,clkgen-plls-c32"
> +	"st,stih407-plls-c32-a0",	"st,clkgen-plls-c32"
> +	"st,stih407-plls-c32-a9",	"st,clkgen-plls-c32"
> +	"st,stih407-plls-c32-c0_0",	"st,clkgen-plls-c32"
> +	"st,stih407-plls-c32-c0_1",	"st,clkgen-plls-c32"
>  
>  	"st,stih415-gpu-pll-c32",	"st,clkgengpu-pll-c32"
>  	"st,stih416-gpu-pll-c32",	"st,clkgengpu-pll-c32"
>  
> -
>  - #clock-cells : From common clock binding; shall be set to 1.
>  
>  - clocks : From common clock binding
> @@ -32,17 +35,17 @@ Required properties:
>  
>  Example:
>  
> -	clockgenA@fee62000 {
> +	clockgen-a@fee62000 {
>  		reg = <0xfee62000 0xb48>;
>  
> -		CLK_S_A0_PLL: CLK_S_A0_PLL {
> +		clk_s_a0_pll: clk-s-a0-pll {
>  			#clock-cells = <1>;
>  			compatible = "st,clkgena-plls-c65";
>  
> -			clocks = <&CLK_SYSIN>;
> +			clocks = <&clk_sysin>;
>  
> -			clock-output-names = "CLK_S_A0_PLL0_HS",
> -					     "CLK_S_A0_PLL0_LS",
> -					     "CLK_S_A0_PLL1";
> +			clock-output-names = "clk-s-a0-pll0-hs",
> +					     "clk-s-a0-pll0-ls",
> +					     "clk-s-a0-pll1";
>  		};
>  	};
> diff --git a/Documentation/devicetree/bindings/clock/st/st,clkgen-prediv.txt b/Documentation/devicetree/bindings/clock/st/st,clkgen-prediv.txt
> index 566c9d7..604766c 100644
> --- a/Documentation/devicetree/bindings/clock/st/st,clkgen-prediv.txt
> +++ b/Documentation/devicetree/bindings/clock/st/st,clkgen-prediv.txt
> @@ -20,17 +20,17 @@ Required properties:
>  
>  Example:
>  
> -	clockgenA@fd345000 {
> +	clockgen-a@fd345000 {
>  		reg = <0xfd345000 0xb50>;
>  
> -		CLK_M_A2_OSC_PREDIV: CLK_M_A2_OSC_PREDIV {
> +		clk_m_a2_osc_prediv: clk-m-a2-osc-prediv {
>  			#clock-cells = <0>;
>  			compatible = "st,clkgena-prediv-c32",
>  				     "st,clkgena-prediv";
>  
> -			clocks = <&CLK_SYSIN>;
> +			clocks = <&clk_sysin>;
>  
> -			clock-output-names = "CLK_M_A2_OSC_PREDIV";
> +			clock-output-names = "clk-m-a2-osc-prediv";
>  		};
>  	};
>  
> diff --git a/Documentation/devicetree/bindings/clock/st/st,clkgen-vcc.txt b/Documentation/devicetree/bindings/clock/st/st,clkgen-vcc.txt
> index 4e3ff28..109b3ed 100644
> --- a/Documentation/devicetree/bindings/clock/st/st,clkgen-vcc.txt
> +++ b/Documentation/devicetree/bindings/clock/st/st,clkgen-vcc.txt
> @@ -32,22 +32,30 @@ Required properties:
>  
>  Example:
>  
> -	CLOCKGEN_C_VCC: CLOCKGEN_C_VCC {
> +	clockgen_c_vcc: clockgen-c-vcc@0xfe8308ac {
>  		#clock-cells = <1>;
>  		compatible = "st,stih416-clkgenc", "st,clkgen-vcc";
>  		reg = <0xfe8308ac 12>;
>  
> -		clocks = <&CLK_S_VCC_HD>, <&CLOCKGEN_C 1>,
> -			<&CLK_S_TMDS_FROMPHY>, <&CLOCKGEN_C 2>;
> -
> -		clock-output-names  =
> -			"CLK_S_PIX_HDMI",  "CLK_S_PIX_DVO",
> -			"CLK_S_OUT_DVO",   "CLK_S_PIX_HD",
> -			"CLK_S_HDDAC",     "CLK_S_DENC",
> -			"CLK_S_SDDAC",     "CLK_S_PIX_MAIN",
> -			"CLK_S_PIX_AUX",   "CLK_S_STFE_FRC_0",
> -			"CLK_S_REF_MCRU",  "CLK_S_SLAVE_MCRU",
> -			"CLK_S_TMDS_HDMI", "CLK_S_HDMI_REJECT_PLL",
> -			"CLK_S_THSENS";
> +		clocks = <&clk_s_vcc_hd>,
> +			 <&clockgen_c 1>,
> +			 <&clk_s_tmds_fromphy>,
> +			 <&clockgen_c 2>;
> +
> +		clock-output-names  = "clk-s-pix-hdmi",
> +				      "clk-s-pix-dvo",
> +				      "clk-s-out-dvo",
> +				      "clk-s-pix-hd",
> +				      "clk-s-hddac",
> +				      "clk-s-denc",
> +				      "clk-s-sddac",
> +				      "clk-s-pix-main",
> +				      "clk-s-pix-aux",
> +				      "clk-s-stfe-frc-0",
> +				      "clk-s-ref-mcru",
> +				      "clk-s-slave-mcru",
> +				      "clk-s-tmds-hdmi",
> +				      "clk-s-hdmi-reject-pll",
> +				      "clk-s-thsens";
>  	};
>  
> diff --git a/Documentation/devicetree/bindings/clock/st/st,clkgen.txt b/Documentation/devicetree/bindings/clock/st/st,clkgen.txt
> index 49ec5ae..427bad8 100644
> --- a/Documentation/devicetree/bindings/clock/st/st,clkgen.txt
> +++ b/Documentation/devicetree/bindings/clock/st/st,clkgen.txt
> @@ -24,60 +24,72 @@ address is common of all subnode.
>  		quadfs_node {
>  			...
>  		};
> +
> +		mux_node {
> +			...
> +		};
> +
> +		vcc_node {
> +			...
> +		};
>  		...
>  	};
>  
>  This binding uses the common clock binding[1].
> -Each subnode should use the binding discribe in [2]..[4]
> +Each subnode should use the binding discribe in [2]..[7]
>  
>  [1] Documentation/devicetree/bindings/clock/clock-bindings.txt
> -[2] Documentation/devicetree/bindings/clock/st,quadfs.txt
> -[3] Documentation/devicetree/bindings/clock/st,quadfs.txt
> -[4] Documentation/devicetree/bindings/clock/st,quadfs.txt
> +[2] Documentation/devicetree/bindings/clock/st,clkgen-divmux.txt
> +[3] Documentation/devicetree/bindings/clock/st,clkgen-mux.txt
> +[4] Documentation/devicetree/bindings/clock/st,clkgen-pll.txt
> +[5] Documentation/devicetree/bindings/clock/st,clkgen-prediv.txt
> +[6] Documentation/devicetree/bindings/clock/st,vcc.txt
> +[7] Documentation/devicetree/bindings/clock/st,quadfs.txt
> +
>  
>  Required properties:
>  - reg : A Base address and length of the register set.
>  
>  Example:
>  
> -	clockgenA@fee62000 {
> +	clockgen-a@fee62000 {
>  
>  		reg = <0xfee62000 0xb48>;
>  
> -		CLK_S_A0_PLL: CLK_S_A0_PLL {
> +		clk_s_a0_pll: clk-s-a0-pll {
>  			#clock-cells = <1>;
>  			compatible = "st,clkgena-plls-c65";
>  
> -			clocks = <&CLK_SYSIN>;
> +			clocks = <&clk-sysin>;
>  
> -			clock-output-names = "CLK_S_A0_PLL0_HS",
> -					     "CLK_S_A0_PLL0_LS",
> -					     "CLK_S_A0_PLL1";
> +			clock-output-names = "clk-s-a0-pll0-hs",
> +					     "clk-s-a0-pll0-ls",
> +					     "clk-s-a0-pll1";
>  		};
>  
> -		CLK_S_A0_OSC_PREDIV: CLK_S_A0_OSC_PREDIV {
> +		clk_s_a0_osc_prediv: clk-s-a0-osc-prediv {
>  			#clock-cells = <0>;
>  			compatible = "st,clkgena-prediv-c65",
>  				     "st,clkgena-prediv";
>  
> -			clocks = <&CLK_SYSIN>;
> +			clocks = <&clk_sysin>;
>  
> -			clock-output-names = "CLK_S_A0_OSC_PREDIV";
> +			clock-output-names = "clk-s-a0-osc-prediv";
>  		};
>  
> -		CLK_S_A0_HS: CLK_S_A0_HS {
> +		clk_s_a0_hs: clk-s-a0-hs {
>  			#clock-cells = <1>;
>  			compatible = "st,clkgena-divmux-c65-hs",
>  				     "st,clkgena-divmux";
>  
> -			clocks = <&CLK_S_A0_OSC_PREDIV>,
> -				 <&CLK_S_A0_PLL 0>, /* PLL0 HS */
> -				 <&CLK_S_A0_PLL 2>; /* PLL1 */
> +			clocks = <&clk-s_a0_osc_prediv>,
> +				 <&clk-s_a0_pll 0>, /* pll0 hs */
> +				 <&clk-s_a0_pll 2>; /* pll1 */
>  
> -			clock-output-names = "CLK_S_FDMA_0",
> -					     "CLK_S_FDMA_1",
> -					     ""; /* CLK_S_JIT_SENSE */
> -					     /* Fourth output unused */
> +			clock-output-names = "clk-s-fdma-0",
> +					     "clk-s-fdma-1",
> +					     ""; /* clk-s-jit-sense */
> +					     /* fourth output unused */
>  		};
>  	};
>  
> diff --git a/Documentation/devicetree/bindings/clock/st/st,quadfs.txt b/Documentation/devicetree/bindings/clock/st/st,quadfs.txt
> index ec86d62..cedeb9c 100644
> --- a/Documentation/devicetree/bindings/clock/st/st,quadfs.txt
> +++ b/Documentation/devicetree/bindings/clock/st/st,quadfs.txt
> @@ -15,6 +15,9 @@ Required properties:
>    "st,stih416-quadfs432",	"st,quadfs"
>    "st,stih416-quadfs660-E",	"st,quadfs"
>    "st,stih416-quadfs660-F",	"st,quadfs"
> +  "st,stih407-quadfs660-C",	"st,quadfs"
> +  "st,stih407-quadfs660-D",	"st,quadfs"
> +
>  
>  - #clock-cells : from common clock binding; shall be set to 1.
>  
> @@ -32,14 +35,14 @@ Required properties:
>  
>  Example:
>  
> -	CLOCKGEN_E: CLOCKGEN_E {
> +	clockgen_e: clockgen-e@fd3208bc {
>                  #clock-cells = <1>;
>                  compatible = "st,stih416-quadfs660-E", "st,quadfs";
>                  reg = <0xfd3208bc 0xB0>;
>  
> -                clocks = <&CLK_SYSIN>;
> -                clock-output-names = "CLK_M_PIX_MDTP_0",
> -                                        "CLK_M_PIX_MDTP_1",
> -                                        "CLK_M_PIX_MDTP_2",
> -                                        "CLK_M_MPELPC";
> +                clocks = <&clk_sysin>;
> +                clock-output-names = "clk-m-pix-mdtp-0",
> +				     "clk-m-pix-mdtp-1",
> +				     "clk-m-pix-mdtp-2",
> +				     "clk-m-mpelpc";
>          };
> -- 
> 1.9.1
> 
> 
