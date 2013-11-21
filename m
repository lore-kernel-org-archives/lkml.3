Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab3KULU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 06:20:58 -0500
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:59896
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753924Ab3KULU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 06:20:57 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(zz98dI9371I936eI542I1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h17326ah8275bh8275dh1de097h186068hz2dh109h2a8h839h8e2h8e3h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h21a6h2216h22d0hbe9i1155h)
From: Bharat Bhushan <Bharat.Bhushan@freescale.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "joro@8bytes.org" <joro@8bytes.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "agraf@suse.de" <agraf@suse.de>, Scott Wood <scottwood@freescale.com>,
        Stuart Yoder <stuart.yoder@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/9 v2] vfio-pci: add support for Freescale IOMMU (PAMU)
Thread-Topic: [PATCH 0/9 v2] vfio-pci: add support for Freescale IOMMU (PAMU)
Thread-Index: AQHO5OdyKeXB/EytyUeVGr+Ok97IOJoueBeAgAENqwA=
Date: Thu, 21 Nov 2013 11:20:49 +0000
Message-ID: <6A3DF150A5B70D4F9B66A25E3F7C888D0721D9AC@039-SN2MPN1-012.039d.mgd.msft.net>
References: <1384838233-24847-1-git-send-email-Bharat.Bhushan@freescale.com>
 <1384973243.2879.361.camel@ul30vt.home>
In-Reply-To: <1384973243.2879.361.camel@ul30vt.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.14.2]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rALBL5xo016450



> -----Original Message-----
> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Thursday, November 21, 2013 12:17 AM
> To: Bhushan Bharat-R65777
> Cc: joro@8bytes.org; bhelgaas@google.com; agraf@suse.de; Wood Scott-B07421;
> Yoder Stuart-B08248; iommu@lists.linux-foundation.org; linux-
> pci@vger.kernel.org; linuxppc-dev@lists.ozlabs.org; linux-
> kernel@vger.kernel.org; Bhushan Bharat-R65777
> Subject: Re: [PATCH 0/9 v2] vfio-pci: add support for Freescale IOMMU (PAMU)
> 
> On Tue, 2013-11-19 at 10:47 +0530, Bharat Bhushan wrote:
> > From: Bharat Bhushan <bharat.bhushan@freescale.com>
> >
> > PAMU (FSL IOMMU) has a concept of primary window and subwindows.
> > Primary window corresponds to the complete guest iova address space
> > (including MSI space), with respect to IOMMU_API this is termed as
> > geometry. IOVA Base of subwindow is determined from the number of
> > subwindows (configurable using iommu API).
> > MSI I/O page must be within the geometry and maximum supported
> > subwindows, so MSI IO-page is setup just after guest memory iova space.
> >
> > So patch 1/9-4/9(inclusive) are for defining the interface to get:
> >   - Number of MSI regions (which is number of MSI banks for powerpc)
> >   - MSI-region address range: Physical page which have the
> >     address/addresses used for generating MSI interrupt
> >     and size of the page.
> >
> > Patch 5/9-7/9(inclusive) is defining the interface of setting up MSI
> > iova-base for a msi region(bank) for a device. so that when
> > msi-message will be composed then this configured iova will be used.
> > Earlier we were using iommu interface for getting the configured iova
> > which was not currect and Alex Williamson suggeested this type of interface.
> >
> > patch 8/9 moves some common functions in a separate file so that these
> > can be used by FSL_PAMU implementation (next patch uses this).
> > These will be used later for iommu-none implementation. I believe we
> > can do more of this but will take step by step.
> >
> > Finally last patch actually adds the support for FSL-PAMU :)
> 
> Patches 1-3: msi_get_region needs to return an error an error (probably
> -EINVAL) if called on a path where there's no backend implementation.
> Otherwise the caller doesn't know that the data in the region pointer isn't
> valid.

will correct.

> 
> Patches 5&6: same as above for msi_set_iova, return an error if no backend
> implementation.

Ok

> 
> Patch 7: Why does fsl_msi_del_iova_device bother to return anything if it's
> always zero?  Return -ENODEV when not found?

Will make -ENODEV.

> 
> Patch 9:
> 
> vfio_handle_get_attr() passes random kernel data back to userspace in the event
> of iommu_domain_get_attr() error.

Will correct.

> 
> vfio_handle_set_attr(): I don't see any data validation happening, is
> iommu_domain_set_attr() really that safe?

We do not need any data validation here and iommu driver does whatever needed.
So yes,  iommu_domain_set_attr() is safe.

> 
> For both of those, drop the pr_err on unknown attribute, it's sufficient to
> return error.

ok

> 
> Is VFIO_IOMMU_PAMU_GET_MSI_BANK_COUNT per aperture (ie. each vfio user has
> $COUNT regions at their disposal exclusively)?

Number of msi-bank count is system wide and not per aperture, But will be setting windows for banks in the device aperture.
So say if we are direct assigning 2 pci device (both have different iommu group, so 2 aperture in iommu) to VM.
Now qemu can make only one call to know how many msi-banks are there but it must set sub-windows for all banks for both pci device in its respective aperture.

Thanks
-Bharat

>  Thanks,
> 
> Alex
> 
> > v1->v2
> >  - Added interface for setting msi iova for a msi region for a device.
> >    Earlier I added iommu interface for same but as per comment that is
> >    removed and now created a direct interface between vfio and msi.
> >  - Incorporated review comments (details is in individual patch)
> >
> > Bharat Bhushan (9):
> >   pci:msi: add weak function for returning msi region info
> >   pci: msi: expose msi region information functions
> >   powerpc: pci: Add arch specific msi region interface
> >   powerpc: msi: Extend the msi region interface to get info from
> >     fsl_msi
> >   pci/msi: interface to set an iova for a msi region
> >   powerpc: pci: Extend msi iova page setup to arch specific
> >   pci: msi: Extend msi iova setting interface to powerpc arch
> >   vfio: moving some functions in common file
> >   vfio pci: Add vfio iommu implementation for FSL_PAMU
> >
> >  arch/powerpc/include/asm/machdep.h |   10 +
> >  arch/powerpc/kernel/msi.c          |   28 +
> >  arch/powerpc/sysdev/fsl_msi.c      |  132 +++++-
> >  arch/powerpc/sysdev/fsl_msi.h      |   25 +-
> >  drivers/pci/msi.c                  |   35 ++
> >  drivers/vfio/Kconfig               |    6 +
> >  drivers/vfio/Makefile              |    5 +-
> >  drivers/vfio/vfio_iommu_common.c   |  227 ++++++++
> >  drivers/vfio/vfio_iommu_common.h   |   27 +
> >  drivers/vfio/vfio_iommu_fsl_pamu.c | 1003
> ++++++++++++++++++++++++++++++++++++
> >  drivers/vfio/vfio_iommu_type1.c    |  206 +--------
> >  include/linux/msi.h                |   14 +
> >  include/linux/pci.h                |   21 +
> >  include/uapi/linux/vfio.h          |  100 ++++
> >  14 files changed, 1623 insertions(+), 216 deletions(-)  create mode
> > 100644 drivers/vfio/vfio_iommu_common.c  create mode 100644
> > drivers/vfio/vfio_iommu_common.h  create mode 100644
> > drivers/vfio/vfio_iommu_fsl_pamu.c
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-kernel" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
