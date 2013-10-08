Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab3JHX0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 19:26:04 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:45303 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525Ab3JHX0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 19:26:01 -0400
MIME-Version: 1.0
In-Reply-To: <1381273037.7979.298.camel@snotra.buserror.net>
References: <1379575763-2091-1-git-send-email-Bharat.Bhushan@freescale.com>
 <1379575763-2091-2-git-send-email-Bharat.Bhushan@freescale.com> <1381273037.7979.298.camel@snotra.buserror.net>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 8 Oct 2013 17:25:40 -0600
Message-ID: <CAErSpo7+7SHVcOJkHkW5cjb6pN+bqYeRdPBA=MVX0RLz=-pP6Q@mail.gmail.com>
Subject: Re: [PATCH 1/7] powerpc: Add interface to get msi region information
To: Scott Wood <scottwood@freescale.com>
Cc: Bharat Bhushan <r65777@freescale.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> -     u32 msiir_offset; /* Offset of MSIIR, relative to start of CCSR */
>> +     dma_addr_t msiir; /* MSIIR Address in CCSR */
>
> Are you sure dma_addr_t is right here, versus phys_addr_t?  It implies
> that it's the output of the DMA API, but I don't think the DMA API is
> used in the MSI driver.  Perhaps it should be, but we still want the raw
> physical address to pass on to VFIO.

I don't know what "msiir" is used for, but if it's an address you
program into a PCI device, then it's a dma_addr_t even if you didn't
get it from the DMA API.  Maybe "bus_addr_t" would have been a more
suggestive name than "dma_addr_t".  That said, I have no idea how this
relates to VFIO.

Bjorn
