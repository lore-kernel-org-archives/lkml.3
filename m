Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246AbaHGNPN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 09:15:13 -0400
Received: from hedwig.cmf.nrl.navy.mil ([134.207.12.162]:57610 "EHLO
	hedwig.cmf.nrl.navy.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757268AbaHGNOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 09:14:54 -0400
Date: Thu, 7 Aug 2014 09:14:09 -0400
From: chas williams - CONTRACTOR <chas@cmf.nrl.navy.mil>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] solos-pci: fix error return code
Message-ID: <20140807091409.522c7b6a@thirdoffive.cmf.nrl.navy.mil>
In-Reply-To: <1407415749-19978-4-git-send-email-Julia.Lawall@lip6.fr>
References: <1407415749-19978-1-git-send-email-Julia.Lawall@lip6.fr>
	<1407415749-19978-4-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-NRLCMF-Spam-Score: () hits=-0.001
X-NRLCMF-Virus-Scanned: No virus found
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  7 Aug 2014 14:49:07 +0200
Julia Lawall <Julia.Lawall@lip6.fr> wrote:

...
>  drivers/atm/solos-pci.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/atm/solos-pci.c b/drivers/atm/solos-pci.c
> index 943cf0d..7652e8d 100644
> --- a/drivers/atm/solos-pci.c
> +++ b/drivers/atm/solos-pci.c
> @@ -1278,6 +1278,7 @@ static int fpga_probe(struct pci_dev *dev, const struct pci_device_id *id)
>  			card->dma_bounce = kmalloc(card->nr_ports * BUF_SIZE, GFP_KERNEL);
>  			if (!card->dma_bounce) {
>  				dev_warn(&card->dev->dev, "Failed to allocate DMA bounce buffers\n");
> +				err = -ENOMEM;
>  				/* Fallback to MMIO doesn't work */
>  				goto out_unmap_both;
>  			}
> 

Acked-by: Chas Williams <chas@cmf.nrl.navy.mil>
