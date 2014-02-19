Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbaBSMjL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 07:39:11 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36396 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbaBSMjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 07:39:06 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-6b-5304a5e72811
Message-id: <5304A5E5.40706@samsung.com>
Date: Wed, 19 Feb 2014 13:39:01 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Olof Johansson <olof@lixom.net>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>
Subject: Re: [PATCH v3 3/6] drivers: of: implement reserved-memory handling for
 dma
References: <1392730681-14695-1-git-send-email-m.szyprowski@samsung.com>
 <1392730681-14695-4-git-send-email-m.szyprowski@samsung.com>
 <20140218165815.C7661C40517@trevor.secretlab.ca>
In-reply-to: <20140218165815.C7661C40517@trevor.secretlab.ca>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYRjHe895z3Ycrk5L483KYCBIpKlJvZhFEMXbhyAzK/qiR10qeN1J
	075kQ0VNpyg6G2oKjsprTcELWd7wkhcyb+QNL2Hm5hLNCN1Gzn3x2+95/v//8//wsLSsD7qw
	UbFPFMpYPlouksBBa9+4x08dDPSaqTuJLQW9YryhSqfx654RBucZKxncYW4B2JibCXFrvQng
	YZVRjJuzSsT4z/gihfXLkwyuzKiCeKytVITf/+qksG5qlMIVfWkMNmtc8ZepLRHO19RBnN7e
	I8aWZj3Ea50ZEDeUGCCubjODa4jUltcCsrtTAIihMB+QMXUuRVq1c2KSY0xjiL46S0RmJz+K
	SGPVczJjXabJeL+KIfXmNYrkWbyIuqkakC29K/lQFnSHeyTxD1dERyUplOevhkgi1WlvYHyL
	W/K7xiGQCkyns4EDizhf9MpUA+18HH2dbxBlAwkr43QAVb1cYWyCjNsEaGHnqY2lnDtaqzKJ
	bAw5N5RbvLkfFnHeKHs9e2/Pss5cECov87Tbj6J/hfPQdtOJGwDI2q4W2waa+8SggW87+4eO
	7QUMP6zA3twGUOqgHtgEB+4KmptuomxMcxfRUlo9beczqLF2nc4HnPZAi/aATXvAVgHoauCs
	SAyLF0IjYnw8BT5GSIyN8AyLi9ED+/O3W4Cu168LcCyQO0rJKh0oY/gkISWmCyCWljtJl4pg
	oEwazqc8UyjjgpWJ0QqhC1Csg0sqqKtx3F0N0If/fTBr7bz7WMu3x/lMvHWu6aeGhYL120nd
	IZ9HJu895N1h8Ix3941DSYv3F1z5be9LhnMbE361sE+SYNIFCKekxRoheEWl8V0uVhp/K4LC
	B901R9J9/L/HXrbcSjYm3Mx06rjOnhgtDZ0eapG/MOR4sNThoQtFcihE8t5naaXA/wfZPjNJ
	2gIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-02-18 17:58, Grant Likely wrote:
> On Tue, 18 Feb 2014 14:37:58 +0100, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> > From: Josh Cartwright <joshc@codeaurora.org>
> >
> > Add support for handling 'shared-dma-pool' reserved-memory nodes using
> > dma exclusive driver (dma_alloc_coherent()).
> >
> > Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > ---
> >  drivers/of/Kconfig               |    7 ++++
> >  drivers/of/Makefile              |    1 +
> >  drivers/of/of_reserved_mem_dma.c |   65 ++++++++++++++++++++++++++++++++++++++
>
> I don't see any reason to have this separate from of_reserved_mem.c

Some architectures don't have support for dma_declare_coherent_memory()
(CONFIG_HAVE_GENERIC_DMA_COHERENT), good examples are arc, c6x, metag 
and extensa.
This code will not work for them.

> >  3 files changed, 73 insertions(+)
> >  create mode 100644 drivers/of/of_reserved_mem_dma.c
> >
> > diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
> > index f25931dfc6db..7f00b801bcd2 100644
> > --- a/drivers/of/Kconfig
> > +++ b/drivers/of/Kconfig
> > @@ -80,4 +80,11 @@ config OF_RESERVED_MEM
> >  	help
> >  	  Helpers to allow for reservation of memory regions
> >
> > +config OF_RESERVED_MEM_DMA
> > +	depends on OF_RESERVED_MEM
> > +	depends on HAVE_GENERIC_DMA_COHERENT
> > +	def_bool y
> > +	help
> > +	  Helpers for reserving memory regions for DMA use
> > +
> >  endmenu # OF
> > diff --git a/drivers/of/Makefile b/drivers/of/Makefile
> > index ed9660adad77..6142227ca854 100644
> > --- a/drivers/of/Makefile
> > +++ b/drivers/of/Makefile
> > @@ -10,3 +10,4 @@ obj-$(CONFIG_OF_PCI)	+= of_pci.o
> >  obj-$(CONFIG_OF_PCI_IRQ)  += of_pci_irq.o
> >  obj-$(CONFIG_OF_MTD)	+= of_mtd.o
> >  obj-$(CONFIG_OF_RESERVED_MEM) += of_reserved_mem.o
> > +obj-$(CONFIG_OF_RESERVED_MEM_DMA) += of_reserved_mem_dma.o
> > diff --git a/drivers/of/of_reserved_mem_dma.c b/drivers/of/of_reserved_mem_dma.c
> > new file mode 100644
> > index 000000000000..a3e596d1091d
> > --- /dev/null
> > +++ b/drivers/of/of_reserved_mem_dma.c
> > @@ -0,0 +1,65 @@
> > +/*
> > + * Device tree based initialization code for DMA reserved regions.
> > + *
> > + * Copyright (c) 2013, The Linux Foundation. All Rights Reserved.
> > + * Copyright (c) 2013,2014 Samsung Electronics Co., Ltd.
> > + *		http://www.samsung.com
> > + * Author: Marek Szyprowski <m.szyprowski@samsung.com>
> > + * Author: Josh Cartwright <joshc@codeaurora.org>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License as
> > + * published by the Free Software Foundation; either version 2 of the
> > + * License or (at your optional) any later version of the license.
> > + */
> > +#include <linux/memblock.h>
> > +#include <linux/err.h>
> > +#include <linux/of.h>
> > +#include <linux/of_fdt.h>
> > +#include <linux/of_platform.h>
> > +#include <linux/mm.h>
> > +#include <linux/sizes.h>
> > +#include <linux/mm_types.h>
> > +#include <linux/dma-mapping.h>
> > +#include <linux/of_reserved_mem.h>
> > +
> > +static void rmem_dma_device_init(struct reserved_mem *rmem,
> > +				 struct device *dev,
> > +				 struct of_phandle_args *args)
> > +{
> > +	dma_declare_coherent_memory(dev, rmem->base, rmem->base,
> > +		rmem->size, DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE);
> > +}
> > +
> > +static void rmem_dma_device_release(struct reserved_mem *rmem,
> > +				    struct device *dev)
> > +{
> > +	dma_release_declared_memory(dev);
> > +}
> > +
> > +static const struct reserved_mem_ops rmem_dma_ops = {
> > +	.device_init	= rmem_dma_device_init,
> > +	.device_release	= rmem_dma_device_release,
> > +};
> > +
> > +static int __init rmem_dma_setup(struct reserved_mem *rmem,
> > +				 unsigned long node,
> > +				 const char *uname)
> > +{
> > +	int err;
> > +
> > +	if (of_get_flat_dt_prop(node, "reusable", NULL))
> > +		return -EINVAL;
> > +
> > +	err = memblock_remove(rmem->base, rmem->size);
>
> Isn't the memblock_remove() now handled by the core code? Or am I
> mis-reading it?

I forgot to remove it...

> > +	if (err == 0) {
> > +		rmem->ops = &rmem_dma_ops;
> > +		pr_info("Reserved memory: created DMA memory pool at %pa, size %ld MiB\n",
> > +			&rmem->base, (unsigned long)rmem->size / SZ_1M);
> > +	} else {
> > +		pr_err("Reserved memory: unable to setup '%s' memory region for DMA.\n",
> > +		       uname);
> > +	}
> > +	return err;
> > +}
> > +RESERVEDMEM_OF_DECLARE(dma, "shared-dma-pool", rmem_dma_setup);
> > --
> > 1.7.9.5
> >

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

