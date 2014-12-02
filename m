Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbaLBO6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:58:01 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41565 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753902AbaLBO5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:57:55 -0500
Date: Tue, 2 Dec 2014 14:57:35 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: "tthayer@opensource.altera.com" <tthayer@opensource.altera.com>
Cc: "bp@alien8.de" <bp@alien8.de>,
        "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "dinguyen@opensource.altera.com" <dinguyen@opensource.altera.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "tthayer.linux@gmail.com" <tthayer.linux@gmail.com>
Subject: Re: [PATCHv5 5/5] arm: dts: Add Altera L2 Cache and OCRAM EDAC
Message-ID: <20141202145735.GL23671@leverpostej>
References: <1415751263-1830-1-git-send-email-tthayer@opensource.altera.com>
 <1415751263-1830-6-git-send-email-tthayer@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415751263-1830-6-git-send-email-tthayer@opensource.altera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 12:14:23AM +0000, tthayer@opensource.altera.com wrote:
> From: Thor Thayer <tthayer@opensource.altera.com>
> 
> Adding the device tree entries and bindings needed to support
> the Altera L2 cache and On-Chip RAM EDAC. This patch relies upon
> an earlier patch to declare and setup On-chip RAM properly.
> http://www.spinics.net/lists/devicetree/msg51117.html
> 
> Signed-off-by: Thor Thayer <tthayer@opensource.altera.com>
> ---
> v2: Remove OCRAM declaration and reference prior patch.
> 
> v3-5: No Change
> ---
>  .../bindings/arm/altera/socfpga-l2-edac.txt        |   15 +++++++++++++++
>  .../bindings/arm/altera/socfpga-ocram-edac.txt     |   16 ++++++++++++++++
>  arch/arm/boot/dts/socfpga.dtsi                     |   15 ++++++++++++++-
>  3 files changed, 45 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-l2-edac.txt
>  create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-ocram-edac.txt
> 
> diff --git a/Documentation/devicetree/bindings/arm/altera/socfpga-l2-edac.txt b/Documentation/devicetree/bindings/arm/altera/socfpga-l2-edac.txt
> new file mode 100644
> index 0000000..35b19e3
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/altera/socfpga-l2-edac.txt
> @@ -0,0 +1,15 @@
> +Altera SoCFPGA L2 cache Error Detection and Correction [EDAC]
> +
> +Required Properties:
> +- compatible : Should be "altr,l2-edac"
> +- reg : Address and size for ECC error interrupt clear registers.
> +- interrupts : Should be single bit error interrupt, then double bit error
> +	interrupt. Note the rising edge type.
> +
> +Example:
> +
> +	l2edac@ffd08140 {
> +		compatible = "altr,l2-edac";
> +		reg = <0xffd08140 0x4>;
> +		interrupts = <0 36 1>, <0 37 1>;
> +	};

Judging by the size of the reg entry, this is part of a larger block
(the same one the OCRAM EDAC lives in). Why isn't that larger block
described?

EDAC is a Linux subsystem name, but typically not the HW block name.
What HW block does this live in?

> diff --git a/Documentation/devicetree/bindings/arm/altera/socfpga-ocram-edac.txt b/Documentation/devicetree/bindings/arm/altera/socfpga-ocram-edac.txt
> new file mode 100644
> index 0000000..31ab205
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/altera/socfpga-ocram-edac.txt
> @@ -0,0 +1,16 @@
> +Altera SoCFPGA On-Chip RAM Error Detection and Correction [EDAC]
> +
> +OCRAM ECC Required Properties:
> +- compatible : Should be "altr,ocram-edac"
> +- reg : Address and size for ECC error interrupt clear registers.
> +- iram : phandle to On-Chip RAM definition.
> +- interrupts : Should be single bit error interrupt, then double bit error
> +	interrupt. Note the rising edge type.
> +
> +Example:
> +	ocramedac@ffd08144 {
> +		compatible = "altr,ocram-edac";
> +		reg = <0xffd08144 0x4>;
> +		iram = <&ocram>;
> +		interrupts = <0 178 1>, <0 179 1>;
> +	};
> diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
> index 6af96ed..32c63a3 100644
> --- a/arch/arm/boot/dts/socfpga.dtsi
> +++ b/arch/arm/boot/dts/socfpga.dtsi
> @@ -618,8 +618,21 @@
>  			interrupts = <0 39 4>;
>  		};
>  
> +		l2edac@ffd08140 {
> +			compatible = "altr,l2-edac";
> +			reg = <0xffd08140 0x4>;
> +			interrupts = <0 36 1>, <0 37 1>;
> +		};
> +
> +		ocramedac@ffd08144 {
> +			compatible = "altr,ocram-edac";
> +			reg = <0xffd08144 0x4>;
> +			iram = <&ocram>;
> +			interrupts = <0 178 1>, <0 179 1>;
> +		};
> +
>  		L2: l2-cache@fffef000 {
> -			compatible = "arm,pl310-cache";
> +			compatible = "arm,pl310-cache", "syscon";

NAK. 

Why are you marking the PL310 as a syscon device? It is most definitely
_NOT_ a shared set of registers lumped together.

Thanks,
Mark.
