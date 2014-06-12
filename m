Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933118AbaFLKDz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 06:03:55 -0400
Received: from mx2.parallels.com ([199.115.105.18]:51292 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932878AbaFLKDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 06:03:54 -0400
Date: Thu, 12 Jun 2014 14:03:46 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: <akpm@linux-foundation.org>, <cl@linux.com>, <rientjes@google.com>,
        <penberg@kernel.org>, <hannes@cmpxchg.org>, <mhocko@suse.cz>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH -mm v2 5/8] slub: make slab_free non-preemptable
Message-ID: <20140612100344.GB19221@esperanza>
References: <cover.1402060096.git.vdavydov@parallels.com>
 <7cd6784a36ed997cc6631615d98e11e02e811b1b.1402060096.git.vdavydov@parallels.com>
 <20140612065842.GE19918@js1304-P5Q-DELUXE>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140612065842.GE19918@js1304-P5Q-DELUXE>
X-Originating-IP: [81.5.110.170]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jun 12, 2014 at 03:58:42PM +0900, Joonsoo Kim wrote:
> On Fri, Jun 06, 2014 at 05:22:42PM +0400, Vladimir Davydov wrote:
> > @@ -2673,18 +2673,11 @@ static __always_inline void slab_free(struct kmem_cache *s,
> >  
> >  	slab_free_hook(s, x);
> >  
> > -redo:
> > -	/*
> > -	 * Determine the currently cpus per cpu slab.
> > -	 * The cpu may change afterward. However that does not matter since
> > -	 * data is retrieved via this pointer. If we are on the same cpu
> > -	 * during the cmpxchg then the free will succedd.
> > -	 */
> >  	preempt_disable();
> 
> Could you add some code comment why this preempt_disable/enable() is
> needed? We don't have any clue that kmemcg depends on these things
> on code, so someone cannot understand why it is here.
> 
> If possible, please add similar code comment on slab_alloc in mm/slab.c.

Sure.

Thanks.
