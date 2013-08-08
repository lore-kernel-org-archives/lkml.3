Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005Ab3HHQmi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 12:42:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:60726 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab3HHQmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 12:42:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,840,1367996400"; 
   d="scan'208";a="378160173"
Date: Thu, 8 Aug 2013 09:42:36 -0700
From: Jon Mason <jon.mason@intel.com>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Hanjun Guo <guohanjun@huawei.com>, jiang.liu@huawei.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/16] ntb: clean up unnecessary MSI/MSI-X capability find
Message-ID: <20130808164235.GB21762@jonmason-lab>
References: <1375967374-28704-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375967374-28704-1-git-send-email-wangyijing@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 08, 2013 at 09:09:34PM +0800, Yijing Wang wrote:
> PCI core will initialize device MSI/MSI-X capability in
> pci_msi_init_pci_dev(). So device driver should use
> pci_dev->msi_cap/msix_cap to determine whether the device
> support MSI/MSI-X instead of using
> pci_find_capability(pci_dev, PCI_CAP_ID_MSI/MSIX).
> Access to PCIe device config space again will consume more time.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> Cc: Jon Mason <jon.mason@intel.com>

Acked-by: Jon Mason <jon.mason@intel.com>

> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/ntb/ntb_hw.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
> index 2dacd19..090d1b2 100644
> --- a/drivers/ntb/ntb_hw.c
> +++ b/drivers/ntb/ntb_hw.c
> @@ -758,16 +758,15 @@ static int ntb_setup_msix(struct ntb_device *ndev)
>  	struct pci_dev *pdev = ndev->pdev;
>  	struct msix_entry *msix;
>  	int msix_entries;
> -	int rc, i, pos;
> +	int rc, i;
>  	u16 val;
>  
> -	pos = pci_find_capability(pdev, PCI_CAP_ID_MSIX);
> -	if (!pos) {
> +	if (!pdev->msix_cap) {
>  		rc = -EIO;
>  		goto err;
>  	}
>  
> -	rc = pci_read_config_word(pdev, pos + PCI_MSIX_FLAGS, &val);
> +	rc = pci_read_config_word(pdev, pdev->msix_cap + PCI_MSIX_FLAGS, &val);
>  	if (rc)
>  		goto err;
>  
> -- 
> 1.7.1
> 
> 
