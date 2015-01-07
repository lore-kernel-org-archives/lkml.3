Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbbAGXGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 18:06:30 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:43732 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbbAGXGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 18:06:25 -0500
Message-ID: <54ADBBCF.8020206@ti.com>
Date: Wed, 7 Jan 2015 18:05:51 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Murali Karicheri <m-karicheri2@ti.com>, <bhelgaas@google.com>
CC: <joro@8bytes.org>, <grant.likely@linaro.org>, <robh+dt@kernel.org>,
        <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <will.deacon@arm.com>,
        <linux@arm.linux.org.uk>, <arnd@arndb.de>
Subject: Re: [PATCH v3 0/4] PCI: get DMA configuration from parent device
References: <1420656594-8908-1-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1420656594-8908-1-git-send-email-m-karicheri2@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2015 01:49 PM, Murali Karicheri wrote:
> PCI devices on Keystone doesn't have correct dma_pfn_offset set. This patch
> add capability to set the dma configuration such as dma-mask, dma_pfn_offset,
> and dma ops etc using the information from DT. The prior RFCs and discussions
> are available at [1] and [2] below.
>
> [2] : https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg790244.html
> [1] : http://www.gossamer-threads.com/lists/linux/kernel/2024591
>
> Change history:
> 	v3 - addressed comments to re-use of_dma_configure() for PCI
> 	   - To help re-use, change of_iommu_configure() function argument
> 		- Move of_dma_configure to of/device.c
> 		- Limit the of_iommu_configure to non pci devices
> 	v2 - update size to coherent_dma_mask + 1 if dma-range info is missing
> 	   - also check the np for null.
> 	v1 - updates based on the comments against initial RFC.
> 	   - Added a helper function to get the OF node of the parent
> 	   - Added an API in of_pci.c to update DMA configuration of the pci
> 	     device.
>
> Murali Karicheri (4):
>    of: iommu: add ptr to OF node arg to of_iommu_configure()
>    of: move of_dma_configure() to device,c to help re-use
>    of/pci: add of_pci_dma_configure() update dma configuration
>    PCI: update dma configuration from DT
>
>   drivers/iommu/of_iommu.c  |   10 ++++++--
>   drivers/of/device.c       |   58 +++++++++++++++++++++++++++++++++++++++++++++
>   drivers/of/of_pci.c       |   39 ++++++++++++++++++++++++++++++
>   drivers/of/platform.c     |   58 ++-------------------------------------------
>   drivers/pci/probe.c       |    2 ++
>   include/linux/of_device.h |    2 ++
>   include/linux/of_iommu.h  |    6 +++--
>   include/linux/of_pci.h    |   12 ++++++++++
>   8 files changed, 127 insertions(+), 60 deletions(-)
>
Bjorn,

Could you review this series from the PCI subsystem point of view?

Thanks
-- 
Murali Karicheri
Linux Kernel, Texas Instruments
