Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbaHMQGA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 12:06:00 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:24118 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaHMQF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 12:05:59 -0400
Date: Wed, 13 Aug 2014 11:04:54 -0500
From: scameron@beardog.cce.hp.com
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, iss_storagedev@hp.com,
        linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org,
        scameron@beardog.cce.hp.com
Subject: Re: [PATCH v2 RESEND 08/23] hpsa: Fallback to MSI rather than to INTx if MSI-X failed
Message-ID: <20140813160454.GA19666@beardog.cce.hp.com>
References: <cover.1405533479.git.agordeev@redhat.com> <3ca64c251518a2db8810534b4e63ec696bcfeefd.1405533479.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ca64c251518a2db8810534b4e63ec696bcfeefd.1405533479.git.agordeev@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 08:05:12PM +0200, Alexander Gordeev wrote:
> Currently the driver falls back to INTx mode when MSI-X
> initialization failed. This is a suboptimal behaviour
> for chips that also support MSI. This update changes that
> behaviour and falls back to MSI mode in case MSI-X mode
> initialization failed.
> 
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

Ack.

Sorry for the slow reply, this got lost in the tornadic maelstrom
I call my inbox.

I also tested this with a Smart Array P420, P420i, and P430 in
the system by ifdef'ing out the code for MSI-X and setting
h->msix_vector = 0, to force it down the MSI path, and that all
appears to work. 

-- steve

