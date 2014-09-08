Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458AbaIHQQc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 12:16:32 -0400
Received: from resqmta-po-11v.sys.comcast.net ([96.114.154.170]:47744 "EHLO
	resqmta-po-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753922AbaIHQQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 12:16:31 -0400
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Sep 2014 12:16:31 EDT
Date: Mon, 8 Sep 2014 11:10:22 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Mikulas Patocka <mpatocka@redhat.com>
cc: Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, "Alasdair G. Kergon" <agk@redhat.com>,
        Mike Snitzer <msnitzer@redhat.com>, Milan Broz <gmazyland@gmail.com>,
        kkolasa@winsoft.pl, dm-devel@redhat.com
Subject: Re: [PATCH] slab: implement kmalloc guard
In-Reply-To: <alpine.LRH.2.02.1409081041160.29432@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.DEB.2.11.1409081108190.20388@gentwo.org>
References: <alpine.LRH.2.02.1409051833510.9790@file01.intranet.prod.int.rdu2.redhat.com> <alpine.DEB.2.11.1409080932490.20388@gentwo.org> <alpine.LRH.2.02.1409081041160.29432@file01.intranet.prod.int.rdu2.redhat.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Sep 2014, Mikulas Patocka wrote:

> I don't know what you mean. If someone allocates 10000 objects with sizes
> from 1 to 10000, you can't have 10000 slab caches - you can't have a slab
> cache for each used size. Also - you can't create a slab cache in
> interrupt context.

Oh you can create them up front on bootup. And I think only the small
sizes matter. Allocations >=8K are pushed to the page allocator anyways.

> > We already have a redzone structure to check for writes over the end of
> > the object. Lets use that.
>
> So, change all three slab subsystems to use that.

SLOB has no debugging features and I think that was intentional. We are
trying to unify the debug checks etc. Some work on that would be
appreciated. I think the kmalloc creation is already in slab_common.c

