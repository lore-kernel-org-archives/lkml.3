Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab3LRXpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 18:45:52 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:30839 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab3LRXpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 18:45:51 -0500
Date: Wed, 18 Dec 2013 15:44:38 -0800
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        <jbeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH v11 05/12] xen/pvh: Update E820 to work with
 PVH
Message-ID: <20131218154438.364f6d74@mantra.us.oracle.com>
In-Reply-To: <alpine.DEB.2.02.1312181813260.8667@kaball.uk.xensource.com>
References: <1387313503-31362-1-git-send-email-konrad.wilk@oracle.com>
	<1387313503-31362-6-git-send-email-konrad.wilk@oracle.com>
	<alpine.DEB.2.02.1312181813260.8667@kaball.uk.xensource.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.18.9; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Dec 2013 18:25:15 +0000
Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:

> On Tue, 17 Dec 2013, Konrad Rzeszutek Wilk wrote:
> > From: Mukesh Rathor <mukesh.rathor@oracle.com>
> > 
> > In xen_add_extra_mem() we can skip updating P2M as it's managed
> > by Xen. PVH maps the entire IO space, but only RAM pages need
> > to be repopulated.
> > 
> > Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  arch/x86/xen/setup.c | 19 +++++++++++++++++--
> >  1 file changed, 17 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
........
> > @@ -231,7 +246,7 @@ static void __init
> > xen_set_identity_and_release_chunk( (void)HYPERVISOR_update_va_mapping(
> >  			(unsigned long)__va(pfn << PAGE_SHIFT),
> > pte, 0); }
> > -
> > +skip:
> >  	if (start_pfn < nr_pages)
> >  		*released += xen_release_chunk(
> >  			start_pfn, min(end_pfn, nr_pages));
... 
> Also considering that you are turning xen_release_chunk into a nop,
> the only purpose of this function on PVH is to call
> set_phys_range_identity. Can't we just do that?

xen_release_chunk() is called for PVH to give us the count of released,
altho we don't need to release anything for pvh as it was already done in
xen. The released count is then used later to add memory.

I had separate function to just adjust the stats, which is all we need
to do for pvh, konrad just merged it with pv functions.

thanks
mukesh
