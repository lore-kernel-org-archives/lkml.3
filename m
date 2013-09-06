Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751118Ab3IFGz6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 02:55:58 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:45389 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750801Ab3IFGz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 02:55:57 -0400
Date: Thu, 5 Sep 2013 23:55:56 -0700
From: Dmitry Torokhov <dtor@vmware.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: acking@vmware.com, gregkh@linuxfoundation.org, georgezhang@vmware.com,
        asarwade@vmware.com, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VMCI: fix to pass correct device identity to free_irq()
Message-ID: <20130906065556.GA21772@dtor-ws.eng.vmware.com>
References: <CAPgLHd8FyR_bdD75ETukz491+yDtOV7c4o2hmPbU0Y2L_3dm1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd8FyR_bdD75ETukz491+yDtOV7c4o2hmPbU0Y2L_3dm1g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 02:39:28PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> free_irq() expects the same device identity that was passed to
> corresponding request_irq(), otherwise the IRQ is not freed.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Dmitry Torokhov <dtor@vmware.com>

> ---
>  drivers/misc/vmw_vmci/vmci_guest.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/misc/vmw_vmci/vmci_guest.c b/drivers/misc/vmw_vmci/vmci_guest.c
> index b3a2b76..c98b03b 100644
> --- a/drivers/misc/vmw_vmci/vmci_guest.c
> +++ b/drivers/misc/vmw_vmci/vmci_guest.c
> @@ -649,7 +649,7 @@ static int vmci_guest_probe_device(struct pci_dev *pdev,
>  	return 0;
>  
>  err_free_irq:
> -	free_irq(vmci_dev->irq, &vmci_dev);
> +	free_irq(vmci_dev->irq, vmci_dev);
>  	tasklet_kill(&vmci_dev->datagram_tasklet);
>  	tasklet_kill(&vmci_dev->bm_tasklet);
>  
