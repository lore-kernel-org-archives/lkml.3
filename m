Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbaDONDd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:03:33 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:38650 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbaDONDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:03:30 -0400
Date: Tue, 15 Apr 2014 09:03:19 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen/pci: Remove unused dev_err() string
Message-ID: <20140415130319.GC29540@phenom.dumpdata.com>
References: <20140414222523.15032.99127.stgit@bhelgaas-glaptop.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140414222523.15032.99127.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 04:25:23PM -0600, Bjorn Helgaas wrote:
> We previously verified that "action" is either BUS_NOTIFY_ADD_DEVICE or
> BUS_NOTIFY_DEL_DEVICE, so there's no need for the default "?" case.
> 
> Found by Coverity (CID 146520).

Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

David, are you OK pushing this in 'devel/for-linus-3.14'?

Thanks!
> 
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> ---
>  drivers/xen/pci.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/xen/pci.c b/drivers/xen/pci.c
> index dd9c249ea311..59a25f937bd7 100644
> --- a/drivers/xen/pci.c
> +++ b/drivers/xen/pci.c
> @@ -177,8 +177,7 @@ static int xen_pci_notifier(struct notifier_block *nb,
>  	}
>  	if (r)
>  		dev_err(dev, "Failed to %s - passthrough or MSI/MSI-X might fail!\n",
> -			action == BUS_NOTIFY_ADD_DEVICE ? "add" :
> -			(action == BUS_NOTIFY_DEL_DEVICE ? "delete" : "?"));
> +			action == BUS_NOTIFY_ADD_DEVICE ? "add" : "del");
>  	return NOTIFY_OK;
>  }
>  
> 
