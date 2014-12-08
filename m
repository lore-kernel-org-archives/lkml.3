Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbaLHH3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 02:29:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901AbaLHH3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 02:29:21 -0500
Date: Mon, 8 Dec 2014 09:29:00 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH] uio/uio_pci_generic: don't return zero on failure path
 in probe()
Message-ID: <20141208072900.GE18208@redhat.com>
References: <1417814881-4684-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417814881-4684-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 06, 2014 at 12:28:01AM +0300, Alexey Khoroshilov wrote:
> If uio_register_device() fails in probe(), it breaks off initialization,
> deallocates all resources, but returns zero.
> 
> The patch adds proper error code propagation.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/uio/uio_pci_generic.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/uio/uio_pci_generic.c b/drivers/uio/uio_pci_generic.c
> index 077ae12269ce..d0b508b68f3c 100644
> --- a/drivers/uio/uio_pci_generic.c
> +++ b/drivers/uio/uio_pci_generic.c
> @@ -91,7 +91,8 @@ static int probe(struct pci_dev *pdev,
>  	gdev->info.handler = irqhandler;
>  	gdev->pdev = pdev;
>  
> -	if (uio_register_device(&pdev->dev, &gdev->info))
> +	err = uio_register_device(&pdev->dev, &gdev->info);
> +	if (err)
>  		goto err_register;
>  	pci_set_drvdata(pdev, gdev);
>  
> -- 
> 1.9.1
