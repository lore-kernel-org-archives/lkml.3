Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab3JHRKD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 13:10:03 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:32159
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756062Ab3JHRJ7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 13:09:59 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VS2(zz98dI9371I542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275dhz2dh2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i2184m1155h)
From: Bhushan Bharat-R65777 <R65777@freescale.com>
To: "joro@8bytes.org" <joro@8bytes.org>, Bjorn Helgaas <bhelgaas@google.com>
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
Thread-Index: AQHOtQsCCE10MlaCVk+3VPe/9gzyOZnVmcQAgA5923CABwqJgIAABBgAgAAAatA=
Date: Tue, 8 Oct 2013 17:09:50 +0000
Message-ID: <6A3DF150A5B70D4F9B66A25E3F7C888D07196054@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1379575763-2091-1-git-send-email-Bharat.Bhushan@freescale.com>
 <1379575763-2091-2-git-send-email-Bharat.Bhushan@freescale.com>
 <20130924235812.GD9302@google.com>
 <6A3DF150A5B70D4F9B66A25E3F7C888D0718FA58@039-SN2MPN1-011.039d.mgd.msft.net>
 <CAErSpo742BOxzxRaFQn+UnsNday4_8LM6+3G6=cfp9DHecPxDg@mail.gmail.com>
 <20131008170228.GD17455@8bytes.org>
In-Reply-To: <20131008170228.GD17455@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.214.249.58]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: joro@8bytes.org [mailto:joro@8bytes.org]
> Sent: Tuesday, October 08, 2013 10:32 PM
> To: Bjorn Helgaas
> Cc: Bhushan Bharat-R65777; alex.williamson@redhat.com; benh@kernel.crashing.org;
> galak@kernel.crashing.org; linux-kernel@vger.kernel.org; linuxppc-
> dev@lists.ozlabs.org; linux-pci@vger.kernel.org; agraf@suse.de; Wood Scott-
> B07421; iommu@lists.linux-foundation.org
> Subject: Re: [PATCH 1/7] powerpc: Add interface to get msi region information
> 
> On Tue, Oct 08, 2013 at 10:47:49AM -0600, Bjorn Helgaas wrote:
> > I still have no idea what an "aperture type IOMMU" is, other than that
> > it is "different."
> 
> An aperture based IOMMU is basically any GART-like IOMMU which can only remap a
> small window (the aperture) of the DMA address space. DMA outside of that window
> is either blocked completly or passed through untranslated.

It is completely blocked for Freescale PAMU. 
So for this type of iommu what we have to do is to create a MSI mapping just after guest physical address, Example: guest have a 512M of memory then we create window of 1G (because of power of 2 requirement), then we have to FIT MSI just after 512M of guest.
And for that we need
	1) to know the physical address of MSI's in interrupt controller (for that this patch was all about of).

	2) When guest enable MSI interrupt then we write MSI-address and MSI-DATA in device. The discussion with Alex Williamson is about that interface.

Thanks
-Bharat

> 
> 
> 	Joerg
> 
> 


