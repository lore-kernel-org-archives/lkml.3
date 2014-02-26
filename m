Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbaBZQwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 11:52:00 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:46608 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290AbaBZQv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 11:51:58 -0500
Message-ID: <530E1BAB.6040609@mm-sol.com>
Date: Wed, 26 Feb 2014 18:51:55 +0200
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andy Gross <agross@codeaurora.org>
CC: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [Patch v7 2/2] dmaengine: add Qualcomm BAM dma driver
References: <1393283500-18599-1-git-send-email-agross@codeaurora.org> <1393283500-18599-3-git-send-email-agross@codeaurora.org>
In-Reply-To: <1393283500-18599-3-git-send-email-agross@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

Thanks for the patch.

On 02/25/2014 01:11 AM, Andy Gross wrote:
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
>  drivers/dma/qcom_bam_dma.c | 1106 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 1116 insertions(+)
>  create mode 100644 drivers/dma/qcom_bam_dma.c

<snip>

> +
> +/**
> + * bam_init
> + * @bdev: bam device
> + *
> + * Initialization helper for global bam registers
> + */
> +static int bam_init(struct bam_device *bdev)
> +{
> +	u32 val;
> +
> +	/* read revision and configuration information */
> +	val = readl_relaxed(bdev->regs + BAM_REVISION) & NUM_EES_MASK;
> +

The ees shit is not zero and you got wrong ee. Could you add the line
below or something similar:

val = (val >> NUM_EES_SHIFT) & NUM_EES_MASK;

> +	/* check that configured EE is within range */
> +	if (bdev->ee >= val)
> +		return -EINVAL;
> +

regards,
Stan

