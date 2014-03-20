Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933805AbaCTS32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 14:29:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.130]:65179 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbaCTS30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 14:29:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Subject: Re: DMABOUNCE in pci-rcar
Date: Thu, 20 Mar 2014 19:29:13 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Russell King <linux@arm.linux.org.uk>, linux-sh@vger.kernel.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Magnus Damm <damm@opensource.se>, Ben Dooks <ben-linux@fluff.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        linux-arm-kernel@lists.infradead.org
References: <201402241200.21944.arnd@arndb.de> <20140320173106.GA19395@obsidianresearch.com> <532B2628.5080305@codethink.co.uk>
In-Reply-To: <532B2628.5080305@codethink.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201403201929.13633.arnd@arndb.de>
X-Provags-ID: V02:K0:2jbdtsHukjbY1QXzdg1itwD2rvWlt1iI4wZsvJVXErX
 6P7erDUqICHjb7EVVLlNF3KdYpRI7Z6J/qIleau3d6kn/TZobo
 Iixa+QBklRE6GymJ55TOpCnJA/LdeFAqVsywHbPtYreuBaxd2F
 U4dpsulkvMCZsUAs5scaepYSZuNitpdsFxDeehUOqejp4DE2Rz
 Mh3O2GPIVWvQwKslavLaB8OnvwjM1DHLi08k7Bvuv1eJN5en5b
 JOapJyimh5lS0CNY1FIgMRptWovzFymlvhFps3oEgWgqOZmDsU
 pH+RrKVFCInvW11BNVct9wSd1ZXQbOdytc2cZLBoRBMIPn7RfF
 M0I+8zR9MlHdSEDsRQq/WXygZoAFfbanq2gVm6HPm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 March 2014, Ben Dooks wrote:
> On 20/03/14 18:31, Jason Gunthorpe wrote:
> > On Thu, Mar 20, 2014 at 06:25:25PM +0100, Ben Dooks wrote:
> >> So doing:
> >>
> >> static void pci_rcar_fixup(struct pci_dev *dev)
> >> {
> >>      if (dev->bus->ops == &rcar_pci_ops) {
> >>              dev_info(&dev->dev, "applying new dma mask\n");
> >>              dev->dma_mask = DMA_BIT_MASK(31);
> >>      }
> >> }
> >>
> >> DECLARE_PCI_FIXUP_EARLY(PCI_ANY_ID, PCI_ANY_ID, pci_rcar_fixup);
> >>
> >> Did not work for me :(
> >
> > Seems like it should work, do you have CONFIG_PCI_QUIRKS turned on?
> 
> Yes, see the print happening, just still PCI OHCI dies horribly.

Shouldn't that mask be 30 instead of 31 when you only support DMA
to the first GB?

Another possibility is that 'EARLY' means it gets applied before
the normal mask is set.

Finally, setting the mask itself is not enough. As I mentioned you
also need to use the swiotlb_dma_ops. Did you already implement
those?

	Arnd
