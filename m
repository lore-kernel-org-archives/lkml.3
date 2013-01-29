Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab3A2RtJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 12:49:09 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:43261 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754428Ab3A2RtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 12:49:04 -0500
X-IronPort-AV: E=Sophos;i="4.84,561,1355094000"; 
   d="scan'208";a="521231"
Date: Tue, 29 Jan 2013 18:49:02 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Joe Perches <joe@perches.com>
cc: Valdis.Kletnieks@vt.edu, cocci@systeme.lip6.fr,
        Julia Lawall <julia.lawall@lip6.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Paul Fulghum <paulkf@microgate.com>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: coccinelle and bitmask arithmetic (was: Re: [patch] TTY: synclink,
 small cleanup in dtr_rts())
In-Reply-To: <1359475998.4196.26.camel@joe-AO722>
Message-ID: <alpine.DEB.2.02.1301291847070.3339@hadrien>
References: <20130127194039.GA18787@elgon.mountain>  <1359317078.14406.12.camel@joe-AO722> <20130127201947.GO16282@mwanda>  <9561.1359474916@turing-police.cc.vt.edu> <1359475998.4196.26.camel@joe-AO722>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How about the following (from today's linux-next).  They appear to be
trying to do the same calculation, once with + and once with |.

arch/arm/common/it8152.c

int dma_set_coherent_mask(struct device *dev, u64 mask)
{
        if (mask >= PHYS_OFFSET + SZ_64M - 1)
                return 0;

        return -EIO;
}

static int it8152_pci_platform_notify(struct device *dev)
{
        if (dev->bus == &pci_bus_type) {
                if (dev->dma_mask)
                        *dev->dma_mask = (SZ_64M - 1) | PHYS_OFFSET;
                dev->coherent_dma_mask = (SZ_64M - 1) | PHYS_OFFSET;
                dmabounce_register_dev(dev, 2048, 4096, it8152_needs_bounce);
        }
        return 0;
}

julia
