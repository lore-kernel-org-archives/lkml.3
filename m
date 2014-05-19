Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584AbaESVKD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 17:10:03 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55339 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751243AbaESVKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 17:10:00 -0400
Date: Mon, 19 May 2014 23:05:45 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Mike Turquette <mturquette@linaro.org>,
        Jisheng Zhang <jszhang@marvell.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/10] dt-binding: ARM: add clock binding docs for
 Marvell Berlin2 SoCs
Message-ID: <20140519210545.GP29318@piout.net>
References: <1400517811-24668-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1400517811-24668-2-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400517811-24668-2-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/05/2014 at 18:43:22 +0200, Sebastian Hesselbarth wrote :
> This adds mandatory device tree binding documentation for the clock related
> IP found on Marvell Berlin2 (BG2, BG2CD, and BG2Q) SoCs to the Berlin SoC
> binding documentation.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
> Changelog:
> v1->v2:
> - typo fixed (Reported by Alexandre Belloni)
> - reworked binding to not represent individual clocks but chip control
>   IP/registers instead (Suggested by Mike Turquette)
> - dropped clock indices, refer to the include instead (Requested by Mike
>   Turquette)
> - moved the documentation from bindings/clock to Marvell Berlin SoC
>   binding, as there will be more functions (e.g. pinctrl) to describe
> 
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> Cc: Kumar Gala <galak@codeaurora.org>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Mike Turquette <mturquette@linaro.org>
> Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> Cc: Jisheng Zhang <jszhang@marvell.com>
> Cc: devicetree@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  .../devicetree/bindings/arm/marvell,berlin.txt     | 47 ++++++++++++++++++++++
>  1 file changed, 47 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/arm/marvell,berlin.txt b/Documentation/devicetree/bindings/arm/marvell,berlin.txt
> index 0677003e1476..744a7ea569d4 100644
> --- a/Documentation/devicetree/bindings/arm/marvell,berlin.txt
> +++ b/Documentation/devicetree/bindings/arm/marvell,berlin.txt
> @@ -23,3 +23,50 @@ SoC and board used. Currently known SoC compatibles are:
>  
>  	...
>  }
> +
> +* Marvell Berlin2 chip control binding
> +
> +Marvell Berlin SoCs have a chip control register set providing several
> +individual registers dealing with pinmux, padmux, clock, reset, and secondary
> +CPU boot address. Unfortunately, the individual registers are spread among the
> +chip control registers, so there should be a single DT node only providing the
> +different functions which are described below.
> +
> +Required properties:
> +- compatible: shall be one of
> +	"marvell,berlin2-chip-ctrl" for BG2
> +	"marvell,berlin2cd-chip-ctrl" for BG2CD
> +	"marvell,berlin2q-chip-ctrl" for BG2Q
> +- reg: address and length of following register sets for
> +  BG2/BG2CD: chip control register set
> +  BG2Q: chip control register set and cpu pll registers
> +
> +* Clock provider binding
> +
> +As clock related registers are spread among the chip control registers, the
> +chip control node also provides the clocks. Marvell Berlin2 (BG2, BG2CD, BG2Q)
> +SoCs share the same IP for PLLs and clocks, with some minor differences in
> +features and register layout.
> +
> +Required properties:
> +- #clock-cells: shall be set to 1
> +- clocks: clock specifiers referencing the core clock input clocks
> +- clock-names: array of strings describing the input clock specifiers above.
> +    Allowed clock-names for the reference clocks are
> +      "refclk" for the SoCs osciallator input on all SoCs,
> +    and SoC-specific input clocks for
> +      BG2/BG2CD: "video_ext0" for the external video clock input
> +
> +Clocks provided by core clocks shall be referenced by a clock specifier
> +indexing one of the provided clocks. Refer to dt-bindings/clock/berlin<soc>.h
> +for the corresponding index mapping.
> +
> +Example:
> +
> +chip: chip-control@ea0000 {
> +	compatible = "marvell,berlin2-chip-ctrl";
> +	#clock-cells = <1>;
> +	reg = <0xea0000 0x400>;
> +	clocks = <&refclk>, <&externaldev 0>;
> +	clock-names = "refclk", "video_ext0";
> +};
> -- 
> 1.9.1
> 

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
