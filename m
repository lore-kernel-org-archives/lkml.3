Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582Ab3LSL0B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:26:01 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:18903 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab3LSLZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:25:57 -0500
X-IronPort-AV: E=Sophos;i="4.95,512,1384300800"; 
   d="scan'208";a="83866104"
Date: Thu, 19 Dec 2013 11:25:22 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Mukesh Rathor <mukesh.rathor@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        <jbeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH v11 05/12] xen/pvh: Update E820 to work with
 PVH
In-Reply-To: <20131218154438.364f6d74@mantra.us.oracle.com>
Message-ID: <alpine.DEB.2.02.1312191124590.8667@kaball.uk.xensource.com>
References: <1387313503-31362-1-git-send-email-konrad.wilk@oracle.com> <1387313503-31362-6-git-send-email-konrad.wilk@oracle.com> <alpine.DEB.2.02.1312181813260.8667@kaball.uk.xensource.com> <20131218154438.364f6d74@mantra.us.oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Dec 2013, Mukesh Rathor wrote:
> On Wed, 18 Dec 2013 18:25:15 +0000
> Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> 
> > On Tue, 17 Dec 2013, Konrad Rzeszutek Wilk wrote:
> > > From: Mukesh Rathor <mukesh.rathor@oracle.com>
> > > 
> > > In xen_add_extra_mem() we can skip updating P2M as it's managed
> > > by Xen. PVH maps the entire IO space, but only RAM pages need
> > > to be repopulated.
> > > 
> > > Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> > > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > > ---
> > >  arch/x86/xen/setup.c | 19 +++++++++++++++++--
> > >  1 file changed, 17 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
> ........
> > > @@ -231,7 +246,7 @@ static void __init
> > > xen_set_identity_and_release_chunk( (void)HYPERVISOR_update_va_mapping(
> > >  			(unsigned long)__va(pfn << PAGE_SHIFT),
> > > pte, 0); }
> > > -
> > > +skip:
> > >  	if (start_pfn < nr_pages)
> > >  		*released += xen_release_chunk(
> > >  			start_pfn, min(end_pfn, nr_pages));
> ... 
> > Also considering that you are turning xen_release_chunk into a nop,
> > the only purpose of this function on PVH is to call
> > set_phys_range_identity. Can't we just do that?
> 
> xen_release_chunk() is called for PVH to give us the count of released,
> altho we don't need to release anything for pvh as it was already done in
> xen. The released count is then used later to add memory.
> 
> I had separate function to just adjust the stats, which is all we need
> to do for pvh, konrad just merged it with pv functions.

I see. I'll let Konrad decide which way is nicer.
