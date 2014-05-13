Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbaEMVqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 17:46:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55562 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbaEMVqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 17:46:36 -0400
Date: Tue, 13 May 2014 14:46:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 RESEND] rapidio/tsi721: Use pci_enable_msix_exact()
 instead of pci_enable_msix()
Message-Id: <20140513144634.c7bc3d20db633f32fea913b6@linux-foundation.org>
In-Reply-To: <1399993292-31692-1-git-send-email-agordeev@redhat.com>
References: <1399993292-31692-1-git-send-email-agordeev@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2014 17:01:32 +0200 Alexander Gordeev <agordeev@redhat.com> wrote:

> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range()  or pci_enable_msi_exact()
> and pci_enable_msix_range() or pci_enable_msix_exact()
> interfaces.
> 

What (if any) runtime effect does this patch have?

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
