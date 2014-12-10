Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027AbaLJRIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 12:08:32 -0500
Received: from resqmta-po-11v.sys.comcast.net ([96.114.154.170]:35707 "EHLO
	resqmta-po-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756901AbaLJRIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 12:08:30 -0500
Date: Wed, 10 Dec 2014 11:08:28 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Pekka Enberg <penberg@kernel.org>
cc: akpm <akpm@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, iamjoonsoo@lge.com,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH 3/7] slub: Do not use c->page on free
In-Reply-To: <CAOJsxLFEN_w7q6NvbxkH2KTujB9auLkQgskLnGtN9iBQ4hV9sw@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1412101107350.6291@gentwo.org>
References: <20141210163017.092096069@linux.com> <20141210163033.717707217@linux.com> <CAOJsxLFEN_w7q6NvbxkH2KTujB9auLkQgskLnGtN9iBQ4hV9sw@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2014, Pekka Enberg wrote:

> > +static bool same_slab_page(struct kmem_cache *s, struct page *page, void *p)
>
> Why are you passing a pointer to struct kmem_cache here? You don't
> seem to use it.

True.
> > +{
> > +       long d = p - page->address;
> > +
> > +       return d > 0 && d < (1 << MAX_ORDER) && d < (compound_order(page) << PAGE_SHIFT);
> > +}
>
> Can you elaborate on what this is doing? I don't really understand it.

Checks if the pointer points to the slab page. Also it tres to avoid
having to call compound_order needlessly. Not sure if that optimization is
worth it.



