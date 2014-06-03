Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbaFCR6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 13:58:32 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:62268 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbaFCR6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 13:58:30 -0400
Date: Tue, 3 Jun 2014 13:58:27 -0400
From: Tejun Heo <tj@kernel.org>
To: suravee.suthikulpanit@amd.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH 1/1] ata: Check and set 64-bit DMA mask for platform AHCI
 driver
Message-ID: <20140603175827.GH26210@htj.dyndns.org>
References: <1400866510-3130-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400866510-3130-1-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans, Bartlomiej, can you guys please review this patch?

Thanks.

On Fri, May 23, 2014 at 12:35:10PM -0500, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> 
> The current platform AHCI drier does not set the dma_mask correctly
> for 64-bit DMA capable AHCI controller.  This patch checks the AHCI
> capability bit and set the dma_mask and coherent_dma_mask accordingly.
> 
> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> ---
>  drivers/ata/libahci_platform.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/ata/libahci_platform.c b/drivers/ata/libahci_platform.c
> index 7cb3a85..85049ef 100644
> --- a/drivers/ata/libahci_platform.c
> +++ b/drivers/ata/libahci_platform.c
> @@ -368,6 +368,15 @@ int ahci_platform_init_host(struct platform_device *pdev,
>  	ahci_init_controller(host);
>  	ahci_print_info(host, "platform");
>  
> +	if (hpriv->cap & HOST_CAP_64) {
> +		if (!dev->dma_mask)
> +			dev->dma_mask = &dev->coherent_dma_mask;
> +
> +		rc = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
> +		if (rc)
> +			return rc;
> +	}
> +
>  	return ata_host_activate(host, irq, ahci_interrupt, IRQF_SHARED,
>  				 &ahci_platform_sht);
>  }
> -- 
> 1.9.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
tejun
