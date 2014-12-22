Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbaLVWY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 17:24:59 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:54347 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853AbaLVWY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 17:24:57 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, will.deacon@arm.com
Subject: Re: [RFC v1 PATCH 1/2] of/pci: add of_pci_dma_configure() update dma configuration
Date: Mon, 22 Dec 2014 23:24:33 +0100
Message-ID: <2285493.QXo0OxClZ5@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54988FDB.8000108@ti.com>
References: <1418940425-2017-1-git-send-email-m-karicheri2@ti.com> <11285984.OK9CqQGmjZ@wuerfel> <54988FDB.8000108@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:s4JTSFr1G6h9UWEP+abvC652jVLKlu8FMR1T+CdefR5mWJip/Pb
 tJLkHZFOnUaShNfZOi2+Ij+aaWhgrWS9BkuI64q9F8oaTr3rsn6Eod+oNptelFc3dLjWLHD
 T3stBgDU/dOh/fim0XqlonZfcMuk7tZAnXf7UHP/bpR/qb55K9UFJIdnz2O7A505o6KJ68b
 AL18Faxy8dRDPr6aPKm9Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 December 2014 16:40:43 Murali Karicheri wrote:
> >> +++ b/arch/arm/mm/dma-mapping.c
> >> @@ -2052,9 +2052,10 @@ void arch_setup_dma_ops(struct device *dev, u64
> >> dma_base, u64 size,
> >>                           struct iommu_ops *iommu, bool coherent)
> >>    {
> >>           struct dma_map_ops *dma_ops;
> >> +       u64 temp_size = min((*(dev->dma_mask) + 1), size);
> >>
> >>           dev->archdata.dma_coherent = coherent;
> >> -       if (arm_setup_iommu_dma_ops(dev, dma_base, size, iommu))
> >> +       if (arm_setup_iommu_dma_ops(dev, dma_base, temp_size, iommu))
> >>
> >> If you agree, I will post v1 of the patch with these updates. Let me
> >> know. I did some basic tests on Keystone with these changes and it works
> >> fine.
> >
> > It's not exactly what I meant. My main point was that we need to limit
> > dev->dma_mask to (size-1) here, but you are not touching that.
> 
> if you mean overriding the dev->dma_mask to min((*dev->dma_mask), 
> size-1), then I am getting the error "Coherent DMA mask 0x7fffffff (pfn 
> 0x780000-0x800000) covers a smaller range of system memory than the DMA 
> zone pfn 0x0-0x880000) when the devices on Keystone tries to set the dma 
> mask. Something wrong and I need to look into the code.

Right, it sounds like the offset was applied incorrectly at some point.

What are the DMA zone size and the phys-offset?

	Arnd
