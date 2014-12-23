Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbaLWWnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 17:43:12 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:60051 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbaLWWnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 17:43:10 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Murali Karicheri <m-karicheri2@ti.com>, devicetree@vger.kernel.org,
        linux-pci@vger.kernel.org, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org,
        robh+dt@kernel.org, bhelgaas@google.com,
        Russell King <rmk@arm.linux.org.uk>
Subject: Re: [RFC v1 PATCH 1/2] of/pci: add of_pci_dma_configure() update dma configuration
Date: Tue, 23 Dec 2014 23:42:29 +0100
Message-ID: <4513569.xuD4xkPOuC@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5499A96D.4010704@ti.com>
References: <1418940425-2017-1-git-send-email-m-karicheri2@ti.com> <5090769.jqAkiDgYu7@wuerfel> <5499A96D.4010704@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:D2hIERXHD2GM/Kq2F3evguK9VIZ1cJB0TRv2vwEj/YFOoFUr8Xc
 ugPLvtb9frBBuiC3d3ZnxHa+Bo21qk2r9GKt7pCjKfvtZiGN+iDfVAuBRafTEv+5upEwQQb
 yRQHCKIVRrKJPE8Lz2tx+HQLJohCN6MdwlWRJjJaDJqMHKZWlHHomWQncDbOt4Wf4cwHGJ+
 Ouj+LDiKKJzDjB48FZsuA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 December 2014 12:42:05 Murali Karicheri wrote:
> > here.
> 
> Arnd,
> 
> I guess so. Besides we need to keep the default coherent dma mask to 
> 32bit 0xffffffffull as well to work on Keystone and also in sync with 
> current defaults used in pci_device_add() so that we don't break this 
> behavior.
> 
> Here is the summary of changes need to make on top of my existing patch.
> 
> 1. of_dma_configure() - change size = dev->coherent_dma_mask to size = 
> dev->coherent_dma_mask + 1. This is a new patch to fix existing code.

ok

> 2. Do the above change to of_pci_dma_configure() as well.

ok

> 3. in arch_setup_dma_ops() update the DMA mask to min((*dev->dma_mask), 
> dma_base + size - 1) as
> 
> 
> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> index c17f6a9..88b4769 100644
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -2053,8 +2053,13 @@ void arch_setup_dma_ops(struct device *dev, u64 
> dma_base, u64 size,
>   {
>          struct dma_map_ops *dma_ops;
> 
> +
> +       *dev->dma_mask = min((*dev->dma_mask), (dma_base + size - 1));
> 
> I have tested this on keystone and it works fine with rootfs on PCI SATA 
> harddisk. I will be doing more tests with this change. If you are in 
> agreement with the above changes, I will re-spin the patch to accomodate 
> them and send v1 of the same.

Ok, sounds good. I noticed that you did not put Russell into the Cc list
for the emails. Please do so when you send it again, as he may have some
additional comments.

	Arnd
