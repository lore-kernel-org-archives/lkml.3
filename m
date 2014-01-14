Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316AbaANI6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 03:58:43 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:41327 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbaANI6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 03:58:40 -0500
Message-ID: <1389689841.2794.8.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [PATCH v2 1/2] i2c: qup: Add device tree bindings information
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        Jean Delvare <khali@linux-fr.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        James Ralston <james.d.ralston@intel.com>,
        Bill Brown <bill.e.brown@intel.com>,
        Matt Porter <matt.porter@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Tue, 14 Jan 2014 10:57:21 +0200
In-Reply-To: <1389659437-16406-2-git-send-email-bjorn.andersson@sonymobile.com>
References: <1389659437-16406-1-git-send-email-bjorn.andersson@sonymobile.com>
	 <1389659437-16406-2-git-send-email-bjorn.andersson@sonymobile.com>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks Bjorn, 

I have prepared second version, but never send it out :-).
One thing suggested by Mark was missed in this version.


On Mon, 2014-01-13 at 16:30 -0800, Bjorn Andersson wrote: 
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> 
> The Qualcomm Universal Peripherial (QUP) wraps I2C mini-core and
> provide input and output FIFO's for it. I2C controller can operate
> as master with supported bus speeds of 100Kbps and 400Kbps.
> 
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> [bjorn: reformulated part of binding description and cleaned up example]
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> ---
>  .../devicetree/bindings/i2c/qcom,i2c-qup.txt       | 41 ++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/i2c/qcom,i2c-qup.txt
> 
> diff --git a/Documentation/devicetree/bindings/i2c/qcom,i2c-qup.txt b/Documentation/devicetree/bindings/i2c/qcom,i2c-qup.txt
> new file mode 100644
> index 0000000..a99711b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/i2c/qcom,i2c-qup.txt
> @@ -0,0 +1,41 @@
> +Qualcomm Universal Peripheral (QUP) I2C controller
> +
> +Required properties:
> + - compatible: Should be "qcom,i2c-qup".
> + - reg: Should contain QUP register address and length.
> + - interrupts: Should contain I2C interrupt.
> +
> + - clocks: Should contain the core clock and the AHB clock.

+ - clocks: a list of phandle + clock-specifier pairs for each entry in
+           clock-names

> + - clock-names: Should be "core" for the core clock and "iface" for the
> +                AHB clock.
> +
> + - #address-cells: Should be <1> Address cells for i2c device address
> + - #size-cells: Should be <0> as i2c addresses have no size component
> +
> +Optional properties:
> + - clock-frequency: Should specify the desired i2c bus clock frequency in Hz,
> +                    default is 100kHz if omitted.
> +
> +Child nodes should conform to i2c bus binding.
> +
> +Example:
> +
> + i2c2: i2c@f9924000 {
> + 	compatible = "qcom,i2c-qup";
> + 	reg = <0xf9924000 0x1000>;
> + 	interrupts = <0 96 0>;
> +
> + 	clocks = <&gcc_blsp1_qup2_i2c_apps_clk>, <&gcc_blsp1_ahb_clk>;

In the light of the latest patches from Stephen, this could be 

+ 	clocks = <&gcc GCC_BLSP1_QUP2_I2C_APPS_CLK>, <&gcc GCC_BLSP1_AHB_CLK>;


Regards,
Ivan


