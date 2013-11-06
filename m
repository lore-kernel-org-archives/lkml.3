Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab3KFR7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 12:59:42 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:46939 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174Ab3KFR7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 12:59:41 -0500
Date: Wed, 6 Nov 2013 09:59:34 -0800
From: Matt Wilson <msw@linux.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>,
        Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xen.org, Matt Wilson <msw@amazon.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [PATCH] grant-table: don't set m2p override if
 kmap_ops is not set
Message-ID: <20131106175934.GA18002@u109add4315675089e695.ant.amazon.com>
References: <1383650649-13971-1-git-send-email-roger.pau@citrix.com>
 <5278E64C.40200@citrix.com>
 <527904EC.9090402@citrix.com>
 <20131105145607.GB25836@phenom.dumpdata.com>
 <5279085E.7070703@citrix.com>
 <1383664090.13961.88.camel@kazak.uk.xensource.com>
 <527916EE.6060104@citrix.com>
 <20131105200616.GA23362@u109add4315675089e695.ant.amazon.com>
 <878ux2vade.fsf@codemonkey.ws>
 <527A2943.7050400@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527A2943.7050400@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 11:34:27AM +0000, David Vrabel wrote:
[...]
> 
> Matt, Anthony, I presume you have profiling results or performance data
> that support this proposed change?  Can you provide them?

I've measured 10-20% performance improvement in configurations where:

1) dom0 has a moderate number of vCPUs doing blkback work
2) domU has 32 vCPUs
3) 24 configured VBDs without persistent grant support
4) some lock contention in grant table hypercalls has been alleviated

More specific results are still in the works.

> > It's perfectly fine to store a foreign pfn in the m2p table.  The m2p
> > override table is used by the grant device to allow a reverse lookup of
> > the real mfn to a pfn even if it's foreign.
> > 
> > blkback doesn't actually need this though.  This was introduced in:
> > 
> > commit 5dc03639cc903f887931831d69895facb5260f4b
> > Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > Date:   Tue Mar 1 16:46:45 2011 -0500
> > 
> >     xen/blkback: Utilize the M2P override mechanism for GNTMAP_host_map
> > 
> > Purely as an optimization.  In practice though due to lock contention it
> > slows things down.
> 
> The full changeset description for this change doesn't make sense to me.
> 
>     xen/blkback: Utilize the M2P override mechanism for GNTMAP_host_map
> 
>     Instead of doing copy grants lets do mapping grants using
>     the M2P(and P2M) override mechanism.
> 
> As all it is doing is replacing set_phys_to_machine() calls with
> m2p_add_override().

Indeed, since this had nothing to do with copying. We were confused
also. Konrad?

--msw
