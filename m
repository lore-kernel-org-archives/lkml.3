Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849Ab3BVVoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 16:44:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32880 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756988Ab3BVVoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 16:44:20 -0500
Date: Fri, 22 Feb 2013 13:44:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib: devres: Fix misplaced #endif
Message-Id: <20130222134418.a86e78b1.akpm@linux-foundation.org>
In-Reply-To: <000301ce10bf$028176c0$07846440$%han@samsung.com>
References: <000301ce10bf$028176c0$07846440$%han@samsung.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2013 14:39:40 +0900
Jingoo Han <jg1.han@samsung.com> wrote:

> A misplaced #endif causes link errors related to pcim_*() functions.
> 
> --- a/lib/devres.c
> +++ b/lib/devres.c
> @@ -227,6 +227,7 @@ void devm_ioport_unmap(struct device *dev, void __iomem *addr)
>  			       devm_ioport_map_match, (void *)addr));
>  }
>  EXPORT_SYMBOL(devm_ioport_unmap);
> +#endif /* CONFIG_HAS_IOPORT */
>  
>  #ifdef CONFIG_PCI
>  /*
> @@ -432,4 +433,3 @@ void pcim_iounmap_regions(struct pci_dev *pdev, int mask)
>  }
>  EXPORT_SYMBOL(pcim_iounmap_regions);
>  #endif /* CONFIG_PCI */
> -#endif /* CONFIG_HAS_IOPORT */

More details needed, please.  This code is pretty old and it's
surprising that errors are popping up now.

