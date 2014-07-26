Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751182AbaGZIJt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 04:09:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961AbaGZIJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 04:09:45 -0400
Date: Sat, 26 Jul 2014 09:16:48 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, iss_storagedev@hp.com,
        linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 RESEND 08/23] hpsa: Fallback to MSI rather than to
 INTx if MSI-X failed
Message-ID: <20140726081647.GE21129@agordeev.usersys.redhat.com>
References: <cover.1405533479.git.agordeev@redhat.com>
 <3ca64c251518a2db8810534b4e63ec696bcfeefd.1405533479.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ca64c251518a2db8810534b4e63ec696bcfeefd.1405533479.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 08:05:12PM +0200, Alexander Gordeev wrote:
> Currently the driver falls back to INTx mode when MSI-X
> initialization failed. This is a suboptimal behaviour
> for chips that also support MSI. This update changes that
> behaviour and falls back to MSI mode in case MSI-X mode
> initialization failed.

Hi Stephen,

Could you please reveiew hpsa patches in this series?

Thanks!

> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
> Cc: iss_storagedev@hp.com
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> ---
>  drivers/scsi/hpsa.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 31184b3..648dec2 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -6177,7 +6177,6 @@ static void hpsa_interrupt_mode(struct ctlr_info *h)
>  			dev_warn(&h->pdev->dev, "MSI-X init failed %d\n",
>  			       err);
>  			h->msix_vector = 0;
> -			goto default_int_mode;
>  		}
>  	}
>  	if (pci_find_capability(h->pdev, PCI_CAP_ID_MSI)) {
> -- 
> 1.7.7.6
> 

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
