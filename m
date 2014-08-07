Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbaHGVlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 17:41:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbaHGVle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 17:41:34 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/4] umem: fix error return code
References: <1407445067-4044-1-git-send-email-Julia.Lawall@lip6.fr>
	<1407445067-4044-3-git-send-email-Julia.Lawall@lip6.fr>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 07 Aug 2014 17:41:29 -0400
In-Reply-To: <1407445067-4044-3-git-send-email-Julia.Lawall@lip6.fr> (Julia
	Lawall's message of "Thu, 7 Aug 2014 22:57:45 +0200")
Message-ID: <x491tssasfq.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall <Julia.Lawall@lip6.fr> writes:

> diff --git a/drivers/block/umem.c b/drivers/block/umem.c
> index 4cf81b5..371e819 100644
> --- a/drivers/block/umem.c
> +++ b/drivers/block/umem.c
> @@ -881,6 +881,7 @@ static int mm_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
>  	if (card->mm_pages[0].desc == NULL ||
>  	    card->mm_pages[1].desc == NULL) {
>  		dev_printk(KERN_ERR, &card->dev->dev, "alloc failed\n");
> +		ret = -ENOMEM;
>  		goto failed_alloc;
>  	}
>  	reset_page(&card->mm_pages[0]);
> @@ -891,8 +892,10 @@ static int mm_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
>  	card->biotail = &card->bio;
>  
>  	card->queue = blk_alloc_queue(GFP_KERNEL);
> -	if (!card->queue)
> +	if (!card->queue) {
> +		ret = -ENOMEM;
>  		goto failed_alloc;
> +	}

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
