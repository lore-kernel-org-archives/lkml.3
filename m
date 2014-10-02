Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbaJBPA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 11:00:29 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:46016 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791AbaJBPA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 11:00:26 -0400
Date: Thu, 2 Oct 2014 09:00:21 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Marti Raudsepp <marti@juffo.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joel Schopp <joel.schopp@amd.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH] PCI: Add ACS support for AMD A88X southbridge devices
Message-ID: <20141002150021.GA18056@google.com>
References: <1412255137-28954-1-git-send-email-marti@juffo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412255137-28954-1-git-send-email-marti@juffo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 04:05:37PM +0300, Marti Raudsepp wrote:
> AMD has confirmed that peer-to-peer between two southbridge functions
> does not occur.
> 
> Joel Schopp at https://bugzilla.kernel.org/show_bug.cgi?id=81841#c15
> >     +-14.4-[01]----05.0  Dialogic Corporation PRI
> > The legacy PCI should be isolated from the other devices identified.
> > Not sure what is going on here.
> >
> >     +-14.5  Advanced Micro Devices, Inc. [AMD] FCH USB OHCI Controller
> > This OHCI Controller should also be isolated from the other devices.
> 
> Signed-off-by: Marti Raudsepp <marti@juffo.org>

Applied with Joel's ack to pci/virtualization for v3.18, thanks!

> ---
>  drivers/pci/quirks.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 80c2d01..ce43316 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -3582,6 +3582,11 @@ struct pci_dev *pci_get_dma_source(struct pci_dev *dev)
>   * 1002:439d SB7x0/SB8x0/SB9x0 LPC host controller
>   * 1002:4384 SBx00 PCI to PCI Bridge
>   * 1002:4399 SB7x0/SB8x0/SB9x0 USB OHCI2 Controller
> + *
> + * https://bugzilla.kernel.org/show_bug.cgi?id=81841#c15
> + *
> + * 1022:780f [AMD] FCH PCI Bridge
> + * 1022:7809 [AMD] FCH USB OHCI Controller
>   */
>  static int pci_quirk_amd_sb_acs(struct pci_dev *dev, u16 acs_flags)
>  {
> @@ -3675,6 +3680,8 @@ static const struct pci_dev_acs_enabled {
>  	{ PCI_VENDOR_ID_ATI, 0x439d, pci_quirk_amd_sb_acs },
>  	{ PCI_VENDOR_ID_ATI, 0x4384, pci_quirk_amd_sb_acs },
>  	{ PCI_VENDOR_ID_ATI, 0x4399, pci_quirk_amd_sb_acs },
> +	{ PCI_VENDOR_ID_AMD, 0x780f, pci_quirk_amd_sb_acs },
> +	{ PCI_VENDOR_ID_AMD, 0x7809, pci_quirk_amd_sb_acs },
>  	{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID, pci_quirk_intel_pch_acs },
>  	{ 0 }
>  };
> -- 
> 2.1.1
> 
