Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759191Ab3JOOfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 10:35:48 -0400
Received: from mail-db9lp0251.outbound.messaging.microsoft.com ([213.199.154.251]:2760
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753027Ab3JOOfq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 10:35:46 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI9371I542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bh8275dhz2dh2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i1155h)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Yoder Stuart-B08248 <B08248@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Bhushan Bharat-R65777 <R65777@freescale.com>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: RE: [PATCH 1/3] iommu/fsl: Factor out PCI specific code.
Thread-Topic: [PATCH 1/3] iommu/fsl: Factor out PCI specific code.
Thread-Index: AQHOx4wGLPqwtGZUFEG4i/jQn1uoC5n06GiAgADhnJA=
Date: Tue, 15 Oct 2013 14:35:41 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D0A53D863@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1381609954-15283-1-git-send-email-Varun.Sethi@freescale.com>
	<1381609954-15283-2-git-send-email-Varun.Sethi@freescale.com>
 <20131015001611.GA9203@google.com>
In-Reply-To: <20131015001611.GA9203@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.214.249.5]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: iommu-bounces@lists.linux-foundation.org [mailto:iommu-
> bounces@lists.linux-foundation.org] On Behalf Of Bjorn Helgaas
> Sent: Tuesday, October 15, 2013 5:46 AM
> To: Sethi Varun-B16395
> Cc: Yoder Stuart-B08248; linux-kernel@vger.kernel.org; iommu@lists.linux-
> foundation.org; Bhushan Bharat-R65777; Wood Scott-B07421; linuxppc-
> dev@lists.ozlabs.org
> Subject: Re: [PATCH 1/3] iommu/fsl: Factor out PCI specific code.
> 
> On Sun, Oct 13, 2013 at 02:02:32AM +0530, Varun Sethi wrote:
> > Factor out PCI specific code in the PAMU driver.
> >
> > Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
> > ---
> >  drivers/iommu/fsl_pamu_domain.c |   81 +++++++++++++++++++------------
> --------
> >  1 file changed, 40 insertions(+), 41 deletions(-)
> >
> > diff --git a/drivers/iommu/fsl_pamu_domain.c
> > b/drivers/iommu/fsl_pamu_domain.c index c857c30..e02e1de 100644
> > --- a/drivers/iommu/fsl_pamu_domain.c
> > +++ b/drivers/iommu/fsl_pamu_domain.c
> > @@ -677,13 +677,9 @@ static int handle_attach_device(struct
> fsl_dma_domain *dma_domain,
> >  	return ret;
> >  }
> >
> > -static int fsl_pamu_attach_device(struct iommu_domain *domain,
> > -				  struct device *dev)
> > +static void check_for_pci_dma_device(struct device **dev)
> 
> "check_for_pci_dma_device()" doesn't give a good clue about what the
> function returns.  And why return something via a reference parameter
> when you could return it directly?
[Sethi Varun-B16395] I will rename the function to get_dma_device and make it return a pointer.
> 
> >  {
> > -	struct fsl_dma_domain *dma_domain = domain->priv;
> > -	const u32 *liodn;
> > -	u32 liodn_cnt;
> > -	int len, ret = 0;
> > +#ifdef CONFIG_PCI
> >  	struct pci_dev *pdev = NULL;
> >  	struct pci_controller *pci_ctl;
> 
> This is sort of a goofy looking function.  It would read much better as
> something like this:
> 
[Sethi Varun-B16395] Will make the change.

>       struct device *dma_dev = dev;
> 
>   #ifdef CONFIG_PCI
>       if (...) {
>           dma_dev = ...;
>       }
>   #endif
> 
>       return dma_dev;
> 
> Does this need to care about reference counting when you return a pointer
> to a different device?
> 
[Sethi Varun-B16395] Reference counting isn't required, as we are just obtaining the LIODN value from the PCI controller.

-Varun

