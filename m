Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517Ab3JDFVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 01:21:09 -0400
Received: from [216.32.180.12] ([216.32.180.12]:28871 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750920Ab3JDFVH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 01:21:07 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz98dI9371I542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h17326ah1de097h186068h8275bh8275dha509lz2dh2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i1155h)
From: Bhushan Bharat-R65777 <R65777@freescale.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "agraf@suse.de" <agraf@suse.de>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: RE: [PATCH 1/7] powerpc: Add interface to get msi region information
Thread-Topic: [PATCH 1/7] powerpc: Add interface to get msi region
 information
Thread-Index: AQHOtQsCCE10MlaCVk+3VPe/9gzyOZnVmcQAgA5923A=
Date: Fri, 4 Oct 2013 05:19:10 +0000
Message-ID: <6A3DF150A5B70D4F9B66A25E3F7C888D0718FA58@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1379575763-2091-1-git-send-email-Bharat.Bhushan@freescale.com>
 <1379575763-2091-2-git-send-email-Bharat.Bhushan@freescale.com>
 <20130924235812.GD9302@google.com>
In-Reply-To: <20130924235812.GD9302@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.14.2]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-pci-owner@vger.kernel.org [mailto:linux-pci-owner@vger.kernel.org]
> On Behalf Of Bjorn Helgaas
> Sent: Wednesday, September 25, 2013 5:28 AM
> To: Bhushan Bharat-R65777
> Cc: alex.williamson@redhat.com; joro@8bytes.org; benh@kernel.crashing.org;
> galak@kernel.crashing.org; linux-kernel@vger.kernel.org; linuxppc-
> dev@lists.ozlabs.org; linux-pci@vger.kernel.org; agraf@suse.de; Wood Scott-
> B07421; iommu@lists.linux-foundation.org; Bhushan Bharat-R65777
> Subject: Re: [PATCH 1/7] powerpc: Add interface to get msi region information
> 
> On Thu, Sep 19, 2013 at 12:59:17PM +0530, Bharat Bhushan wrote:
> > This patch adds interface to get following information
> >   - Number of MSI regions (which is number of MSI banks for powerpc).
> >   - Get the region address range: Physical page which have the
> >      address/addresses used for generating MSI interrupt
> >      and size of the page.
> >
> > These are required to create IOMMU (Freescale PAMU) mapping for
> > devices which are directly assigned using VFIO.
> >
> > Signed-off-by: Bharat Bhushan <bharat.bhushan@freescale.com>
> > ---
> >  arch/powerpc/include/asm/machdep.h |    8 +++++++
> >  arch/powerpc/include/asm/pci.h     |    2 +
> >  arch/powerpc/kernel/msi.c          |   18 ++++++++++++++++
> >  arch/powerpc/sysdev/fsl_msi.c      |   39 +++++++++++++++++++++++++++++++++--
> >  arch/powerpc/sysdev/fsl_msi.h      |   11 ++++++++-
> >  drivers/pci/msi.c                  |   26 ++++++++++++++++++++++++
> >  include/linux/msi.h                |    8 +++++++
> >  include/linux/pci.h                |   13 ++++++++++++
> >  8 files changed, 120 insertions(+), 5 deletions(-)
> >
> > ...
> 
> > diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c index
> > aca7578..6d85c15 100644
> > --- a/drivers/pci/msi.c
> > +++ b/drivers/pci/msi.c
> > @@ -30,6 +30,20 @@ static int pci_msi_enable = 1;
> >
> >  /* Arch hooks */
> >
> > +#ifndef arch_msi_get_region_count
> > +int arch_msi_get_region_count(void)
> > +{
> > +	return 0;
> > +}
> > +#endif
> > +
> > +#ifndef arch_msi_get_region
> > +int arch_msi_get_region(int region_num, struct msi_region *region) {
> > +	return 0;
> > +}
> > +#endif
> 
> This #define strategy is gone; see 4287d824 ("PCI: use weak functions for MSI
> arch-specific functions").  Please use the weak function strategy for your new
> MSI region functions.

ok

> 
> > +
> >  #ifndef arch_msi_check_device
> >  int arch_msi_check_device(struct pci_dev *dev, int nvec, int type)  {
> > @@ -903,6 +917,18 @@ void pci_disable_msi(struct pci_dev *dev)  }
> > EXPORT_SYMBOL(pci_disable_msi);
> >
> > +int msi_get_region_count(void)
> > +{
> > +	return arch_msi_get_region_count();
> > +}
> > +EXPORT_SYMBOL(msi_get_region_count);
> > +
> > +int msi_get_region(int region_num, struct msi_region *region) {
> > +	return arch_msi_get_region(region_num, region); }
> > +EXPORT_SYMBOL(msi_get_region);
> 
> Please split these interface additions, i.e., the drivers/pci/msi.c,
> include/linux/msi.h, and include/linux/pci.h changes, into a separate patch.

ok

> 
> I don't know enough about VFIO to understand why these new interfaces are
> needed.  Is this the first VFIO IOMMU driver?  I see vfio_iommu_spapr_tce.c and
> vfio_iommu_type1.c but I don't know if they're comparable to the Freescale PAMU.
> Do other VFIO IOMMU implementations support MSI?  If so, do they handle the
> problem of mapping the MSI regions in a different way?

PAMU is an aperture type of IOMMU while other are paging type, So they are completely different from what PAMU is and handle that differently.

> 
> >  /**
> >   * pci_msix_table_size - return the number of device's MSI-X table entries
> >   * @dev: pointer to the pci_dev data structure of MSI-X device
> > function diff --git a/include/linux/msi.h b/include/linux/msi.h index
> > ee66f3a..ae32601 100644
> > --- a/include/linux/msi.h
> > +++ b/include/linux/msi.h
> > @@ -50,6 +50,12 @@ struct msi_desc {
> >  	struct kobject kobj;
> >  };
> >
> > +struct msi_region {
> > +	int region_num;
> > +	dma_addr_t addr;
> > +	size_t size;
> > +};
> 
> This needs some sort of explanatory comment.

Ok

-Bharat

> 
> >  /*
> >   * The arch hook for setup up msi irqs
> >   */
> > @@ -58,5 +64,7 @@ void arch_teardown_msi_irq(unsigned int irq);  int
> > arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);  void
> > arch_teardown_msi_irqs(struct pci_dev *dev);  int
> > arch_msi_check_device(struct pci_dev* dev, int nvec, int type);
> > +int arch_msi_get_region_count(void);
> > +int arch_msi_get_region(int region_num, struct msi_region *region);
> >
> >  #endif /* LINUX_MSI_H */
> > diff --git a/include/linux/pci.h b/include/linux/pci.h index
> > 186540d..2b26a59 100644
> > --- a/include/linux/pci.h
> > +++ b/include/linux/pci.h
> > @@ -1126,6 +1126,7 @@ struct msix_entry {
> >  	u16	entry;	/* driver uses to specify entry, OS writes */
> >  };
> >
> > +struct msi_region;
> >
> >  #ifndef CONFIG_PCI_MSI
> >  static inline int pci_enable_msi_block(struct pci_dev *dev, unsigned
> > int nvec) @@ -1168,6 +1169,16 @@ static inline int
> > pci_msi_enabled(void)  {
> >  	return 0;
> >  }
> > +
> > +static inline int msi_get_region_count(void) {
> > +	return 0;
> > +}
> > +
> > +static inline int msi_get_region(int region_num, struct msi_region
> > +*region) {
> > +	return 0;
> > +}
> >  #else
> >  int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec);
> > int pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int
> > *maxvec); @@ -1180,6 +1191,8 @@ void pci_disable_msix(struct pci_dev
> > *dev);  void msi_remove_pci_irq_vectors(struct pci_dev *dev);  void
> > pci_restore_msi_state(struct pci_dev *dev);  int
> > pci_msi_enabled(void);
> > +int msi_get_region_count(void);
> > +int msi_get_region(int region_num, struct msi_region *region);
> >  #endif
> >
> >  #ifdef CONFIG_PCIEPORTBUS
> > --
> > 1.7.0.4
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-pci"
> > in the body of a message to majordomo@vger.kernel.org More majordomo
> > info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in the body
> of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html


