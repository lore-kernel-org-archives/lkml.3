Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751156AbaLEQyE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 11:54:04 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59823 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750748AbaLEQyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 11:54:01 -0500
Date: Fri, 5 Dec 2014 16:53:56 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [RFC 1/3] devfreq: dt-bindings: Document Exynos3250 devfreq
 driver
Message-ID: <20141205165356.GC12849@leverpostej>
References: <1417797988-29225-1-git-send-email-k.kozlowski@samsung.com>
 <1417797988-29225-2-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417797988-29225-2-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 04:46:26PM +0000, Krzysztof Kozlowski wrote:
> Add documentation for bindings used by Exynos3250 devfreq driver.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  .../bindings/arm/samsung/exynos3250-devfreq.txt    | 66 ++++++++++++++++++++++
>  1 file changed, 66 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/samsung/exynos3250-devfreq.txt
> 
> diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos3250-devfreq.txt b/Documentation/devicetree/bindings/arm/samsung/exynos3250-devfreq.txt
> new file mode 100644
> index 000000000000..047955e9e371
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/samsung/exynos3250-devfreq.txt
> @@ -0,0 +1,66 @@
> +Samsung Exynos3250 devfreq driver

The binding should describe the hardware, not a particular driver of
that hardware. Please write the binding (and its documentation) with
that in mind, and drop references to the driver and "busfreq".

With an adequate binding we can probe the device and forward the
information to relevant driver(s) as necessary.

> +=================================
> +
> +The driver support changing frequencies and voltage for:
> + - memory controller and bus,
> + - peripheral buses (left and right).


What do left and right mean in this context?

> +
> +Memory controller and bus
> +=========================
> +Required properties:
> + - compatible : should be "samsung,exynos3250-busfreq-mif"
> + - reg : two sets (offset and length of the register) for PPMU registers
> +	used by this devfreq driver
> + - clock-names : one clock of name "dmc" to manage frequency
> + - clocks : phandle and specifier for clock listed in clock-names property
> + - vdd_mif-supply : phandle to MIF voltage regulator

s/_/-/ in property names please.

> +
> +Peripheral buses
> +================
> +Required properties:
> + - compatible : should be "samsung,exynos3250-busfreq-int"

What does "int" mean here?

> + - reg : two sets (offset and length of the register) for PPMU registers
> +	used by this devfreq driver
> + - clock-names : names for PPMU clocks and bus clocks to manage frequencies;
> +	All following clock names (and corresponding phandles) must be
> +	provided:
> +	- "ppmu_left", "ppmu_right",
> +	- "aclk_400", "aclk_266", "aclk_200", "aclk_160", "aclk_gdl", "aclk_gdr", "mfc";
> + - clocks : phandles and specifiers for clocks listed in clock-names property
> + - vdd_mif-supply : phandle to INT voltage regulator

s/_/-/ here too.

Thanks,
Mark.

> +
> +Example
> +=======
> +	busfreq_mif: busfreq@106A0000 {
> +		compatible = "samsung,exynos3250-busfreq-mif";
> +		reg = <0x106A0000 0x2000>, <0x106B0000 0x2000>;
> +		clocks = <&cmu_dmc CLK_DIV_DMC>;
> +		clock-names = "dmc";
> +		vdd_mif-supply = <&buck1_reg>;
> +		status = "okay";
> +	};
> +
> +	busfreq_int: busfreq@116A0000 {
> +		compatible = "samsung,exynos3250-busfreq-int";
> +		reg = <0x116A0000 0x2000>, <0x112A0000 0x2000>;
> +		clocks = <&cmu CLK_PPMULEFT>,
> +			<&cmu CLK_PPMURIGHT>,
> +			<&cmu CLK_DIV_ACLK_400_MCUISP>,
> +			<&cmu CLK_DIV_ACLK_266>,
> +			<&cmu CLK_DIV_ACLK_200>,
> +			<&cmu CLK_DIV_ACLK_160>,
> +			<&cmu CLK_DIV_GDL>,
> +			<&cmu CLK_DIV_GDR>,
> +			<&cmu CLK_DIV_MFC>;
> +		clock-names = "ppmuleft",
> +			"ppmuright",
> +			"aclk_400",
> +			"aclk_266",
> +			"aclk_200",
> +			"aclk_160",
> +			"aclk_gdl",
> +			"aclk_gdr",
> +			"mfc";
> +		vdd_int-supply = <&buck3_reg>;
> +		status = "okay";
> +	};
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
