Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbaEHASV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 20:18:21 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:59096 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbaEHASS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 20:18:18 -0400
Date: Wed, 7 May 2014 18:18:14 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-doc@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>, Randy Dunlap <rdunlap@infradead.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, linux-kernel@vger.kernel.org,
        James Bottomley <jbottomley@parallels.com>, linux-pci@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v2 4/5] iommu: Use dma_addr_t for IOVA arguments
Message-ID: <20140508001814.GB4951@google.com>
References: <20140506223250.17968.27054.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20140506224840.17968.29010.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <45161364.3Gyo1xJJLV@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45161364.3Gyo1xJJLV@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 09:58:58AM +0200, Arnd Bergmann wrote:
> On Tuesday 06 May 2014 16:48:40 Bjorn Helgaas wrote:
> > Convert the "iova" arguments of iommu_map(), iommu_unmap(), etc., from
> > "unsigned long" to dma_addr_t.
> > 
> > bb5547acfcd8 ("iommu/fsl: Make iova dma_addr_t in the iommu_iova_to_phys
> > API") did this for iommu_iova_to_phys(), but didn't fix the rest of the
> > IOMMU API.
> 
> This patch looks 100% correct, but I'm not convinced it's a good idea:
> On 32-bit platforms (i.e. most of the ones you change), doing 64-bit
> arithmetic has a noticeable overhead. I am not aware of an IOMMU that
> actually uses 64-bit DMA addresses on its slave side, usually they
> are used to translate addresses from 32-bit masters into 64-bit
> memory addresses, so using 'unsigned long' seems better from a practical
> point of view as opposed to the strict type correctness.

The current x86 IOMMUs support DMA addresses larger than 32 bits, but
obviously those platforms usually run 64-bit kernels so "unsigned
long" is already 64 bits.

I guess you're thinking about cases where "unsigned long" is 32 bits,
the IOMMU only supports 32 bit DMA addresses, and dma_addr_t is 64
bits.  If the IOMMU only supports 32-bit DMA addresses, is there any
value in having a 64-bit dma_addr_t?

Bjorn
