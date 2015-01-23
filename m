Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbbAWXIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 18:08:11 -0500
Received: from mail-oi0-f54.google.com ([209.85.218.54]:60149 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbbAWXII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 18:08:08 -0500
Date: Fri, 23 Jan 2015 17:08:03 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>, cornelia.huck@de.ibm.com,
        linux-pci@vger.kernel.org, trivial@kernel.org,
        David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        linux-am33-list@redhat.com
Subject: Re: [PATCH v3 08/16] mn10300: drop dead code
Message-ID: <20150123230803.GR29776@google.com>
References: <1421256142-11512-1-git-send-email-mst@redhat.com>
 <1421256142-11512-9-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421256142-11512-9-git-send-email-mst@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 07:27:48PM +0200, Michael S. Tsirkin wrote:
> pci-iomap.c was (apparently, mistakenly) reintroduced as part of
> commit 83c2dc15ce824450e7044b9f90cd529c25747ae0
>     MN10300: Handle cacheable PCI regions in pci_iomap()
> probably as side-effect of forward-porting the patch
> from an old kernel.
> 
> It's not really needed: the generic pci_iomap does the right thing here.
> 
> The new file isn't compiled so it's safe to drop.
> 
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: linux-pci@vger.kernel.org
> Cc: trivial@kernel.org
> Cc: David Howells <dhowells@redhat.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
> 
> Can relevant people please ack this for merging through virtio tree?
> 
>  arch/mn10300/unit-asb2305/pci-iomap.c | 35 -----------------------------------
>  1 file changed, 35 deletions(-)
>  delete mode 100644 arch/mn10300/unit-asb2305/pci-iomap.c
> 
> diff --git a/arch/mn10300/unit-asb2305/pci-iomap.c b/arch/mn10300/unit-asb2305/pci-iomap.c
> deleted file mode 100644
> index bd65dae..0000000
> --- a/arch/mn10300/unit-asb2305/pci-iomap.c
> +++ /dev/null
> @@ -1,35 +0,0 @@
> -/* ASB2305 PCI I/O mapping handler
> - *
> - * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
> - * Written by David Howells (dhowells@redhat.com)
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public Licence
> - * as published by the Free Software Foundation; either version
> - * 2 of the Licence, or (at your option) any later version.
> - */
> -#include <linux/pci.h>
> -#include <linux/module.h>
> -
> -/*
> - * Create a virtual mapping cookie for a PCI BAR (memory or IO)
> - */
> -void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
> -{
> -	resource_size_t start = pci_resource_start(dev, bar);
> -	resource_size_t len = pci_resource_len(dev, bar);
> -	unsigned long flags = pci_resource_flags(dev, bar);
> -
> -	if (!len || !start)
> -		return NULL;
> -
> -	if ((flags & IORESOURCE_IO) || (flags & IORESOURCE_MEM)) {
> -		if (flags & IORESOURCE_CACHEABLE && !(flags & IORESOURCE_IO))
> -			return ioremap(start, len);
> -		else
> -			return ioremap_nocache(start, len);
> -	}
> -
> -	return NULL;
> -}
> -EXPORT_SYMBOL(pci_iomap);
> -- 
> MST
> 
