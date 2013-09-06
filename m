Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab3IFUal (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 16:30:41 -0400
Received: from mail-yh0-f41.google.com ([209.85.213.41]:62869 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab3IFUak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 16:30:40 -0400
Date: Fri, 6 Sep 2013 14:30:35 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Gavin Shan <shangw@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 3/6] powerpc/pci: use pci_is_pcie() to simplify code
Message-ID: <20130906203035.GA27940@google.com>
References: <1378367730-25996-1-git-send-email-wangyijing@huawei.com>
 <1378367730-25996-3-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378367730-25996-3-git-send-email-wangyijing@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 03:55:27PM +0800, Yijing Wang wrote:
> Use pci_is_pcie() to simplify code.
> 
> Acked-by: Kumar Gala <galak@kernel.crashing.org>
> Reviewed-by: Gavin Shan <shangw@linux.vnet.ibm.com>
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> Cc: Gavin Shan <shangw@linux.vnet.ibm.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/powerpc/kernel/eeh.c     |    3 +--
>  arch/powerpc/sysdev/fsl_pci.c |    2 +-
>  2 files changed, 2 insertions(+), 3 deletions(-)

Ben, Paul, this has no dependencies on anything new to PCI or any
other patches in this series, so you can take it through the POWERPC
tree.  If you don't want to do that, let me know and I can take it.

If you want it:

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

> diff --git a/arch/powerpc/kernel/eeh.c b/arch/powerpc/kernel/eeh.c
> index 55593ee..6ebbe54 100644
> --- a/arch/powerpc/kernel/eeh.c
> +++ b/arch/powerpc/kernel/eeh.c
> @@ -189,8 +189,7 @@ static size_t eeh_gather_pci_data(struct eeh_dev *edev, char * buf, size_t len)
>  	}
>  
>  	/* If PCI-E capable, dump PCI-E cap 10, and the AER */
> -	cap = pci_find_capability(dev, PCI_CAP_ID_EXP);
> -	if (cap) {
> +	if (pci_is_pcie(dev)) {
>  		n += scnprintf(buf+n, len-n, "pci-e cap10:\n");
>  		printk(KERN_WARNING
>  		       "EEH: PCI-E capabilities and status follow:\n");
> diff --git a/arch/powerpc/sysdev/fsl_pci.c b/arch/powerpc/sysdev/fsl_pci.c
> index 46ac1dd..5402a1d 100644
> --- a/arch/powerpc/sysdev/fsl_pci.c
> +++ b/arch/powerpc/sysdev/fsl_pci.c
> @@ -41,7 +41,7 @@ static void quirk_fsl_pcie_header(struct pci_dev *dev)
>  	u8 hdr_type;
>  
>  	/* if we aren't a PCIe don't bother */
> -	if (!pci_find_capability(dev, PCI_CAP_ID_EXP))
> +	if (!pci_is_pcie(dev))
>  		return;
>  
>  	/* if we aren't in host mode don't bother */
> -- 
> 1.7.1
> 
> 
