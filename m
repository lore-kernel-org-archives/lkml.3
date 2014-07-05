Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500AbaGEV0e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 17:26:34 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:35044 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298AbaGEV0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 17:26:32 -0400
Date: Sat, 5 Jul 2014 15:26:29 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH] PCI: Add bridge DMA alias quirk for Intel 82801
Message-ID: <20140705212629.GF28871@google.com>
References: <20140623223530.13445.94886.stgit@gimli.home>
 <20140705163143.GB6247@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140705163143.GB6247@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Joerg]

On Sat, Jul 05, 2014 at 10:31:43AM -0600, Bjorn Helgaas wrote:
> On Mon, Jun 23, 2014 at 04:36:25PM -0600, Alex Williamson wrote:
> > This bridge sometimes shows up as a root complex device and sometimes
> > as a discrete PCIe-to-PCI bridge.  Testing indicates that in the
> > latter case, we need to enable the PCIe bridge DMA alias quirk.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > Reported-by: Milos Kaurin <milos.kaurin@gmail.com>
> > Tested-by: Milos Kaurin <milos.kaurin@gmail.com>
> 
> Applied to for-linus for v3.16, thanks!

Actually, this quirk doesn't make any difference until the iommu changes
are in, so there's no reason to have this in v3.16, is there?  

I saw that Joerg applied those iommu changes to his core branch, which I
assume will be merged for v3.17.  So I'll move this to a pci/iommu branch,
to be merged during the v3.17 merge window.

> > ---
> > 
> >  drivers/pci/quirks.c |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> > index 78a7df6..460c354 100644
> > --- a/drivers/pci/quirks.c
> > +++ b/drivers/pci/quirks.c
> > @@ -3405,6 +3405,8 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ASMEDIA, 0x1080,
> >  DECLARE_PCI_FIXUP_HEADER(0x10e3, 0x8113, quirk_use_pcie_bridge_dma_alias);
> >  /* ITE 8892, https://bugzilla.kernel.org/show_bug.cgi?id=73551 */
> >  DECLARE_PCI_FIXUP_HEADER(0x1283, 0x8892, quirk_use_pcie_bridge_dma_alias);
> > +/* Intel 82801, https://bugzilla.kernel.org/show_bug.cgi?id=44881#c49 */
> > +DECLARE_PCI_FIXUP_HEADER(0x8086, 0x244e, quirk_use_pcie_bridge_dma_alias);
> >  
> >  /*
> >   * AMD has indicated that the devices below do not support peer-to-peer
> > 
