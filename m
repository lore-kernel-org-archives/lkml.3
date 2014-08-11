Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbaHKINs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 04:13:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209AbaHKINq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 04:13:46 -0400
Date: Mon, 11 Aug 2014 10:13:15 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>,
        Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>,
        Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Abhijit Mahajan <abhijit.mahajan@avagotech.com>,
        MPT-FusionLinux.pdl@avagotech.com
Cc: linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 RESEND 16/23] mpt3sas: Use pci_enable_msix_exact()
 instead of pci_enable_msix()
Message-ID: <20140811081315.GJ16504@dhcp-27-160.brq.redhat.com>
References: <cover.1405533479.git.agordeev@redhat.com>
 <76ec123596e05dcbcd8957f00ad5f8d4627a32d0.1405533479.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76ec123596e05dcbcd8957f00ad5f8d4627a32d0.1405533479.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 08:05:20PM +0200, Alexander Gordeev wrote:
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range()  or pci_enable_msi_exact()
> and pci_enable_msix_range() or pci_enable_msix_exact()
> interfaces.

Hi Nagalakshmi, Praveen, Sreekanth and Abhijit,

Could you please review mpt2/mpt3 patches in this series?

Thanks!

> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
> Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
> Cc: support@lsi.com
> Cc: DL-MPTFusionLinux@lsi.com
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 0cf4f70..7b65ec2 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -1747,10 +1747,10 @@ _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
>  	for (i = 0, a = entries; i < ioc->reply_queue_count; i++, a++)
>  		a->entry = i;
>  
> -	r = pci_enable_msix(ioc->pdev, entries, ioc->reply_queue_count);
> +	r = pci_enable_msix_exact(ioc->pdev, entries, ioc->reply_queue_count);
>  	if (r) {
>  		dfailprintk(ioc, pr_info(MPT3SAS_FMT
> -			"pci_enable_msix failed (r=%d) !!!\n",
> +			"pci_enable_msix_exact failed (r=%d) !!!\n",
>  			ioc->name, r));
>  		kfree(entries);
>  		goto try_ioapic;
> -- 
> 1.7.7.6
> 
