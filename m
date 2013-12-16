Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab3LPHNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 02:13:22 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:59734 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab3LPHNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 02:13:20 -0500
Date: Mon, 16 Dec 2013 15:13:05 +0800
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>,
        Scott Wood <scottwood@freescale.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 6/9] powerpc/pci: Use dev_is_pci() to check whether it is
 pci device
Message-ID: <20131216071305.GA16842@weiyang.vnet.ibm.com>
Reply-To: Wei Yang <weiyang@linux.vnet.ibm.com>
References: <1386244880-22300-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386244880-22300-1-git-send-email-wangyijing@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121607-8878-0000-0000-00000A1550B6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yijing,

This one looks good.

While I take a look at the source code, there are around 20 places with
similar style. Do you think it would be good to change all these places
in one patch?

On Thu, Dec 05, 2013 at 08:01:20PM +0800, Yijing Wang wrote:
>Use PCI standard marco dev_is_pci() instead of directly compare
>pci_bus_type to check whether it is pci device.
>
>Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>---
> arch/powerpc/sysdev/fsl_pci.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
>diff --git a/arch/powerpc/sysdev/fsl_pci.c b/arch/powerpc/sysdev/fsl_pci.c
>index 4dfd61d..7066e52 100644
>--- a/arch/powerpc/sysdev/fsl_pci.c
>+++ b/arch/powerpc/sysdev/fsl_pci.c
>@@ -122,7 +122,7 @@ static int fsl_pci_dma_set_mask(struct device *dev, u64 dma_mask)
> 	 * address width of the SoC such that we can address any internal
> 	 * SoC address from across PCI if needed
> 	 */
>-	if ((dev->bus == &pci_bus_type) &&
>+	if ((dev_is_pci(dev)) &&
> 	    dma_mask >= DMA_BIT_MASK(MAX_PHYS_ADDR_BITS)) {
> 		set_dma_ops(dev, &dma_direct_ops);
> 		set_dma_offset(dev, pci64_dma_offset);
>-- 
>1.7.1
>
>
>_______________________________________________
>Linuxppc-dev mailing list
>Linuxppc-dev@lists.ozlabs.org
>https://lists.ozlabs.org/listinfo/linuxppc-dev

-- 
Richard Yang
Help you, Help me

