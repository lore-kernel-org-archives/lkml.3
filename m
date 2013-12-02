Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab3LBVox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:44:53 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:46778 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab3LBVov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 16:44:51 -0500
Date: Mon, 2 Dec 2013 16:43:40 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Matt Wilson <msw@linux.com>, xen-devel@lists.xenproject.org,
        Matt Wilson <msw@amazon.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Anthony Liguori <aliguori@amazon.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen/gnttab: leave lazy MMU mode in the case of a m2p
 override failure
Message-ID: <20131202214340.GA12852@phenom.dumpdata.com>
References: <1384978295-18292-1-git-send-email-msw@linux.com>
 <20131122152110.GA3124@phenom.dumpdata.com>
 <alpine.DEB.2.02.1311291222150.3198@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311291222150.3198@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 12:22:40PM +0000, Stefano Stabellini wrote:
> On Fri, 22 Nov 2013, Konrad Rzeszutek Wilk wrote:
> > On Wed, Nov 20, 2013 at 12:11:35PM -0800, Matt Wilson wrote:
> > > From: Matt Wilson <msw@amazon.com>
> > > 
> > > Commit f62805f1 introduced a bug where lazy MMU mode isn't exited if a
> > > m2p_add/remove_override call fails.
> > 
> > Stefano?
> > 
> 
> Already acked here:
> 
> http://marc.info/?l=linux-kernel&m=138505917602905&w=2

Sent to Linus today.

Thank you!
> 
> 
> 
> > > Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > > Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > > Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> > > Cc: David Vrabel <david.vrabel@citrix.com>
> > > Cc: Anthony Liguori <aliguori@amazon.com>
> > > Cc: xen-devel@lists.xenproject.org
> > > Cc: linux-kernel@vger.kernel.org
> > > Signed-off-by: Matt Wilson <msw@amazon.com>
> > > ---
> > >  drivers/xen/grant-table.c |    6 ++++--
> > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
> > > index 62ccf54..0283871 100644
> > > --- a/drivers/xen/grant-table.c
> > > +++ b/drivers/xen/grant-table.c
> > > @@ -930,9 +930,10 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
> > >  		ret = m2p_add_override(mfn, pages[i], kmap_ops ?
> > >  				       &kmap_ops[i] : NULL);
> > >  		if (ret)
> > > -			return ret;
> > > +			goto out;
> > >  	}
> > >  
> > > + out:
> > >  	if (lazy)
> > >  		arch_leave_lazy_mmu_mode();
> > >  
> > > @@ -969,9 +970,10 @@ int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
> > >  		ret = m2p_remove_override(pages[i], kmap_ops ?
> > >  				       &kmap_ops[i] : NULL);
> > >  		if (ret)
> > > -			return ret;
> > > +			goto out;
> > >  	}
> > >  
> > > + out:
> > >  	if (lazy)
> > >  		arch_leave_lazy_mmu_mode();
> > >  
> > > -- 
> > > 1.7.9.5
> > > 
> > 
