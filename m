Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbbAAQQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 11:16:15 -0500
Received: from mail.windriver.com ([147.11.1.11]:47710 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbbAAQQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 11:16:14 -0500
Date: Thu, 1 Jan 2015 11:16:15 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
CC: Ralf Baechle <ralf@linux-mips.org>, John Crispin <blogic@openwrt.org>,
        <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: mips: pci: pci-ip27.c:  Remove unused function
Message-ID: <20150101161615.GH23085@windriver.com>
References: <1420126326-27198-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1420126326-27198-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[[PATCH] arch: mips: pci: pci-ip27.c:  Remove unused function] On 01/01/2015 (Thu 16:32) Rickard Strandqvist wrote:

> Remove the function pci_enable_swapping() that is not used anywhere.

A quick search shows it has been orphanware since the git epoch (~2005)
so removing it should be fine AFAICT.

P.
--

> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  arch/mips/pci/pci-ip27.c |   11 -----------
>  1 file changed, 11 deletions(-)
> 
> diff --git a/arch/mips/pci/pci-ip27.c b/arch/mips/pci/pci-ip27.c
> index 0f09eaf..55e3332 100644
> --- a/arch/mips/pci/pci-ip27.c
> +++ b/arch/mips/pci/pci-ip27.c
> @@ -200,17 +200,6 @@ static inline void pci_disable_swapping(struct pci_dev *dev)
>  	bridge->b_widget.w_tflush;	/* Flush */
>  }
>  
> -static inline void pci_enable_swapping(struct pci_dev *dev)
> -{
> -	struct bridge_controller *bc = BRIDGE_CONTROLLER(dev->bus);
> -	bridge_t *bridge = bc->base;
> -	int slot = PCI_SLOT(dev->devfn);
> -
> -	/* Turn on byte swapping */
> -	bridge->b_device[slot].reg |= BRIDGE_DEV_SWAP_DIR;
> -	bridge->b_widget.w_tflush;	/* Flush */
> -}
> -
>  static void pci_fixup_ioc3(struct pci_dev *d)
>  {
>  	pci_disable_swapping(d);
> -- 
> 1.7.10.4
> 
