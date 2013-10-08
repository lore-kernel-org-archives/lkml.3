Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab3JHXff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 19:35:35 -0400
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:58759
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755492Ab3JHXfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 19:35:33 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI936eI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
Message-ID: <1381275325.7979.320.camel@snotra.buserror.net>
Subject: Re: [PATCH 1/7] powerpc: Add interface to get msi region information
From: Scott Wood <scottwood@freescale.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Bharat Bhushan <r65777@freescale.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Alexander Graf <agraf@suse.de>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        Bharat Bhushan <Bharat.Bhushan@freescale.com>
Date: Tue, 8 Oct 2013 18:35:25 -0500
In-Reply-To: <CAErSpo7+7SHVcOJkHkW5cjb6pN+bqYeRdPBA=MVX0RLz=-pP6Q@mail.gmail.com>
References: <1379575763-2091-1-git-send-email-Bharat.Bhushan@freescale.com>
	 <1379575763-2091-2-git-send-email-Bharat.Bhushan@freescale.com>
	 <1381273037.7979.298.camel@snotra.buserror.net>
	 <CAErSpo7+7SHVcOJkHkW5cjb6pN+bqYeRdPBA=MVX0RLz=-pP6Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-08 at 17:25 -0600, Bjorn Helgaas wrote:
> >> -     u32 msiir_offset; /* Offset of MSIIR, relative to start of CCSR */
> >> +     dma_addr_t msiir; /* MSIIR Address in CCSR */
> >
> > Are you sure dma_addr_t is right here, versus phys_addr_t?  It implies
> > that it's the output of the DMA API, but I don't think the DMA API is
> > used in the MSI driver.  Perhaps it should be, but we still want the raw
> > physical address to pass on to VFIO.
> 
> I don't know what "msiir" is used for, but if it's an address you
> program into a PCI device, then it's a dma_addr_t even if you didn't
> get it from the DMA API.  Maybe "bus_addr_t" would have been a more
> suggestive name than "dma_addr_t".  That said, I have no idea how this
> relates to VFIO.

It's a bit awkward because it gets used both as something to program
into a PCI device (and it's probably a bug that the DMA API doesn't get
used), and also (if I understand the current plans correctly) as a
physical address to give to VFIO to be a destination address in an IOMMU
mapping.  So I think the value we keep here should be a phys_addr_t (it
comes straight from the MMIO address in the device tree), which gets
trivially turned into a dma_addr_t by the non-VFIO code path because
there's currently no translation there.

-Scott



