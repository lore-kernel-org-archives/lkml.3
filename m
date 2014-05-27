Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaE0XT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 19:19:56 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:53179 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbaE0XTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 19:19:54 -0400
Date: Tue, 27 May 2014 17:19:50 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 RESEND] rapidio/tsi721: Use pci_enable_msix_exact()
 instead of pci_enable_msix()
Message-ID: <20140527231950.GI11907@google.com>
References: <1399993292-31692-1-git-send-email-agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399993292-31692-1-git-send-email-agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 05:01:32PM +0200, Alexander Gordeev wrote:
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range()  or pci_enable_msi_exact()
> and pci_enable_msix_range() or pci_enable_msix_exact()
> interfaces.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Matt Porter <mporter@kernel.crashing.org>
> Cc: Alexandre Bounine <alexandre.bounine@idt.com>
> Cc: linux-pci@vger.kernel.org

I assume this is being handled by Matt and/or Alexandre (listed in
MAINTAINERS).  Let me know if I should do anything.

> ---
>  drivers/rapidio/devices/tsi721.c |   11 +++--------
>  1 files changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/rapidio/devices/tsi721.c b/drivers/rapidio/devices/tsi721.c
> index 1753dc6..2ca1a0b 100644
> --- a/drivers/rapidio/devices/tsi721.c
> +++ b/drivers/rapidio/devices/tsi721.c
> @@ -768,15 +768,10 @@ static int tsi721_enable_msix(struct tsi721_device *priv)
>  	}
>  #endif /* CONFIG_RAPIDIO_DMA_ENGINE */
>  
> -	err = pci_enable_msix(priv->pdev, entries, ARRAY_SIZE(entries));
> +	err = pci_enable_msix_exact(priv->pdev, entries, ARRAY_SIZE(entries));
>  	if (err) {
> -		if (err > 0)
> -			dev_info(&priv->pdev->dev,
> -				 "Only %d MSI-X vectors available, "
> -				 "not using MSI-X\n", err);
> -		else
> -			dev_err(&priv->pdev->dev,
> -				"Failed to enable MSI-X (err=%d)\n", err);
> +		dev_err(&priv->pdev->dev,
> +			"Failed to enable MSI-X (err=%d)\n", err);
>  		return err;
>  	}
>  
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
