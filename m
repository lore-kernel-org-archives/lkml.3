Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbaAFLBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 06:01:55 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:42295 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbaAFLBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 06:01:52 -0500
Date: Mon, 6 Jan 2014 11:01:45 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Samuel Ortiz <sameo@linux.intel.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mfd: sta2x11-mfd: use named constants for
 pci_power_t values
Message-ID: <20140106110145.GM23772@lee--X1>
References: <1388706031-22180-1-git-send-email-Julia.Lawall@lip6.fr>
 <1388706031-22180-2-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1388706031-22180-2-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 Jan 2014, Julia Lawall wrote:

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression pdev;
> @@
> 
> pci_set_power_state(pdev,
> - 0
> + PCI_D0
>  )
> // </smpl>

I'm happy with the code and that you used Coccinelle to discover the
issue, but I feel a little more explanation would be helpful to
readers.

Why is (pci_power_t __force) 0 better than 0?

> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
>  drivers/mfd/sta2x11-mfd.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/sta2x11-mfd.c b/drivers/mfd/sta2x11-mfd.c
> index 0d42e40..5b72db0 100644
> --- a/drivers/mfd/sta2x11-mfd.c
> +++ b/drivers/mfd/sta2x11-mfd.c
> @@ -529,7 +529,7 @@ static int sta2x11_mfd_resume(struct pci_dev *pdev)
>  {
>  	int err;
>  
> -	pci_set_power_state(pdev, 0);
> +	pci_set_power_state(pdev, PCI_D0);
>  	err = pci_enable_device(pdev);
>  	if (err)
>  		return err;
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
