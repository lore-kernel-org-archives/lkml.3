Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbaLOOQH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:16:07 -0500
Received: from resqmta-po-05v.sys.comcast.net ([96.114.154.164]:50810 "EHLO
	resqmta-po-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751181AbaLOOQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:16:04 -0500
Date: Mon, 15 Dec 2014 08:16:00 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-mm@kvack.org, penberg@kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH 3/7] slub: Do not use c->page on free
In-Reply-To: <20141215080338.GE4898@js1304-P5Q-DELUXE>
Message-ID: <alpine.DEB.2.11.1412150815210.20101@gentwo.org>
References: <20141210163017.092096069@linux.com> <20141210163033.717707217@linux.com> <20141215080338.GE4898@js1304-P5Q-DELUXE>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Dec 2014, Joonsoo Kim wrote:

> > +static bool same_slab_page(struct kmem_cache *s, struct page *page, void *p)
> > +{
> > +	long d = p - page->address;
> > +
> > +	return d > 0 && d < (1 << MAX_ORDER) && d < (compound_order(page) << PAGE_SHIFT);
> > +}
> > +
>
> Somtimes, compound_order() induces one more cacheline access, because
> compound_order() access second struct page in order to get order. Is there
> any way to remove this?

I already have code there to avoid the access if its within a MAX_ORDER
page. We could probably go for a smaller setting there. PAGE_COSTLY_ORDER?

