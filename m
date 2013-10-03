Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab3JCAtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 20:49:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:4547 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089Ab3JCAtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 20:49:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1022,1371106800"; 
   d="scan'208";a="413257834"
Date: Wed, 2 Oct 2013 17:49:28 -0700
From: Jon Mason <jon.mason@intel.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>, Andy King <acking@vmware.com>,
        Matt Porter <mporter@kernel.crashing.org>, stable@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-mips@linux-mips.org,
        linuxppc-dev@lists.ozlabs.org, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, x86@kernel.org, linux-ide@vger.kernel.org,
        iss_storagedev@hp.com, linux-nvme@lists.infradead.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        e1000-devel@lists.sourceforge.net, linux-driver@qlogic.com,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        "VMware, Inc." <pv-drivers@vmware.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH RFC 53/77] ntb: Fix missed call to pci_enable_msix()
Message-ID: <20131003004928.GM6768@jonmason-lab>
References: <cover.1380703262.git.agordeev@redhat.com>
 <0590d63c3432229a3824bada71e07a08fb955498.1380703263.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0590d63c3432229a3824bada71e07a08fb955498.1380703263.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 12:49:09PM +0200, Alexander Gordeev wrote:
> Current MSI-X enablement code assumes MSI-Xs were successfully
> allocated in case less than requested vectors were available.
> That assumption is wrong, since MSI-Xs should be enabled with
> a repeated call to pci_enable_msix(). This update fixes this.

Good catch, I'll pull it in for my next NTB release.

Thanks,
Jon

> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  drivers/ntb/ntb_hw.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
> index 1cb6e51..de2062c 100644
> --- a/drivers/ntb/ntb_hw.c
> +++ b/drivers/ntb/ntb_hw.c
> @@ -1075,6 +1075,10 @@ static int ntb_setup_msix(struct ntb_device *ndev)
>  			 "Only %d MSI-X vectors.  Limiting the number of queues to that number.\n",
>  			 rc);
>  		msix_entries = rc;
> +
> +		rc = pci_enable_msix(pdev, ndev->msix_entries, msix_entries);
> +		if (rc)
> +			goto err1;
>  	}
>  
>  	for (i = 0; i < msix_entries; i++) {
> -- 
> 1.7.7.6
> 
