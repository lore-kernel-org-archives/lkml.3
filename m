Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbaCGNtJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 08:49:09 -0500
Received: from mxout1.idt.com ([157.165.5.25]:52818 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347AbaCGNtG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 08:49:06 -0500
X-Greylist: delayed 736 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Mar 2014 08:49:05 EST
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Alexander Gordeev <agordeev@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Matt Porter <mporter@kernel.crashing.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: RE: [PATCH v2 RESEND 3/4] tsi721: Use pci_enable_msix_exact()
 instead of pci_enable_msix()
Thread-Topic: [PATCH v2 RESEND 3/4] tsi721: Use pci_enable_msix_exact()
 instead of pci_enable_msix()
Thread-Index: AQHPOXgL/LMKFHWtEUW8WKDUlKKtKZrVn43w
Date: Fri, 7 Mar 2014 13:35:34 +0000
Message-ID: <8D983423E7EDF846BB3056827B8CC5D15CC440A6@corpmail1.na.ads.idt.com>
References: <cover.1394128952.git.agordeev@redhat.com>
 <d21563117d14900b2c094847198ff9a99e2e3dfa.1394128952.git.agordeev@redhat.com>
In-Reply-To: <d21563117d14900b2c094847198ff9a99e2e3dfa.1394128952.git.agordeev@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.165.140.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-TM-AS-MML: disable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Alexander Gordeev [mailto:agordeev@redhat.com]
> Sent: Thursday, March 06, 2014 3:11 PM
> To: linux-kernel@vger.kernel.org
> Cc: Alexander Gordeev; Matt Porter; Bounine, Alexandre; linux-
> pci@vger.kernel.org
> Subject: [PATCH v2 RESEND 3/4] tsi721: Use pci_enable_msix_exact()
> instead of pci_enable_msix()
> 
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range()  or pci_enable_msi_exact()
> and pci_enable_msix_range() or pci_enable_msix_exact()
> interfaces.


Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>

Andrew, please pick up this patch for the -next tree.

> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Matt Porter <mporter@kernel.crashing.org>
> Cc: Alexandre Bounine <alexandre.bounine@idt.com>
> Cc: linux-pci@vger.kernel.org
> ---
>  drivers/rapidio/devices/tsi721.c |   11 +++--------
>  1 files changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/rapidio/devices/tsi721.c
> b/drivers/rapidio/devices/tsi721.c
> index ff7cbf2..ce08e8d 100644
> --- a/drivers/rapidio/devices/tsi721.c
> +++ b/drivers/rapidio/devices/tsi721.c
> @@ -768,15 +768,10 @@ static int tsi721_enable_msix(struct
> tsi721_device *priv)
>  	}
>  #endif /* CONFIG_RAPIDIO_DMA_ENGINE */
> 
> -	err = pci_enable_msix(priv->pdev, entries, ARRAY_SIZE(entries));
> +	err = pci_enable_msix_exact(priv->pdev, entries,
> ARRAY_SIZE(entries));
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

