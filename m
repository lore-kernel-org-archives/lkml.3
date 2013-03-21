Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673Ab3CUF2D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 01:28:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:27120 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753088Ab3CUF2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 01:28:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,883,1355126400"; 
   d="scan'208";a="305446362"
Date: Thu, 21 Mar 2013 10:33:01 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: "Jiang, Dave" <dave.jiang@intel.com>
Cc: "djbw@fb.com" <djbw@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Mason, Jon" <jon.mason@intel.com>
Subject: Re: [PATCH v2] ioat: remove chanerr mask setting for IOAT v3.x
Message-ID: <20130321050301.GB10326@intel.com>
References: <20121127221608.11315.49374.stgit@djiang5-linux.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121127221608.11315.49374.stgit@djiang5-linux.ch.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 03:46:08AM +0530, Jiang, Dave wrote:
> The existing code set a value in the PCI_CHANERRMSK_INT register
> for a workaround to address a pre-silicon bug on the Intel 5520 IO hub that
> has been fixed when the hardware was released. There is no need for this
> code.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
> 
>  drivers/dma/ioat/dma_v3.c |    7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
> index f7f1dc6..fda3b8a1 100644
> --- a/drivers/dma/ioat/dma_v3.c
> +++ b/drivers/dma/ioat/dma_v3.c
> @@ -1126,12 +1126,7 @@ static int ioat3_reset_hw(struct ioat_chan_common *chan)
>  	chanerr = readl(chan->reg_base + IOAT_CHANERR_OFFSET);
>  	writel(chanerr, chan->reg_base + IOAT_CHANERR_OFFSET);
>  
> -	/* -= IOAT ver.3 workarounds =- */
> -	/* Write CHANERRMSK_INT with 3E07h to mask out the errors
> -	 * that can cause stability issues for IOAT ver.3, and clear any
> -	 * pending errors
> -	 */
What is this code based against? i dont have above lines in -rc1 or my next?

> -	pci_write_config_dword(pdev, IOAT_PCI_CHANERRMASK_INT_OFFSET, 0x3e07);
> +	/* clear any pending errors */
>  	err = pci_read_config_dword(pdev, IOAT_PCI_CHANERR_INT_OFFSET, &chanerr);
>  	if (err) {
>  		dev_err(&pdev->dev, "channel error register unreachable\n");
> 
