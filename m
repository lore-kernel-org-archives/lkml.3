Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327AbaGZId1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 04:33:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbaGZIdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 04:33:25 -0400
Date: Sat, 26 Jul 2014 09:41:38 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, iscsi-driver@qlogic.com,
        linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 RESEND 22/23] qla4xxx: Use pci_enable_msix_exact()
 instead of pci_enable_msix()
Message-ID: <20140726084137.GL21129@agordeev.usersys.redhat.com>
References: <cover.1405533479.git.agordeev@redhat.com>
 <0496ccbc0f203afaeeb7758c146b93c2f387684c.1405533479.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0496ccbc0f203afaeeb7758c146b93c2f387684c.1405533479.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 08:05:26PM +0200, Alexander Gordeev wrote:
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range()  or pci_enable_msi_exact()
> and pci_enable_msix_range() or pci_enable_msix_exact()
> interfaces.

Hi Vikas,

Could you please reveiw this patch?

Thanks!

> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> Cc: iscsi-driver@qlogic.com
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> Acked-By: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> ---
>  drivers/scsi/qla4xxx/ql4_nx.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
> index 9dbdb4b..7c33658 100644
> --- a/drivers/scsi/qla4xxx/ql4_nx.c
> +++ b/drivers/scsi/qla4xxx/ql4_nx.c
> @@ -4221,7 +4221,7 @@ qla4_8xxx_enable_msix(struct scsi_qla_host *ha)
>  	for (i = 0; i < QLA_MSIX_ENTRIES; i++)
>  		entries[i].entry = qla4_8xxx_msix_entries[i].entry;
>  
> -	ret = pci_enable_msix(ha->pdev, entries, ARRAY_SIZE(entries));
> +	ret = pci_enable_msix_exact(ha->pdev, entries, ARRAY_SIZE(entries));
>  	if (ret) {
>  		ql4_printk(KERN_WARNING, ha,
>  		    "MSI-X: Failed to enable support -- %d/%d\n",
> -- 
> 1.7.7.6
> 

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
