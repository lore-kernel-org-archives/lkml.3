Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751223AbaBHCm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 21:42:58 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:51310 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaBHCmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 21:42:55 -0500
Date: Fri, 7 Feb 2014 18:42:54 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Andy Gross <agross@codeaurora.org>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        dmaengine@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [Patch v5 1/2] dmaengine: add Qualcomm BAM dma driver
Message-ID: <20140208024254.GA10784@codeaurora.org>
References: <1391546556-27702-1-git-send-email-agross@codeaurora.org>
 <1391546556-27702-2-git-send-email-agross@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391546556-27702-2-git-send-email-agross@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04, Andy Gross wrote:
> diff --git a/drivers/dma/qcom_bam_dma.c b/drivers/dma/qcom_bam_dma.c
> new file mode 100644
> index 0000000..214250c
> --- /dev/null
> +++ b/drivers/dma/qcom_bam_dma.c
> @@ -0,0 +1,1066 @@
> +/*
> + * QCOM BAM DMA engine driver

Can you please move this down into the comment below?

> + *
> + * Copyright (c) 2013-2014, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *

And split this out into its own comment block? I think this will
make the lawyers happier.

> + *
> + * QCOM BAM DMA blocks are distributed amongst a number of the on-chip
> + * peripherals on the MSM 8x74.  The configuration of the channels are dependent
> + * on the way they are hard wired to that specific peripheral.  The peripheral
> + * device tree entries specify the configuration of each channel.
> + *
> + * The DMA controller requires the use of external memory for storage of the
> + * hardware descriptors for each channel.  The descriptor FIFO is accessed as a
> + * circular buffer and operations are managed according to the offset within the
> + * FIFO.  After pipe/channel reset, all of the pipe registers and internal state
> + * are back to defaults.
> + *
> + * During DMA operations, we write descriptors to the FIFO, being careful to
> + * handle wrapping and then write the last FIFO offset to that channel's
> + * P_EVNT_REG register to kick off the transaction.  The P_SW_OFSTS register
> + * indicates the current FIFO offset that is being processed, so there is some
> + * indication of where the hardware is currently working.
> + */
[...]
> +
> +/* PIPE CTRL */
> +#define	P_EN			BIT(1)

           ^^^^
Nitpick: Weird tab here?

> +
> +/**
> + * bam_start_dma - start next transaction
> + * @bchan - bam dma channel
> + *
> + * Note: must hold bam dma channel vc.lock

You can use lockdep_assert_held() here to document this
requirement and test for it at runtime.

> + */
> +static void bam_start_dma(struct bam_chan *bchan)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
