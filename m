Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbaBULBn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 06:01:43 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35484 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753897AbaBULBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 06:01:40 -0500
Date: Fri, 21 Feb 2014 11:01:39 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Wolfram Sang <wsa@the-dreams.de>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: Re: [PATCH v3 1/2] i2c: qup: Add device tree bindings information
Message-ID: <20140221110138.GF7541@e106331-lin.cambridge.arm.com>
References: <1392943090-30556-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1392943090-30556-2-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392943090-30556-2-git-send-email-bjorn.andersson@sonymobile.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 12:38:09AM +0000, Bjorn Andersson wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> 
> The Qualcomm Universal Peripherial (QUP) wraps I2C mini-core and
> provide input and output FIFO's for it. I2C controller can operate
> as master with supported bus speeds of 100Kbps and 400Kbps.
> 
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> [bjorn: reformulated part of binding description
>         added version to compatible
>         cleaned up example]
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> ---
>  .../devicetree/bindings/i2c/qcom,i2c-qup.txt       |   44 ++++++++++++++++++++
>  1 file changed, 44 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/i2c/qcom,i2c-qup.txt
> 
> diff --git a/Documentation/devicetree/bindings/i2c/qcom,i2c-qup.txt b/Documentation/devicetree/bindings/i2c/qcom,i2c-qup.txt
> new file mode 100644
> index 0000000..38d505f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/i2c/qcom,i2c-qup.txt
> @@ -0,0 +1,44 @@
> +Qualcomm Universal Peripheral (QUP) I2C controller
> +
> +Required properties:
> + - compatible: Should be
> +		"qcom,i2c-qup-v1.1.1" for 8660, 8960 and 8064.
> +		"qcom,i2c-qup-v2.1.1" for 8974 v1.
> +		"qcom,i2c-qup-v2.2.1" for 8974 v2 and later.
> + - reg: Should contain QUP register address and length.
> + - interrupts: Should contain I2C interrupt.
> +
> + - clocks: Should contain the core clock and the AHB clock.
> + - clock-names: Should be "core" for the core clock and "iface" for the
> +                AHB clock.

Could you please describe clocks in terms of clock-names? It makes the
relationship clearer, and avoids redundancy (which makes extending the
bindnig easier):

- clocks: A list of phandles + clock-specifiers, one for each entry in
  clock-names.
- clock-names: should contain:
  * "core" for the core clock
  * "iface" for the AHB clock

Cheers,
Mark.

> +
> + - #address-cells: Should be <1> Address cells for i2c device address
> + - #size-cells: Should be <0> as i2c addresses have no size component
> +
> +Optional properties:
> + - clock-frequency: Should specify the desired i2c bus clock frequency in Hz,
> +                    defaults to 100kHz if omitted.
> +
> +Child nodes should conform to i2c bus binding.
> +
> +Example:
> +
> + i2c@f9924000 {
> + 	compatible = "qcom,i2c-qup-v2.2.1";
> + 	reg = <0xf9924000 0x1000>;
> + 	interrupts = <0 96 0>;
> +
> + 	clocks = <&gcc GCC_BLSP1_QUP2_I2C_APPS_CLK>, <&gcc GCC_BLSP1_AHB_CLK>;
> + 	clock-names = "core", "iface";
> +
> + 	clock-frequency = <355000>;
> +
> + 	#address-cells = <1>;
> + 	#size-cells = <0>;
> +
> + 	dummy@60 {
> + 		compatible = "dummy";
> + 		reg = <0x60>;
> + 	};
> + };
> +
> -- 
> 1.7.9.5
> 
> 
