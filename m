Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab3A2SED (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 13:04:03 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:57178 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751143Ab3A2SD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 13:03:59 -0500
Message-ID: <1359482637.15135.7.camel@joe-AO722>
Subject: Re: coccinelle and bitmask arithmetic (was: Re: [patch] TTY:
 synclink, small cleanup in dtr_rts())
From: Joe Perches <joe@perches.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Russell King <linux@arm.linux.org.uk>, Mike Rapoport <mike@compulab.co.il>,
        Valdis.Kletnieks@vt.edu, cocci@systeme.lip6.fr,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Paul Fulghum <paulkf@microgate.com>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Date: Tue, 29 Jan 2013 10:03:57 -0800
In-Reply-To: <alpine.DEB.2.02.1301291847070.3339@hadrien>
References: <20130127194039.GA18787@elgon.mountain>
	 <1359317078.14406.12.camel@joe-AO722> <20130127201947.GO16282@mwanda>
	 <9561.1359474916@turing-police.cc.vt.edu>
	 <1359475998.4196.26.camel@joe-AO722>
	 <alpine.DEB.2.02.1301291847070.3339@hadrien>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-29 at 18:49 +0100, Julia Lawall wrote:
> How about the following (from today's linux-next).  They appear to be
> trying to do the same calculation, once with + and once with |.

(cc'ing the original developer and Russell King)

Likely the it8152_pci_platform_notify uses should use +

> arch/arm/common/it8152.c
> 
> int dma_set_coherent_mask(struct device *dev, u64 mask)
> {
>         if (mask >= PHYS_OFFSET + SZ_64M - 1)
>                 return 0;
> 
>         return -EIO;
> }
> 
> static int it8152_pci_platform_notify(struct device *dev)
> {
>         if (dev->bus == &pci_bus_type) {
>                 if (dev->dma_mask)
>                         *dev->dma_mask = (SZ_64M - 1) | PHYS_OFFSET;
>                 dev->coherent_dma_mask = (SZ_64M - 1) | PHYS_OFFSET;
>                 dmabounce_register_dev(dev, 2048, 4096, it8152_needs_bounce);
>         }
>         return 0;
> }


