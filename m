Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028AbaIJOmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:42:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43529 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931AbaIJOmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:42:09 -0400
Date: Wed, 10 Sep 2014 16:42:06 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
cc: "Theodore Ts'o" <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] mm/sl[aou]b: make kfree() aware of error pointers
In-Reply-To: <CAPAsAGyYoPjThA1EV46jYiGX2UzqF1oD4JJueNKh9V1XvAXjcA@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1409101640350.5523@pobox.suse.cz>
References: <alpine.LNX.2.00.1409092319370.5523@pobox.suse.cz> <20140909162114.44b3e98cf925f125e84a8a06@linux-foundation.org> <alpine.LNX.2.00.1409100702190.5523@pobox.suse.cz> <20140910140759.GC31903@thunk.org> <alpine.LNX.2.00.1409101613500.5523@pobox.suse.cz>
 <CAPAsAGyYoPjThA1EV46jYiGX2UzqF1oD4JJueNKh9V1XvAXjcA@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2014, Andrey Ryabinin wrote:

> > I of course have no objections to this check being added to whatever
> > static checker, that would be very welcome improvement.
> >
> > Still, I believe that kernel shouldn't be just ignoring kfree(ERR_PTR)
> > happening. Would something like the below be more acceptable?
> >
> >
> >
> > From: Jiri Kosina <jkosina@suse.cz>
> > Subject: [PATCH] mm/sl[aou]b: make kfree() aware of error pointers
> >
> > Freeing if ERR_PTR is not covered by ZERO_OR_NULL_PTR() check already
> > present in kfree(), but it happens in the wild and has disastrous effects.
> >
> > Issue a warning and don't proceed trying to free the memory if
> > CONFIG_DEBUG_SLAB is set.
> >
> 
> This won't work cause CONFIG_DEBUG_SLAB  is only for CONFIG_SLAB=y
> 
> How about just VM_BUG_ON(IS_ERR(ptr)); ?

VM_BUG_ON() makes very little sense to me, as we are going to oops anyway 
later, so it's a lose-lose situation.

VM_WARN_ON() + return seems like much more reasonable choice.

-- 
Jiri Kosina
SUSE Labs
