Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab3JDHlP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 03:41:15 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:51369 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab3JDHlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 03:41:11 -0400
Date: Fri, 4 Oct 2013 09:40:53 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>, Andy King <acking@vmware.com>,
        Jon Mason <jon.mason@intel.com>,
        Matt Porter <mporter@kernel.crashing.org>, stable@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-mips@linux-mips.org,
        linuxppc-dev@lists.ozlabs.org, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, x86@kernel.org, linux-ide@vger.kernel.org,
        iss_storagedev@hp.com, linux-nvme@lists.infradead.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        e1000-devel@lists.sourceforge.net, linux-driver@qlogic.com,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        "VMware, Inc." <pv-drivers@vmware.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH RFC 04/77] PCI/MSI/s390: Remove superfluous check of MSI
 type
Message-ID: <20131004094053.5e846a29@mschwide>
In-Reply-To: <bae65aa3e30dfd23bd5ed47add7310cfbb96243a.1380703262.git.agordeev@redhat.com>
References: <cover.1380703262.git.agordeev@redhat.com>
	<bae65aa3e30dfd23bd5ed47add7310cfbb96243a.1380703262.git.agordeev@redhat.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100407-2966-0000-0000-000008F19534
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  2 Oct 2013 12:48:20 +0200
Alexander Gordeev <agordeev@redhat.com> wrote:

> arch_setup_msi_irqs() hook can only be called from the generic
> MSI code which ensures correct MSI type parameter.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  arch/s390/pci/pci.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
> index c79c6e4..61a3c2c 100644
> --- a/arch/s390/pci/pci.c
> +++ b/arch/s390/pci/pci.c
> @@ -425,8 +425,6 @@ int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
>  	int rc;
> 
>  	pr_debug("%s: requesting %d MSI-X interrupts...", __func__, nvec);
> -	if (type != PCI_CAP_ID_MSIX && type != PCI_CAP_ID_MSI)
> -		return -EINVAL;
>  	if (type == PCI_CAP_ID_MSI && nvec > 1)
>  		return 1;
>  	msi_vecs = min(nvec, ZPCI_MSI_VEC_MAX);

Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

