Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbaHRMgb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 08:36:31 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:34665 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbaHRMg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 08:36:29 -0400
Message-ID: <53F14DC2.70000@gmail.com>
Date: Sun, 17 Aug 2014 19:50:10 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: tthayer@opensource.altera.com, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        linux@arm.linux.org.uk, atull@altera.com, delicious.quinoa@gmail.com,
        dinguyen@altera.com, dougthompson@xmission.com,
        grant.likely@linaro.org, bp@alien8.de, sameo@linux.intel.com,
        lee.jones@linaro.org
CC: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tthayer.linux@gmail.com
Subject: Re: [PATCHv9 3/3] arm: dts: Add Altera SDRAM controller bindings
References: <1406744573-609-1-git-send-email-tthayer@opensource.altera.com> <1406744573-609-4-git-send-email-tthayer@opensource.altera.com>
In-Reply-To: <1406744573-609-4-git-send-email-tthayer@opensource.altera.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2014 01:22 PM, tthayer@opensource.altera.com wrote:
> From: Thor Thayer <tthayer@opensource.altera.com>
> 
> Add the Altera SDRAM controller bindings and device tree changes to the Altera SoC project.
> 
> Signed-off-by: Thor Thayer <tthayer@opensource.altera.com>
> ---
> v2: Changes to SoC SDRAM EDAC code.
> 
> v3: Implement code suggestions for SDRAM EDAC code.
> 
> v4: Remove syscon from SDRAM controller bindings.
> 
> v5: No Change, bump version for consistency.
> 
> v6: Only map the ctrlcfg register as syscon.
> 
> v7: No change. Bump for consistency.
> 
> v8: No change. Bump for consistency.
> 
> v9: Changes to support a MFD SDRAM controller with nested EDAC.
> ---
>  .../devicetree/bindings/arm/altera/socfpga-sdr.txt |   13 +++++++++++++
>  arch/arm/boot/dts/socfpga.dtsi                     |   10 ++++++++++
>  2 files changed, 23 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-sdr.txt
> 
> diff --git a/Documentation/devicetree/bindings/arm/altera/socfpga-sdr.txt b/Documentation/devicetree/bindings/arm/altera/socfpga-sdr.txt
> new file mode 100644
> index 0000000..2bb1ddf
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/altera/socfpga-sdr.txt
> @@ -0,0 +1,13 @@
> +Altera SOCFPGA SDRAM Controller
> +The SDRAM controller is implemented as a MFD so various drivers may
> +nest under this main SDRAM controller binding.
> +
> +Required properties:
> +- compatible : "altr,sdr";
> +- reg : Should contain 1 register range(address and length)
> +
> +Example:
> +	sdr@0xffc25000 {
> +		compatible = "altr,sdr";
> +		reg = <0xffc25000 0x1000>;
> +	};
> diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
> index 4676f25..ecb306d 100644
> --- a/arch/arm/boot/dts/socfpga.dtsi
> +++ b/arch/arm/boot/dts/socfpga.dtsi
> @@ -603,6 +603,16 @@
>  			};
>  		};
>  
> +		sdr@0xffc25000 {
> +			compatible = "altr,sdr";
> +			reg = <0xffc25000 0x1000>;
> +
> +			sdramedac@0 {
> +				compatible = "altr,sdram-edac";
> +				interrupts = <0 39 4>;
> +			};

This doesn't match the documentation, but I don't think this is a move
in the right direction anyway. Because Linux has/wants an MFD driver is
not a reason to add a sub node. It is a single h/w block and DT should
reflect that.

Rob

