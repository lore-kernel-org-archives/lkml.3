Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365AbaIAASt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 20:18:49 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:41608 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbaIAASo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 20:18:44 -0400
X-Original-SENDERIP: 10.177.222.131
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Mon, 1 Sep 2014 09:19:12 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm/slab: use percpu allocator for cpu cache
Message-ID: <20140901001912.GD25599@js1304-P5Q-DELUXE>
References: <1408608675-20420-1-git-send-email-iamjoonsoo.kim@lge.com>
 <alpine.DEB.2.11.1408271827010.26560@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1408271827010.26560@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 06:37:33PM -0500, Christoph Lameter wrote:
> One minor nit. Otherwise
> 
> Acked-by: Christoph Lameter <cl@linux.com>
> 
> On Thu, 21 Aug 2014, Joonsoo Kim wrote:
> 
> > @@ -2041,56 +1982,63 @@ static size_t calculate_slab_order(struct kmem_cache *cachep,
> >  	return left_over;
> >  }
> >
> > +static int alloc_kmem_cache_cpus(struct kmem_cache *cachep, int entries,
> > +				int batchcount)
> > +{
> > +	cachep->cpu_cache = __alloc_kmem_cache_cpus(cachep, entries,
> > +							batchcount);
> > +	if (!cachep->cpu_cache)
> > +		return 1;
> > +
> > +	return 0;
> > +}
> 
> Do we really need this trivial function? It doesnt do anything useful as
> far as I can tell.

Hello,

You are right. I will remove it in next spin.

Thanks.
