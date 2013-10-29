Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583Ab3J2GSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 02:18:39 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58511 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab3J2GSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 02:18:37 -0400
Date: Mon, 28 Oct 2013 23:18:35 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Andy Gross <agross@codeaurora.org>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>
Subject: Re: [PATCH 2/2] dmaengine: msm_bam_dma: Add device tree binding
Message-ID: <20131029061835.GE21983@codeaurora.org>
References: <1382732643-8184-1-git-send-email-agross@codeaurora.org>
 <1382732643-8184-3-git-send-email-agross@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382732643-8184-3-git-send-email-agross@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25, Andy Gross wrote:
> diff --git a/Documentation/devicetree/bindings/dma/msm_bam_dma.txt b/Documentation/devicetree/bindings/dma/msm_bam_dma.txt
> new file mode 100644
> index 0000000..fe3ed8f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/dma/msm_bam_dma.txt
> @@ -0,0 +1,49 @@
> +MSM BAM DMA controller
> +
> +Required properties:
> +- compatible: Should be "qcom,bam"
> +- reg: Address range for DMA registers
> +- interrupts: single interrupt for this controller
> +- #dma-cells: must be <3>
> +- clocks: required clock
> +- clock-names: name of clock
> +
> +Example:
> +
> +	dma0: dma@f9984000 = {

I imagine it's fine to say 'bam0: dma@f9984000' here. The node
name should stay dma though. This way we know that we're talking
about the first bam. Or if there is a more specific name for the
bam we could use that, like system-bam or sdhci-bam.

> +		compatible = "qcom,bam";
> +		reg = <0xf9984000 0x15000>;
> +		interrupts = <0 94 0>;
> +		clocks = <&bam_dma_ahb_cxc>;
> +		clock-names = "bam_clk";
> +		#dma-cells = <3>;
> +	};
> +
> +Client:
> +Required properties:
> +- dmas: List of dma channel requests
> +- dma-names: Names of aforementioned requested channels
> +
> +Clients must use the format described in the dma.txt file, using a four cell
> +specifier for each channel.
> +
> +The four cells in order are:
> +  1. A phandle pointing to the DMA controller
> +  2. The channel number
> +  3. The execution environment value for this channel.
> +  4. Direction of the fixed unidirectional channel
> +     0 - Memory to Device
> +     1 - Device to Memory

Should we add "2 - Device to Device" here? Is there anything more
that needs to be done in the binding for device to device
transfers.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
