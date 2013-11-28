Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab3K1KIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 05:08:25 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:24372
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751295Ab3K1KIV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 05:08:21 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z579ehz98dI9371I542I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h17326ah8275bh8275dh1de097h186068ha509lz2dh109h2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h21a6h2216h22d0hbe9i1155h)
From: Bharat Bhushan <Bharat.Bhushan@freescale.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>, "agraf@suse.de" <agraf@suse.de>,
        Scott Wood <scottwood@freescale.com>,
        Stuart Yoder <stuart.yoder@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/9 v2] pci:msi: add weak function for returning msi
 region info
Thread-Topic: [PATCH 1/9 v2] pci:msi: add weak function for returning msi
 region info
Thread-Index: AQHO5Od2XSAujZ/uO0G36zhS5x15Xpo2pGUAgAPSiRA=
Date: Thu, 28 Nov 2013 10:08:16 +0000
Message-ID: <6A3DF150A5B70D4F9B66A25E3F7C888D072363E5@039-SN2MPN1-012.039d.mgd.msft.net>
References: <1384838233-24847-1-git-send-email-Bharat.Bhushan@freescale.com>
 <1384838233-24847-2-git-send-email-Bharat.Bhushan@freescale.com>
 <20131125233602.GA4066@google.com>
In-Reply-To: <20131125233602.GA4066@google.com>
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
> Sent: Tuesday, November 26, 2013 5:06 AM
> To: Bhushan Bharat-R65777
> Cc: alex.williamson@redhat.com; joro@8bytes.org; agraf@suse.de; Wood Scott-
> B07421; Yoder Stuart-B08248; iommu@lists.linux-foundation.org; linux-
> pci@vger.kernel.org; linuxppc-dev@lists.ozlabs.org; linux-
> kernel@vger.kernel.org; Bhushan Bharat-R65777
> Subject: Re: [PATCH 1/9 v2] pci:msi: add weak function for returning msi region
> info
> 
> On Tue, Nov 19, 2013 at 10:47:05AM +0530, Bharat Bhushan wrote:
> > In Aperture type of IOMMU (like FSL PAMU), VFIO-iommu system need to
> > know the MSI region to map its window in h/w. This patch just defines
> > the required weak functions only and will be used by followup patches.
> >
> > Signed-off-by: Bharat Bhushan <bharat.bhushan@freescale.com>
> > ---
> > v1->v2
> >  - Added description on "struct msi_region"
> >
> >  drivers/pci/msi.c   |   22 ++++++++++++++++++++++
> >  include/linux/msi.h |   14 ++++++++++++++
> >  2 files changed, 36 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c index
> > d5f90d6..2643a29 100644
> > --- a/drivers/pci/msi.c
> > +++ b/drivers/pci/msi.c
> > @@ -67,6 +67,28 @@ int __weak arch_msi_check_device(struct pci_dev *dev, int
> nvec, int type)
> >  	return chip->check_device(chip, dev, nvec, type);  }
> >
> > +int __weak arch_msi_get_region_count(void) {
> > +	return 0;
> > +}
> > +
> > +int __weak arch_msi_get_region(int region_num, struct msi_region
> > +*region) {
> > +	return 0;
> > +}
> > +
> > +int msi_get_region_count(void)
> > +{
> > +	return arch_msi_get_region_count();
> > +}
> > +EXPORT_SYMBOL(msi_get_region_count);
> > +
> > +int msi_get_region(int region_num, struct msi_region *region) {
> > +	return arch_msi_get_region(region_num, region); }
> > +EXPORT_SYMBOL(msi_get_region);
> > +
> >  int __weak arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int
> > type)  {
> >  	struct msi_desc *entry;
> > diff --git a/include/linux/msi.h b/include/linux/msi.h index
> > b17ead8..ade1480 100644
> > --- a/include/linux/msi.h
> > +++ b/include/linux/msi.h
> > @@ -51,6 +51,18 @@ struct msi_desc {
> >  };
> >
> >  /*
> > + * This structure is used to get
> > + * - physical address
> > + * - size
> > + * of a msi region
> > + */
> > +struct msi_region {
> > +	int region_num; /* MSI region number */
> > +	dma_addr_t addr; /* Address of MSI region */
> > +	size_t size; /* Size of MSI region */ };
> > +
> > +/*
> >   * The arch hooks to setup up msi irqs. Those functions are
> >   * implemented as weak symbols so that they /can/ be overriden by
> >   * architecture specific code if needed.
> > @@ -64,6 +76,8 @@ void arch_restore_msi_irqs(struct pci_dev *dev, int
> > irq);
> >
> >  void default_teardown_msi_irqs(struct pci_dev *dev);  void
> > default_restore_msi_irqs(struct pci_dev *dev, int irq);
> > +int arch_msi_get_region_count(void);
> > +int arch_msi_get_region(int region_num, struct msi_region *region);
> 
> It doesn't look like any of this (struct msi_region, msi_get_region(),
> msi_get_region_count()) is actually used by drivers/pci/msi.c, so I don't think
> it needs to be declared in generic code.  It looks like it's only used in
> drivers/vfio/vfio_iommu_fsl_pamu.c, where you already know you have an FSL
> IOMMU, and you can just call FSL-specific interfaces directly.

Thanks Bjorn,

Want to be sure of what you are suggesting.

What I understood is that we define these (struct msi_region, msi_get_region(), msi_get_region_count()) in arch/powerpc/include/fsl_msi.h (a new file). Include this header file directly in driver/vfio/vfio_iommu_fsl_pamu.c

Same also applies for msi_set_iova() in patch-5 ?

-Bharat

> 
> Bjorn
> 
> >
> >  struct msi_chip {
> >  	struct module *owner;
> > --
> > 1.7.0.4
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in the body
> of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html


