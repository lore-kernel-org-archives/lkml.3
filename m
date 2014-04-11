Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbaDKDOH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 23:14:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbaDKDOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 23:14:04 -0400
Date: Fri, 11 Apr 2014 11:11:31 +0800
From: Baoquan He <bhe@redhat.com>
To: scameron@beardog.cce.hp.com
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        Jiang Liu <jiang.liu@linux.intel.com>
Subject: Re: [PATCH] hpsa: fix uninitialized trans_support in
 hpsa_put_ctlr_into_performant_mode()
Message-ID: <20140411031131.GN11839@dhcp-16-105.nay.redhat.com>
References: <20140410221704.GA22465@beardog.cce.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140410221704.GA22465@beardog.cce.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch works for me.

Tested-by: Baoquan He <bhe@redhat.com>

Thanks
Baoquan

On 04/10/14 at 05:17pm, scameron@beardog.cce.hp.com wrote:
> 
> Without this, you'll see a null pointer dereference in
> hpsa_enter_performant_mode().
> 
> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> ---
>  drivers/scsi/hpsa.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 8cf4a0c..ef4dfdd 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -7463,6 +7463,10 @@ static void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
>  	if (hpsa_simple_mode)
>  		return;
>  
> +	trans_support = readl(&(h->cfgtable->TransportSupport));
> +	if (!(trans_support & PERFORMANT_MODE))
> +		return;
> +
>  	/* Check for I/O accelerator mode support */
>  	if (trans_support & CFGTBL_Trans_io_accel1) {
>  		transMethod |= CFGTBL_Trans_io_accel1 |
> -- 
> 1.7.1
> 
