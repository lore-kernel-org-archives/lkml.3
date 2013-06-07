Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab3FGOM7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 10:12:59 -0400
Received: from a9-74.smtp-out.amazonses.com ([54.240.9.74]:34997 "EHLO
	a9-74.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753556Ab3FGOM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 10:12:58 -0400
Date: Fri, 7 Jun 2013 14:12:57 +0000
From: Christoph Lameter <cl@gentwo.org>
To: Roman Gushchin <klamm@yandex-team.ru>
cc: penberg@kernel.org, mpm@selenic.com, yanmin.zhang@intel.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: slub: slab order on multi-processor machines
In-Reply-To: <51B1A04B.7030003@yandex-team.ru>
Message-ID: <0000013f1efbaa4f-6039ad3e-286e-4486-8b7e-7b0331edf990-000000@email.amazonses.com>
References: <51B1A04B.7030003@yandex-team.ru>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.06.07-54.240.9.74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Jun 2013, Roman Gushchin wrote:

> As I understand, the idea was to make kernel allocations cheaper by reducing
> the total
> number of page allocations (allocating 1 page with order 3 is cheaper than
> allocating
> 8 1-ordered pages).

Its also affecting allocator speed. By having less page structures to
manage the metadata effort is reduced. By having more objects in a page
the fastpath of slub is more likely to be used (Visible in allocator
benchmarks). Slub can fall back dynamically to order 0 pages if necessary.
So it can take opportunistically take advantage of contiguous pages.

> I'm sure, it's true for recently rebooted machine with a lot of free
> non-fragmented memory. But is it also true for heavy-loaded machine with
> fragmented memory? Are we sure, that it's cheaper to run compaction and
> allocate order 3 page than to use small 1-pages slabs? Do I miss
> something?

We do have defragmentation logic and defragmentation passes to address
that. In general the need for larger physical contiguous memory segments
will increase as RAM gets larger and larger. Maybe 2M is the next step but
we will always have to face fragmentation regardless of what the next size
it.
