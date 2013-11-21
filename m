Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab3KULUT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 06:20:19 -0500
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:40113
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754095Ab3KULUP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 06:20:15 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zz98dI9371I936eI542I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh8275dh1de097hz2dh109h2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h21a6h2216h22d0hbe9i1155h)
From: Varun Sethi <Varun.Sethi@freescale.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Bharat Bhushan <Bharat.Bhushan@freescale.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "agraf@suse.de" <agraf@suse.de>,
        Stuart Yoder <stuart.yoder@freescale.com>,
        Scott Wood <scottwood@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/9 v2] vfio-pci: add support for Freescale IOMMU (PAMU)
Thread-Topic: [PATCH 0/9 v2] vfio-pci: add support for Freescale IOMMU (PAMU)
Thread-Index: AQHO5iD9xzIR7xUqmEWQ7tJpR67mEZoviE1g
Date: Thu, 21 Nov 2013 11:20:01 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D0A5C38AC@039-SN2MPN1-012.039d.mgd.msft.net>
References: <1384838233-24847-1-git-send-email-Bharat.Bhushan@freescale.com>
 <1384973243.2879.361.camel@ul30vt.home>
In-Reply-To: <1384973243.2879.361.camel@ul30vt.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.133.51]
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
> bounces@lists.linux-foundation.org] On Behalf Of Alex Williamson
> Sent: Thursday, November 21, 2013 12:17 AM
> To: Bhushan Bharat-R65777
> Cc: linux-pci@vger.kernel.org; agraf@suse.de; Yoder Stuart-B08248; Wood
> Scott-B07421; iommu@lists.linux-foundation.org; bhelgaas@google.com;
> linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 0/9 v2] vfio-pci: add support for Freescale IOMMU
> (PAMU)
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
> > which was not currect and Alex Williamson suggeested this type of
> interface.
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
> Otherwise the caller doesn't know that the data in the region pointer
> isn't valid.
> 
> Patches 5&6: same as above for msi_set_iova, return an error if no
> backend implementation.
> 
> Patch 7: Why does fsl_msi_del_iova_device bother to return anything if
> it's always zero?  Return -ENODEV when not found?
> 
> Patch 9:
> 
> vfio_handle_get_attr() passes random kernel data back to userspace in the
> event of iommu_domain_get_attr() error.
> 
> vfio_handle_set_attr(): I don't see any data validation happening, is
> iommu_domain_set_attr() really that safe?
[Sethi Varun-B16395] The parameter validation can be left to the lower level iommu driver. The attribute could be specific to a given hardware.

-Varun

