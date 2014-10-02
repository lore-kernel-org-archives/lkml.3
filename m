Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbaJBNr2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:47:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbaJBNr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:47:26 -0400
Message-ID: <1412257639.7360.247.camel@ul30vt.home>
Subject: Re: [PATCH] PCI: Add ACS support for AMD A88X southbridge devices
From: Alex Williamson <alex.williamson@redhat.com>
To: Marti Raudsepp <marti@juffo.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joel Schopp <joel.schopp@amd.com>
Date: Thu, 02 Oct 2014 07:47:19 -0600
In-Reply-To: <1412255137-28954-1-git-send-email-marti@juffo.org>
References: <1412255137-28954-1-git-send-email-marti@juffo.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-02 at 16:05 +0300, Marti Raudsepp wrote:
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

The bugzilla comments aren't quite as decisive as I'd like to see for a
quirk, so I think we should probably get an ACK from Joel before
including this.  Thanks,

Alex

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



