Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbaBUJe0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 04:34:26 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:32991 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754498AbaBUJeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 04:34:23 -0500
Date: Fri, 21 Feb 2014 09:33:52 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Andy Gross <agross@codeaurora.org>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Patch v6 2/2] dmaengine: add Qualcomm BAM dma driver
Message-ID: <20140221093352.GE7541@e106331-lin.cambridge.arm.com>
References: <1392964986-5207-1-git-send-email-agross@codeaurora.org>
 <1392964986-5207-3-git-send-email-agross@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392964986-5207-3-git-send-email-agross@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 06:43:05AM +0000, Andy Gross wrote:
> Add the DMA engine driver for the QCOM Bus Access Manager (BAM) DMA controller
> found in the MSM 8x74 platforms.
> 
> Each BAM DMA device is associated with a specific on-chip peripheral.  Each
> channel provides a uni-directional data transfer engine that is capable of
> transferring data between the peripheral and system memory (System mode), or
> between two peripherals (BAM2BAM).
> 
> The initial release of this driver only supports slave transfers between
> peripherals and system memory.
> 
> Signed-off-by: Andy Gross <agross@codeaurora.org>
> ---
>  drivers/dma/Kconfig        |    9 +
>  drivers/dma/Makefile       |    1 +
>  drivers/dma/qcom_bam_dma.c | 1107 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 1117 insertions(+)
>  create mode 100644 drivers/dma/qcom_bam_dma.c

[...]

> +       bdev->bamclk = devm_clk_get(bdev->dev, "bam_clk");

The binding document should describe the "bam_clk" string in the
clock-names description.

[...]

> +       ret = of_property_read_u32(pdev->dev.of_node, "qcom,ee", &bdev->ee);
> +       if (ret) {
> +               dev_err(bdev->dev, "EE unspecified\n");

It would be nice to expand EE to what it stands for, at least in the
error but possibly the binding too.

> +static const struct of_device_id bam_of_match[] = {
> +       { .compatible = "qcom,bam-v1.4.0", },
> +       { .compatible = "qcom,bam-v1.4.1", },

What are the differences between the two?

Is v1.4.1 an extension of v1.4.0?

Could you have the following in DTs:

  compatible = "qcom,bam-v1.4.1", "qcom,bam-v1.4.0";

Then you'd only need the v1.4.0 string in the driver for now.

Thanks,
Mark.
