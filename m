Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab3CONhB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:37:01 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:28839 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349Ab3CONg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:36:59 -0400
Date: Fri, 15 Mar 2013 09:35:56 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Ram Pai <linuxram@us.ibm.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 20/27] PCI, xen: Use for_each_pci_resource() with xen
 pci
Message-ID: <20130315133556.GK8582@phenom.dumpdata.com>
References: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
 <1363217302-14383-21-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363217302-14383-21-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 04:28:15PM -0700, Yinghai Lu wrote:
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>


Reviewed-by: Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: virtualization@lists.linux-foundation.org
> ---
>  drivers/pci/xen-pcifront.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
> index 966abc6..c90835f 100644
> --- a/drivers/pci/xen-pcifront.c
> +++ b/drivers/pci/xen-pcifront.c
> @@ -395,9 +395,7 @@ static int pcifront_claim_resource(struct pci_dev *dev, void *data)
>  	int i;
>  	struct resource *r;
>  
> -	for (i = 0; i < PCI_NUM_RESOURCES; i++) {
> -		r = &dev->resource[i];
> -
> +	for_each_pci_resource(dev, r, i, PCI_ALL_RES) {
>  		if (!r->parent && r->start && r->flags) {
>  			dev_info(&pdev->xdev->dev, "claiming resource %s/%d\n",
>  				pci_name(dev), i);
> -- 
> 1.7.10.4
> 
