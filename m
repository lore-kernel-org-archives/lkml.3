Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605AbaBGHnZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 02:43:25 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:41749 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaBGHnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 02:43:22 -0500
Date: Fri, 7 Feb 2014 01:43:20 -0600
From: Andy Gross <agross@codeaurora.org>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] spi: qup: Add device tree bindings information
Message-ID: <20140207074320.GB2610@qualcomm.com>
References: <1391705868-20091-1-git-send-email-iivanov@mm-sol.com>
 <1391705868-20091-2-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391705868-20091-2-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 06:57:47PM +0200, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> 
> The Qualcomm Universal Peripheral (QUP) core is an
> AHB slave that provides a common data path (an output
> FIFO and an input FIFO) for serial peripheral interface
> (SPI) mini-core.
> 
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> ---
>  .../devicetree/bindings/spi/qcom,spi-qup.txt       |   86 ++++++++++++++++++++
>  1 file changed, 86 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/spi/qcom,spi-qup.txt
> 
> diff --git a/Documentation/devicetree/bindings/spi/qcom,spi-qup.txt b/Documentation/devicetree/bindings/spi/qcom,spi-qup.txt
> new file mode 100644
> index 0000000..74565f1
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/spi/qcom,spi-qup.txt
> @@ -0,0 +1,86 @@
> +Qualcomm Universal Peripheral (QUP) Serial Peripheral Interface (SPI)
> +
> +The QUP core is an AHB slave that provides a common data path (an output FIFO
> +and an input FIFO) for serial peripheral interface (SPI) mini-core.
> +
> +SPI in master mode support up to 50MHz, up to four chip selects, and a
> +programmable data path from 4 bits to 32 bits; supports numerous protocol
> +variants.
> +
> +Required properties:
> +- compatible: 		Should contain "qcom,spi-qup-v2".

Could be more descriptive.  qcom,spi-qup-v2.1.1 for MSM8974 v1 and
qcom,spi-qup-v2.2.1 for MSM8974 v2.

> +- reg: 				Should contain base register location and length
> +- interrupts: 		Interrupt number used by this controller
> +
> +- clocks: 			Should contain the core clock and the AHB clock.
> +- clock-names: 		Should be "core" for the core clock and "iface" for the
> +                	AHB clock.
> +
> +- #address-cells: 	Number of cells required to define a chip select
> +					address on the SPI bus. Should be set to 1.
> +- #size-cells: 		Should be zero.
> +
> +Optional properties:
> +- spi-max-frequency: Specifies maximum SPI clock frequency, Units - Hz. Definition
> +                    as per Documentation/devicetree/bindings/spi/spi-bus.txt
> +
> +SPI slave nodes must be children of the SPI master node and can
> +contain properties described in Documentation/devicetree/bindings/spi/spi-bus.txt
> +
> +Example:
> +
> +	spi_8: spi@f9964000 { /* BLSP2 QUP2 */
> +
> +		compatible = "qcom,spi-qup-v2";
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		reg = <0xf9964000 0x1000>;
> +		interrupts = <0 102 0>;
> +		spi-max-frequency = <19200000>;
> +
> +		clocks = <&gcc GCC_BLSP2_QUP2_SPI_APPS_CLK>, <&gcc GCC_BLSP2_AHB_CLK>;
> +		clock-names = "core", "iface";
> +
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&spi8_default>;
> +
> +		device@0 {
> +			compatible = "arm,pl022-dummy";
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			reg = <0>; /* Chip select 0 */
> +			spi-max-frequency = <19200000>;
> +			spi-cpol;
> +		};
> +
> +		device@1 {
> +			compatible = "arm,pl022-dummy";
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			reg = <1>; /* Chip select 1 */
> +			spi-max-frequency = <9600000>;
> +			spi-cpha;
> +		};
> +
> +		device@2 {
> +			compatible = "arm,pl022-dummy";
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			reg = <2>; /* Chip select 2 */
> +			spi-max-frequency = <19200000>;
> +			spi-cpol;
> +			spi-cpha;
> +		};
> +
> +		device@3 {
> +			compatible = "arm,pl022-dummy";
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			reg = <3>; /* Chip select 3 */
> +			spi-max-frequency = <19200000>;
> +			spi-cpol;
> +			spi-cpha;
> +			spi-cs-high;
> +		};
> +	};
> +
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
