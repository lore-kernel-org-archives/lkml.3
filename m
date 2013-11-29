Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab3K2MXA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 07:23:00 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:25636 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756107Ab3K2MW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 07:22:57 -0500
X-IronPort-AV: E=Sophos;i="4.93,797,1378857600"; 
   d="scan'208";a="76795586"
Date: Fri, 29 Nov 2013 12:22:40 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Matt Wilson <msw@linux.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xenproject.org>, Matt Wilson <msw@amazon.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Anthony Liguori <aliguori@amazon.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen/gnttab: leave lazy MMU mode in the case of a m2p
 override failure
In-Reply-To: <20131122152110.GA3124@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1311291222150.3198@kaball.uk.xensource.com>
References: <1384978295-18292-1-git-send-email-msw@linux.com> <20131122152110.GA3124@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Nov 2013, Konrad Rzeszutek Wilk wrote:
> On Wed, Nov 20, 2013 at 12:11:35PM -0800, Matt Wilson wrote:
> > From: Matt Wilson <msw@amazon.com>
> > 
> > Commit f62805f1 introduced a bug where lazy MMU mode isn't exited if a
> > m2p_add/remove_override call fails.
> 
> Stefano?
> 

Already acked here:

http://marc.info/?l=linux-kernel&m=138505917602905&w=2



> > Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> > Cc: David Vrabel <david.vrabel@citrix.com>
> > Cc: Anthony Liguori <aliguori@amazon.com>
> > Cc: xen-devel@lists.xenproject.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Matt Wilson <msw@amazon.com>
> > ---
> >  drivers/xen/grant-table.c |    6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
> > index 62ccf54..0283871 100644
> > --- a/drivers/xen/grant-table.c
> > +++ b/drivers/xen/grant-table.c
> > @@ -930,9 +930,10 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
> >  		ret = m2p_add_override(mfn, pages[i], kmap_ops ?
> >  				       &kmap_ops[i] : NULL);
> >  		if (ret)
> > -			return ret;
> > +			goto out;
> >  	}
> >  
> > + out:
> >  	if (lazy)
> >  		arch_leave_lazy_mmu_mode();
> >  
> > @@ -969,9 +970,10 @@ int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
> >  		ret = m2p_remove_override(pages[i], kmap_ops ?
> >  				       &kmap_ops[i] : NULL);
> >  		if (ret)
> > -			return ret;
> > +			goto out;
> >  	}
> >  
> > + out:
> >  	if (lazy)
> >  		arch_leave_lazy_mmu_mode();
> >  
> > -- 
> > 1.7.9.5
> > 
> 
