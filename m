Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab3JJVN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 17:13:27 -0400
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:29254
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755470Ab3JJVNZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 17:13:25 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI9371I542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275dhz2dh2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i1155h)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Bhushan Bharat-R65777 <R65777@freescale.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Bjorn Helgaas <bhelgaas@google.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
Thread-Index: AQHOxEYyNvcyv4c6wk+ebg3djOmAJJnVmcQAgA5923CABwqJgIAABBgAgAAAatCAA0B10A==
Date: Thu, 10 Oct 2013 21:13:21 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D0A52BC9D@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1379575763-2091-1-git-send-email-Bharat.Bhushan@freescale.com>
 <1379575763-2091-2-git-send-email-Bharat.Bhushan@freescale.com>
 <20130924235812.GD9302@google.com>
 <6A3DF150A5B70D4F9B66A25E3F7C888D0718FA58@039-SN2MPN1-011.039d.mgd.msft.net>
 <CAErSpo742BOxzxRaFQn+UnsNday4_8LM6+3G6=cfp9DHecPxDg@mail.gmail.com>
 <20131008170228.GD17455@8bytes.org>
 <6A3DF150A5B70D4F9B66A25E3F7C888D07196054@039-SN2MPN1-011.039d.mgd.msft.net>
In-Reply-To: <6A3DF150A5B70D4F9B66A25E3F7C888D07196054@039-SN2MPN1-011.039d.mgd.msft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.214.249.210]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Bhushan Bharat-R65777
> Sent: Tuesday, October 08, 2013 10:40 PM
> To: joro@8bytes.org; Bjorn Helgaas
> Cc: alex.williamson@redhat.com; benh@kernel.crashing.org;
> galak@kernel.crashing.org; linux-kernel@vger.kernel.org; linuxppc-
> dev@lists.ozlabs.org; linux-pci@vger.kernel.org; agraf@suse.de; Wood
> Scott-B07421; iommu@lists.linux-foundation.org
> Subject: RE: [PATCH 1/7] powerpc: Add interface to get msi region
> information
> 
> 
> 
> > -----Original Message-----
> > From: joro@8bytes.org [mailto:joro@8bytes.org]
> > Sent: Tuesday, October 08, 2013 10:32 PM
> > To: Bjorn Helgaas
> > Cc: Bhushan Bharat-R65777; alex.williamson@redhat.com;
> > benh@kernel.crashing.org; galak@kernel.crashing.org;
> > linux-kernel@vger.kernel.org; linuxppc- dev@lists.ozlabs.org;
> > linux-pci@vger.kernel.org; agraf@suse.de; Wood Scott- B07421;
> > iommu@lists.linux-foundation.org
> > Subject: Re: [PATCH 1/7] powerpc: Add interface to get msi region
> > information
> >
> > On Tue, Oct 08, 2013 at 10:47:49AM -0600, Bjorn Helgaas wrote:
> > > I still have no idea what an "aperture type IOMMU" is, other than
> > > that it is "different."
> >
> > An aperture based IOMMU is basically any GART-like IOMMU which can
> > only remap a small window (the aperture) of the DMA address space. DMA
> > outside of that window is either blocked completly or passed through
> untranslated.
> 
> It is completely blocked for Freescale PAMU.
> So for this type of iommu what we have to do is to create a MSI mapping
> just after guest physical address, Example: guest have a 512M of memory
> then we create window of 1G (because of power of 2 requirement), then we
> have to FIT MSI just after 512M of guest.

[Sethi Varun-B16395] PAMU (FSL IOMMU) has a concept of primary window and subwindows. Primary window corresponds to the complete guest iova address space (including MSI space), with respect to IOMMU_API this is termed as geometry . IOVA Base of subwindow is determined from the number of subwindows (configurable using iommu API). Subwindows allow for handling physically discontiguous memory. PAMU translates device iova accesses to actual physical address. MSI mapping would be addressed by a subwindow, with iova base starting at the end of the guest iova space. 

VFIO code creates a PAMU  window (also defines number of subwindow) to map the guest iova space + msi space. The interface defined by this patch queries the PAMU driver to get the iova mapping for the msi region assigned to the PCIe device (assigned to the guest).

-Varun




