Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab3KEO4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 09:56:18 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:49460 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989Ab3KEO4R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 09:56:17 -0500
Date: Tue, 5 Nov 2013 09:56:07 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
Cc: David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org, Matt Wilson <msw@amazon.com>
Subject: Re: [PATCH] grant-table: don't set m2p override if kmap_ops is not
 set
Message-ID: <20131105145607.GB25836@phenom.dumpdata.com>
References: <1383650649-13971-1-git-send-email-roger.pau@citrix.com>
 <5278E64C.40200@citrix.com>
 <527904EC.9090402@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <527904EC.9090402@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 03:47:08PM +0100, Roger Pau Monné wrote:
> On 05/11/13 13:36, David Vrabel wrote:
> > On 05/11/13 11:24, Roger Pau Monne wrote:
> >> IMHO there's no reason to set a m2p override if the mapping is done in
> >> kernel space, so only set the m2p override when kmap_ops is set.
> > 
> > Can you provide a more detailed reasoning about why this is safe?
> 
> To tell the truth, I don't understand why we need to use the m2p
> override for kernel space only mappings, my understanding is that this
> m2p override is needed for user space mappings only (where we actually
> end up doing two mappings, one in kernel space and one in user space).
> For kernel space I don't see why we need to do anything else than
> setting the right p2m translation.

We needed the m2p when doing DMA operations. As the driver would
want the bus address (so p2m) and then when unmapping the DMA we
only get the bus address  - so we needed to do a m2p lookup.

But perhaps there is a better way to do this in the SWIOTLB code.

> 
> > Did you consider other ways of improving scalability?  e.g., a
> > per-bucket read-write lock.
> 
> Not really, the main focus of this patch is to optimize kernel space
> only mappings (like the ones done in blkback), so why go down this road
> when we can actually remove the need for a lock at all in this case?
