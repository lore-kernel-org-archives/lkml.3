Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab3ARPzt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 10:55:49 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:51751 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab3ARPzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 10:55:47 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH v2 28/76] ARC: I/O and DMA Mappings
Date: Fri, 18 Jan 2013 15:55:43 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <1358511930-7424-29-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1358511930-7424-29-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301181555.43487.arnd@arndb.de>
X-Provags-ID: V02:K0:L1ZxYKdDXewIyBJIT6oNc2UoVbphKX8jMzmXaJ0QEke
 ShGtdj0CyRExT0HtZxXg7BiUBpIyD+2oe8bHQVvlFHyonpzDwn
 s5TDvFJcsLZ2rRNyQ6CyL9BsmJMowmdwtPV+9kbxe2Uf728uJE
 ygIEq4/4QXqauKOkpK3Zb5EI4RrVxZnYR5zLQzdYQopaKw/27D
 MPsgbEzagrPxEbPA40t3rf2SSYmnUo1y9RcfJfeTCQ1HUzlV4U
 5cmoVhoL5QxvtDSzQX640aou5q3KezPsNSeDh10hg/f4wKyr/X
 BFeY0cnR5DsdBdQHKdzmf2z5XpUQSPQs3UApHTZS9m8wIznYmv
 FwAMwMNpqxDn99LXqcKM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2013, Vineet Gupta wrote:
> TBD: Do we need early ioremap support like openrisc
> 
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>

Can you explain why early ioremap is necessary for you?

I wasn't aware that openrisc has it. In a lot of cases,
you can use fixmap as a replacement.

> +
> +#ifndef _ASM_ARC_IO_H
> +#define _ASM_ARC_IO_H
> +
> +#include <asm/byteorder.h>
> +#include <asm/page.h>
> +
> +extern void __iomem *ioremap(unsigned long physaddr, unsigned long size);
> +extern void iounmap(const void __iomem *addr);
> +
> +#define ioremap_nocache(phy, sz)	ioremap(phy, sz)
> +#define ioremap_wc(phy, sz)		ioremap(phy, sz)
> +
> +/* Change struct page to physical address */
> +#define page_to_phys(page)		(page_to_pfn(page) << PAGE_SHIFT)
> +
> +#include <asm-generic/io.h>

I think I commented before that asm-generic/io.h has a number of
problems and you should at least override the __raw_{read,write}{b,w,l,q}
functions with your own ones using inline assembly.

You should also define a non-NULL PCI_IOBASE.

	Arnd
