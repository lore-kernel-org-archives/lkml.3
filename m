Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbbAFPT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:19:28 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:41591 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755512AbbAFPT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:19:26 -0500
Message-ID: <54ABFCF3.4000508@mm-sol.com>
Date: Tue, 06 Jan 2015 17:19:15 +0200
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andy Gross <agross@codeaurora.org>
CC: Stanimir Varbanov <svarbanov@mm-sol.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] dmaengine: qcom_bam_dma: add one more optional clock
References: <1410112547-363-1-git-send-email-svarbanov@mm-sol.com>
In-Reply-To: <1410112547-363-1-git-send-email-svarbanov@mm-sol.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

On 09/07/2014 08:55 PM, Stanimir Varbanov wrote:
> The BAM is tightly coupled with the peripheral to which it
> belongs. In that sprit to access the BAM configuration
> registers the driver needs to enable some peripheral
> clocks. Currently the DT node enables bamclk which seems
> is not enough for some peripherals (for example the crypto
> engine wants core and iface clocks). This change attempts
> to solve this issue by adding one more optional clock
> in bam_dma driver.
> 

What is your opinion on this patch?

> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> ---
>  .../devicetree/bindings/dma/qcom_bam_dma.txt       | 12 ++++--
>  drivers/dma/qcom_bam_dma.c                         | 44 +++++++++++++++-------
>  2 files changed, 38 insertions(+), 18 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt b/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
> index d75a9d7..2376897 100644
> --- a/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
> +++ b/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
> @@ -6,8 +6,11 @@ Required properties:
>  - interrupts: Should contain the one interrupt shared by all channels
>  - #dma-cells: must be <1>, the cell in the dmas property of the client device
>    represents the channel number
> -- clocks: required clock
> -- clock-names: must contain "bam_clk" entry
> +- clocks: list of required clock plus one optional clock. The optional clock
> +          is needed for some peripherals and can be omitted.
> +- clock-names: must contain "core" clock name representing the required clock
> +               plus the optional "iface" clock name depending on
> +               peripheral needs.
>  - qcom,ee : indicates the active Execution Environment identifier (0-7) used in
>    the secure world.
>  
> @@ -17,8 +20,9 @@ Example:
>  		compatible = "qcom,bam-v1.4.0";
>  		reg = <0xf9984000 0x15000>;
>  		interrupts = <0 94 0>;
> -		clocks = <&gcc GCC_BAM_DMA_AHB_CLK>;
> -		clock-names = "bam_clk";
> +		clocks = <&gcc GCC_BLSP1_UART2_APPS_CLK>,
> +			 <&gcc GCC_BLSP1_AHB_CLK>;
> +		clock-names = "core", "iface";
>  		#dma-cells = <1>;
>  		qcom,ee = <0>;
>  	};



-- 
regards,
Stan
