Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbaJWMlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 08:41:21 -0400
Received: from 8bytes.org ([81.169.241.247]:43383 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755282AbaJWMlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 08:41:18 -0400
Date: Thu, 23 Oct 2014 14:41:15 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Frank Blaschka <blaschka@linux.vnet.ibm.com>
Cc: schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, iommu@lists.linux-foundation.org,
        sebott@linux.vnet.ibm.com, gerald.schaefer@de.ibm.com
Subject: Re: [PATCH linux-next] iommu: add iommu for s390 platform
Message-ID: <20141023124115.GB10053@8bytes.org>
References: <1413892645-37657-1-git-send-email-blaschka@linux.vnet.ibm.com>
 <20141022141728.GG10074@8bytes.org>
 <20141022154320.GA42442@tuxmaker.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141022154320.GA42442@tuxmaker.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 05:43:20PM +0200, Frank Blaschka wrote:
> Basically there are no limitations. Depending on the s390 maschine
> generation a device starts its IOVA at a specific address (announced by
> the HW). But as I already told each device starts at the same address.
> I think this prevents having multiple devices on the same IOMMU domain.

Why, each device has its own IOVA address space, so IOVA A could map to
physical address X for one device and to Y for another, no? And if you
point multiple devices to the same dma_table they share the mappings
(and thus the address space). Or am I getting something wrong?

> yes, you are absolutely right. There is a per-device dma_table.
> There is no general IOMMU device but each pci device has its own IOMMU
> translation capability.

I see, in this way it is similar to ARM where there is often also one IOMMU
per master device.

> Is there a possibility the IOMMU domain can support e.g. something like
> 
> VIOA 0x10000 -> pci device 1
> VIOA 0x10000 -> pci device 2

A domain is basically an abstraction for a DMA page table (or a
dma_table, as you call it on s390). So you can easily create similar
mappings for more than one device with it.



	Joerg

