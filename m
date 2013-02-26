Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758346Ab3BZGQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 01:16:22 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:3991
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753386Ab3BZGQU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 01:16:20 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI9371I542I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahz8dhz8275dh8275bhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5hbe9i1155h)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Stuart Yoder <b08248@gmail.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        Joerg Roedel <joro@8bytes.org>,
        Yoder Stuart-B08248 <B08248@freescale.com>
Subject: RE: [PATCH 2/6] powerpc/fsl_pci: Store the platform device
 information corresponding to the pci controller.
Thread-Topic: [PATCH 2/6] powerpc/fsl_pci: Store the platform device
 information corresponding to the pci controller.
Thread-Index: AQHODdfJlEhE0nyIf0aqdKEpYTrUTpiLT0kAgABlsAA=
Date: Tue, 26 Feb 2013 06:16:10 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D3BD338@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1361191939-21260-1-git-send-email-Varun.Sethi@freescale.com>
	<1361191939-21260-3-git-send-email-Varun.Sethi@freescale.com>
 <CALRxmdDc9TuxH7HgAF3_iLgatoaOUML6fUt8SU+sxHyz6ZVjfw@mail.gmail.com>
In-Reply-To: <CALRxmdDc9TuxH7HgAF3_iLgatoaOUML6fUt8SU+sxHyz6ZVjfw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.132.143]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is not present in Joerg's tree and the add_device API in the PAMU driver requires this patch.

-Varun

> -----Original Message-----
> From: Stuart Yoder [mailto:b08248@gmail.com]
> Sent: Tuesday, February 26, 2013 5:39 AM
> To: Sethi Varun-B16395
> Cc: iommu@lists.linux-foundation.org; linuxppc-dev@lists.ozlabs.org;
> linux-kernel@vger.kernel.org; Wood Scott-B07421; Joerg Roedel; Yoder
> Stuart-B08248
> Subject: Re: [PATCH 2/6] powerpc/fsl_pci: Store the platform device
> information corresponding to the pci controller.
> 
> This patch was submitted separately to linuxppc-dev (and was already
> applied).  You don't need it in this patch set, right?
> 
> Stuart
> 
> On Mon, Feb 18, 2013 at 6:52 AM, Varun Sethi <Varun.Sethi@freescale.com>
> wrote:
> > The pci controller structure has a provision to store the device
> > strcuture pointer of the corresponding platform device. Currently this
> > information is not stored during fsl pci controller initialization.
> > This information is required while dealing with iommu groups for pci
> > devices connected to the fsl pci controller. For the case where the
> > pci devices can't be paritioned, they would fall under the same device
> group as the pci controller.
> >
> > This patch stores the platform device information in the pci
> > controller structure during initialization.
> >
> > Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
> > ---
> >  arch/powerpc/sysdev/fsl_pci.c |    9 +++++++--
> >  arch/powerpc/sysdev/fsl_pci.h |    2 +-
> >  2 files changed, 8 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/powerpc/sysdev/fsl_pci.c
> > b/arch/powerpc/sysdev/fsl_pci.c index 92a5915..b393ae7 100644
> > --- a/arch/powerpc/sysdev/fsl_pci.c
> > +++ b/arch/powerpc/sysdev/fsl_pci.c
> > @@ -421,13 +421,16 @@ void fsl_pcibios_fixup_bus(struct pci_bus *bus)
> >         }
> >  }
> >
> > -int __init fsl_add_bridge(struct device_node *dev, int is_primary)
> > +int __init fsl_add_bridge(struct platform_device *pdev, int
> > +is_primary)
> >  {
> >         int len;
> >         struct pci_controller *hose;
> >         struct resource rsrc;
> >         const int *bus_range;
> >         u8 hdr_type, progif;
> > +       struct device_node *dev;
> > +
> > +       dev = pdev->dev.of_node;
> >
> >         if (!of_device_is_available(dev)) {
> >                 pr_warning("%s: disabled\n", dev->full_name); @@
> > -453,6 +456,8 @@ int __init fsl_add_bridge(struct device_node *dev, int
> is_primary)
> >         if (!hose)
> >                 return -ENOMEM;
> >
> > +       /* set platform device as the parent */
> > +       hose->parent = &pdev->dev;
> >         hose->first_busno = bus_range ? bus_range[0] : 0x0;
> >         hose->last_busno = bus_range ? bus_range[1] : 0xff;
> >
> > @@ -880,7 +885,7 @@ static int fsl_pci_probe(struct platform_device
> > *pdev)  #endif
> >
> >         node = pdev->dev.of_node;
> > -       ret = fsl_add_bridge(node, fsl_pci_primary == node);
> > +       ret = fsl_add_bridge(pdev, fsl_pci_primary == node);
> >
> >  #ifdef CONFIG_SWIOTLB
> >         if (ret == 0) {
> > diff --git a/arch/powerpc/sysdev/fsl_pci.h
> > b/arch/powerpc/sysdev/fsl_pci.h index d078537..c495c00 100644
> > --- a/arch/powerpc/sysdev/fsl_pci.h
> > +++ b/arch/powerpc/sysdev/fsl_pci.h
> > @@ -91,7 +91,7 @@ struct ccsr_pci {
> >         __be32  pex_err_cap_r3;         /* 0x.e34 - PCIE error capture
> register 0 */
> >  };
> >
> > -extern int fsl_add_bridge(struct device_node *dev, int is_primary);
> > +extern int fsl_add_bridge(struct platform_device *pdev, int
> > +is_primary);
> >  extern void fsl_pcibios_fixup_bus(struct pci_bus *bus);  extern int
> > mpc83xx_add_bridge(struct device_node *dev);
> >  u64 fsl_pci_immrbar_base(struct pci_controller *hose);
> > --
> > 1.7.4.1
> >
> >
> > _______________________________________________
> > iommu mailing list
> > iommu@lists.linux-foundation.org
> > https://lists.linuxfoundation.org/mailman/listinfo/iommu


