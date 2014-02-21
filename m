Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbaBUXec (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 18:34:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:26012 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350AbaBUXea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 18:34:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,521,1389772800"; 
   d="scan'208";a="459720457"
Date: Fri, 21 Feb 2014 16:33:25 -0700
From: Jon Mason <jon.mason@intel.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 1/4] ntb: Fix leakage of ntb_device::msix_entries[]
 array
Message-ID: <20140221233325.GB3112@jonmason-lab>
References: <cover.1392996332.git.agordeev@redhat.com>
 <7f4150adb1b01e79555af6a9e13f1c0e0df6fdac.1392996332.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f4150adb1b01e79555af6a9e13f1c0e0df6fdac.1392996332.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 04:49:29PM +0100, Alexander Gordeev wrote:
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Jon Mason <jon.mason@intel.com>
> Cc: linux-pci@vger.kernel.org

Good catch.  Applied.

> ---
>  drivers/ntb/ntb_hw.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
> index 170e8e6..487169dd 100644
> --- a/drivers/ntb/ntb_hw.c
> +++ b/drivers/ntb/ntb_hw.c
> @@ -1281,6 +1281,7 @@ static void ntb_free_interrupts(struct ntb_device *ndev)
>  				free_irq(msix->vector, &ndev->db_cb[i]);
>  		}
>  		pci_disable_msix(pdev);
> +		kfree(ndev->msix_entries);
>  	} else {
>  		free_irq(pdev->irq, ndev);
>  
> -- 
> 1.7.7.6
> 
