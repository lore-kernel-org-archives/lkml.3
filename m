Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653AbbAGXiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 18:38:20 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:34958 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740AbbAGXiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 18:38:18 -0500
MIME-Version: 1.0
In-Reply-To: <1420656594-8908-3-git-send-email-m-karicheri2@ti.com>
References: <1420656594-8908-1-git-send-email-m-karicheri2@ti.com> <1420656594-8908-3-git-send-email-m-karicheri2@ti.com>
From: Rob Herring <robherring2@gmail.com>
Date: Wed, 7 Jan 2015 17:37:56 -0600
Message-ID: <CAL_Jsq+pKeXuGnZV_NYHn6iZgeOs404OPhcUb0FJs=-7j2P1Ug@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] of: move of_dma_configure() to device,c to help re-use
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: Joerg Roedel <joro@8bytes.org>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2015 at 12:49 PM, Murali Karicheri <m-karicheri2@ti.com> wrote:
> Move of_dma_configure() to device.c so that same function can be re-used
> for PCI devices to obtain DMA configuration from DT. Also add a second
> argument so that for PCI, DT node of root bus host bridge can be used to
> obtain the DMA configuration for the slave PCI device. Additionally fix
> the dma-range size when the DT attribute is missing. i.e  set size to
> dev->coherent_dma_mask + 1 instead of dev->coherent_dma_mask.

Additionally is a red flag for put in another patch. There is an issue
I think as well.

> +       ret = of_dma_get_range(np, &dma_addr, &paddr, &size);
> +       if (ret < 0) {
> +               dma_addr = offset = 0;
> +               size = dev->coherent_dma_mask + 1;

If coherent_dma_mask is DMA_BIT_MASK(64), then you will overflow and
have a size of 0. There may also be a problem when the mask is only
32-bit type.

Rob
