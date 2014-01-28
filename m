Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071AbaA1JGC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 04:06:02 -0500
Received: from smtp-out-182.synserver.de ([212.40.185.182]:1206 "EHLO
	smtp-out-175.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755046AbaA1JFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 04:05:49 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 9122
Message-ID: <52E772DF.6000604@metafoo.de>
Date: Tue, 28 Jan 2014 10:05:35 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Andy Gross <agross@codeaurora.org>
CC: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        dmaengine@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [Patch v3 2/2] dmaengine: qcom_bam_dma: Add device tree binding
References: <1390890471-14882-1-git-send-email-agross@codeaurora.org> <1390890471-14882-3-git-send-email-agross@codeaurora.org>
In-Reply-To: <1390890471-14882-3-git-send-email-agross@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2014 07:27 AM, Andy Gross wrote:
> Add device tree binding support for the QCOM BAM DMA driver.
> 
> Signed-off-by: Andy Gross <agross@codeaurora.org>
> ---
>  .../devicetree/bindings/dma/qcom_bam_dma.txt       |   52 ++++++++++++++++++++
>  1 file changed, 52 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
> 
> diff --git a/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt b/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
> new file mode 100644
> index 0000000..53fd10a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
> @@ -0,0 +1,52 @@
> +QCOM BAM DMA controller
> +
> +Required properties:
> +- compatible:	Must be "qcom,bam-v1.4.0" for MSM8974 V1
> +		Must be "qcom,bam-v1.4.1" for MSM8974 V2
> +- reg: Address range for DMA registers
> +- interrupts: single interrupt for this controller
> +- #dma-cells: must be <2>
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
> +		#dma-cells = <2>;
> +		qcom,ee = <0>;
> +	};
> +
> +Client:
> +Required properties:
> +- dmas: List of dma channel requests
> +- dma-names: Names of aforementioned requested channels
> +
> +Clients must use the format described in the dma.txt file, using a three cell
> +specifier for each channel.
> +
> +The three cells in order are:
> +  1. A phandle pointing to the DMA controller
> +  2. The channel number
> +  3. Direction of the fixed unidirectional channel
> +     0 - Memory to Device
> +     1 - Device to Memory
> +     2 - Device to Device
> +

Why does the direction needs to be specified in specifier? I see two
options, either the direction per is fixed in hardware. In that case the DMA
controller node should describe which channel is which direction. Or the
direction is not fixed in hardware and can be changed at runtime in which
case it should be set on a per descriptor basis.

- Lars
