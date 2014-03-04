Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbaCDANG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 19:13:06 -0500
Received: from mga01.intel.com ([192.55.52.88]:7791 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755356AbaCDAMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 19:12:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,581,1389772800"; 
   d="scan'208";a="491767482"
Date: Mon, 3 Mar 2014 17:12:12 -0700
From: Jon Mason <jon.mason@intel.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 2/4] ntb: Use pci_msix_vec_count() to obtain number of
 MSI-Xs
Message-ID: <20140304001211.GC9679@jonmason-lab>
References: <cover.1392996332.git.agordeev@redhat.com>
 <342d032b652517e2084ba97962ed017a25bf10bd.1392996332.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <342d032b652517e2084ba97962ed017a25bf10bd.1392996332.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 04:49:30PM +0100, Alexander Gordeev wrote:
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Jon Mason <jon.mason@intel.com>

Looks good.  Pulling into my tree.

Thanks,
Jon

> Cc: linux-pci@vger.kernel.org
> ---
>  drivers/ntb/ntb_hw.c |   15 ++++-----------
>  drivers/ntb/ntb_hw.h |    2 --
>  2 files changed, 4 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
> index 487169dd..53468f4 100644
> --- a/drivers/ntb/ntb_hw.c
> +++ b/drivers/ntb/ntb_hw.c
> @@ -1085,19 +1085,12 @@ static int ntb_setup_msix(struct ntb_device *ndev)
>  	struct msix_entry *msix;
>  	int msix_entries;
>  	int rc, i;
> -	u16 val;
>  
> -	if (!pdev->msix_cap) {
> -		rc = -EIO;
> -		goto err;
> -	}
> -
> -	rc = pci_read_config_word(pdev, pdev->msix_cap + PCI_MSIX_FLAGS, &val);
> -	if (rc)
> +	msix_entries = pci_msix_vec_count(pdev);
> +	if (msix_entries < 0) {
> +		rc = msix_entries;
>  		goto err;
> -
> -	msix_entries = msix_table_size(val);
> -	if (msix_entries > ndev->limits.msix_cnt) {
> +	} else if (msix_entries > ndev->limits.msix_cnt) {
>  		rc = -EINVAL;
>  		goto err;
>  	}
> diff --git a/drivers/ntb/ntb_hw.h b/drivers/ntb/ntb_hw.h
> index bbdb7ed..d307107 100644
> --- a/drivers/ntb/ntb_hw.h
> +++ b/drivers/ntb/ntb_hw.h
> @@ -60,8 +60,6 @@
>  #define PCI_DEVICE_ID_INTEL_NTB_SS_HSX		0x2F0F
>  #define PCI_DEVICE_ID_INTEL_NTB_B2B_BWD		0x0C4E
>  
> -#define msix_table_size(control)	((control & PCI_MSIX_FLAGS_QSIZE)+1)
> -
>  #ifndef readq
>  static inline u64 readq(void __iomem *addr)
>  {
> -- 
> 1.7.7.6
> 
