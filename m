Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbaBLImP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:42:15 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:55288 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbaBLImM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:42:12 -0500
Date: Wed, 12 Feb 2014 11:38:50 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/4] zram: introduce compressing backend abstraction
Message-ID: <20140212083849.GA2176@swordfish>
References: <1392157266-13488-1-git-send-email-sergey.senozhatsky@gmail.com>
 <1392157266-13488-2-git-send-email-sergey.senozhatsky@gmail.com>
 <20140212070832.GC19818@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212070832.GC19818@bbox>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (02/12/14 16:08), Minchan Kim wrote:
[..]
> > +#include <linux/kernel.h>
> > +#include <linux/string.h>
> > +#include <linux/slab.h>
> > +#include <linux/vmalloc.h>
> > +#include <linux/wait.h>
> > +#include <linux/sched.h>
> > +
> > +#include "zram_comp.h"
> > +
> > +extern struct zram_comp_backend zcomp_lzo;
> > +
> > +static void workmem_free(struct zram_comp *comp, struct zcomp_workmem *workmem)
> > +{
> > +	comp->backend->destroy(workmem->private);
> > +	free_pages((unsigned long)workmem->buffer, 1);
> > +	kfree(workmem);
> > +}
> > +
> > +/* allocate new workmem structure with ->mem of requested size,
> > + * return NULL on error */
> > +static struct zcomp_workmem *workmem_alloc(struct zram_comp *comp)
> > +{
> > +	struct zcomp_workmem *workmem = kmalloc(sizeof(*workmem), GFP_NOFS);
> 
> 
> One more thing, pz, say why we need GFP_NOFS in here.
>

my bad. it definitely should be GFP_KERNEL.

	-ss
