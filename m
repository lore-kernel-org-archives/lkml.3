Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751102AbaGZIG4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 04:06:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbaGZIGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 04:06:50 -0400
Date: Sat, 26 Jul 2014 09:15:02 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Hiral Patel <hiralpat@cisco.com>, Suma Ramars <sramars@cisco.com>,
        Brian Uchino <buchino@cisco.com>, linux-scsi@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 RESEND 07/23] fnic: Use pci_enable_msix_exact()
 instead of pci_enable_msix()
Message-ID: <20140726081502.GD21129@agordeev.usersys.redhat.com>
References: <cover.1405533479.git.agordeev@redhat.com>
 <e8cc7988e4b0a38f59d3e854d387c7c0d95b058c.1405533479.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8cc7988e4b0a38f59d3e854d387c7c0d95b058c.1405533479.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 08:05:11PM +0200, Alexander Gordeev wrote:
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range()  or pci_enable_msi_exact()
> and pci_enable_msix_range() or pci_enable_msix_exact()
> interfaces.

Hi Hiral, Suma, Brian,

Could you please review this patch?

Thanks!

> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Hiral Patel <hiralpat@cisco.com>
> Cc: Suma Ramars <sramars@cisco.com>
> Cc: Brian Uchino <buchino@cisco.com>
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> ---
>  drivers/scsi/fnic/fnic_isr.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/fnic/fnic_isr.c b/drivers/scsi/fnic/fnic_isr.c
> index 7d9b54a..a0dd1b6 100644
> --- a/drivers/scsi/fnic/fnic_isr.c
> +++ b/drivers/scsi/fnic/fnic_isr.c
> @@ -257,8 +257,8 @@ int fnic_set_intr_mode(struct fnic *fnic)
>  	    fnic->raw_wq_count >= m &&
>  	    fnic->wq_copy_count >= o &&
>  	    fnic->cq_count >= n + m + o) {
> -		if (!pci_enable_msix(fnic->pdev, fnic->msix_entry,
> -				    n + m + o + 1)) {
> +		if (!pci_enable_msix_exact(fnic->pdev, fnic->msix_entry,
> +					   n + m + o + 1)) {
>  			fnic->rq_count = n;
>  			fnic->raw_wq_count = m;
>  			fnic->wq_copy_count = o;
> -- 
> 1.7.7.6
> 

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
