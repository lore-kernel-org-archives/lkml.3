Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbaBKU46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:56:58 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:51993 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857AbaBKU4y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 15:56:54 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [Patch v5 2/2] dmaengine: qcom_bam_dma: Add device tree binding
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1391546556-27702-3-git-send-email-agross@codeaurora.org>
Date: Tue, 11 Feb 2014 14:56:48 -0600
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        dmaengine <dmaengine@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <C8E65D93-F685-40C7-A482-C3E85D9F0558@codeaurora.org>
References: <1391546556-27702-1-git-send-email-agross@codeaurora.org> <1391546556-27702-3-git-send-email-agross@codeaurora.org>
To: Andy Gross <agross@codeaurora.org>
X-Mailer: Apple Mail (2.1827)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 4, 2014, at 2:42 PM, Andy Gross <agross@codeaurora.org> wrote:

> Add device tree binding support for the QCOM BAM DMA driver.
> 
> Signed-off-by: Andy Gross <agross@codeaurora.org>
> ---
> .../devicetree/bindings/dma/qcom_bam_dma.txt       |   48 ++++++++++++++++++++
> 1 file changed, 48 insertions(+)
> create mode 100644 Documentation/devicetree/bindings/dma/qcom_bam_dma.txt

Acked-by: Kumar Gala <galak@codeaurora.org>

- k

> 
> diff --git a/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt b/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
> new file mode 100644
> index 0000000..86344f1
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
> @@ -0,0 +1,48 @@
> +QCOM BAM DMA controller
> +
> +Required properties:
> +- compatible:	Must be "qcom,bam-v1.4.0" for MSM8974 V1
> +		Must be "qcom,bam-v1.4.1" for MSM8974 V2
> +- reg: Address range for DMA registers
> +- interrupts: single interrupt for this controller
> +- #dma-cells: must be <1>
> +- clocks: required clock
> +- clock-names: name of clock
> +- qcom,ee : indicates the active Execution Environment identifier (0-7)
> +
> +Example:
> +
> +	uart-bam: dma@f9984000 = {
> +		compatible = "qcom,bam-v1.4.1";
> +		reg = <0xf9984000 0x15000>;
> +		interrupts = <0 94 0>;
> +		clocks = <&gcc GCC_BAM_DMA_AHB_CLK>;
> +		clock-names = "bam_clk";
> +		#dma-cells = <1>;
> +		qcom,ee = <0>;
> +	};
> +
> +Client:
> +Required properties:
> +- dmas: List of dma channel requests
> +- dma-names: Names of aforementioned requested channels
> +
> +Clients must use the format described in the dma.txt file, using a two cell
> +specifier for each channel.
> +
> +The three cells in order are:
> +  1. A phandle pointing to the DMA controller
> +  2. The channel number
> +
> +Example:
> +	serial@f991e000 {
> +		compatible = "qcom,msm-uart";
> +		reg = <0xf991e000 0x1000>
> +			<0xf9944000 0x19000>;
> +		interrupts = <0 108 0>;
> +		clocks = <&gcc GCC_BLSP1_UART2_APPS_CLK>, <&gcc GCC_BLSP1_AHB_CLK>;
> +		clock-names = "core", "iface";
> +
> +		dmas = <&uart-bam 0>, <&uart-bam 1>;
> +		dma-names = "rx", "tx";
> +	};
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

