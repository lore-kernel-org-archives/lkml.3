Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758958Ab3D2Sqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 14:46:51 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:28482 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759333Ab3D2Shs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 14:37:48 -0400
Date: Mon, 29 Apr 2013 14:37:41 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Roger Pau Monne <roger.pau@citrix.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen-blkback: allocate list of pending reqs in small
 chunks
Message-ID: <20130429183741.GE9431@phenom.dumpdata.com>
References: <1366983947-54578-1-git-send-email-roger.pau@citrix.com>
 <517A938C.6060703@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <517A938C.6060703@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 03:47:40PM +0100, David Vrabel wrote:
> On 26/04/13 14:45, Roger Pau Monne wrote:
> > Allocate pending requests in smaller chunks instead of allocating them
> > all at the same time.
> > 
> > This change also removes the global array of pending_reqs, it is no
> > longer necessay.
> > 
> > Variables related to the grant mapping have been grouped into a struct
> > called "grant_page", this allows to allocate them in smaller chunks,
> > and also improves memory locality.
> > 
> [...]
> > diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
> > index afab208..2841c0f 100644
> > --- a/drivers/block/xen-blkback/xenbus.c
> > +++ b/drivers/block/xen-blkback/xenbus.c
> > @@ -127,22 +128,53 @@ static struct xen_blkif *xen_blkif_alloc(domid_t domid)
> >         blkif->free_pages_num = 0;
> >         atomic_set(&blkif->persistent_gnt_in_use, 0);
> > 
> > -       blkif->pending_reqs = kcalloc(XEN_BLKIF_REQS,
> > -                                     sizeof(blkif->pending_reqs[0]),
> > -                                     GFP_KERNEL);
> > -       if (!blkif->pending_reqs) {
> > -               kmem_cache_free(xen_blkif_cachep, blkif);
> > -               return ERR_PTR(-ENOMEM);
> > -       }
> >         INIT_LIST_HEAD(&blkif->pending_free);
> > +
> > +       pr_alert("sizeof req: %lu\n", sizeof(*req));
> 
> Stray pr_alert() here.
> 
> Looks good otherwise.
> 
> Reviewed-by: David Vrabel <david.vrabel@citrix.com>

Roger, could you repost it please and also include Tested-by: Sander.. on it
please?
> 
> David
