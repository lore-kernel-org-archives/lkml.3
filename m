Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760592AbbA1BdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:33:19 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:65262 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760574AbbA1BdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:33:16 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1501271054310.25124@gentwo.org>
References: <20150123213727.142554068@linux.com>
	<20150123213735.590610697@linux.com>
	<20150127082132.GE11358@js1304-P5Q-DELUXE>
	<alpine.DEB.2.11.1501271054310.25124@gentwo.org>
Date: Wed, 28 Jan 2015 10:33:14 +0900
Message-ID: <CAAmzW4MzNfcRucHeTxJtXLks5T-Def=O1sRpQY6fo5ybTzKsBA@mail.gmail.com>
Subject: Re: [RFC 1/3] Slab infrastructure for array operations
From: Joonsoo Kim <js1304@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, akpm@linuxfoundation.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>, iamjoonsoo@lge.com,
        Jesper Dangaard Brouer <brouer@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-28 1:57 GMT+09:00 Christoph Lameter <cl@linux.com>:
> On Tue, 27 Jan 2015, Joonsoo Kim wrote:
>
>> IMHO, exposing these options is not a good idea. It's really
>> implementation specific. And, this flag won't show consistent performance
>> according to specific slab implementation. For example, to get best
>> performance, if SLAB is used, GFP_SLAB_ARRAY_LOCAL would be the best option,
>> but, for the same purpose, if SLUB is used, GFP_SLAB_ARRAY_NEW would
>> be the best option. And, performance could also depend on number of objects
>> and size.
>
> Why would slab show a better performance? SLUB also can have partial
> allocated pages per cpu and could also get data quite fast if only a
> minimal number of objects are desired. SLAB is slightly better because the
> number of cachelines touches stays small due to the arrangement of the freelist
> on the slab page and the queueing approach that does not involve linked
> lists.
>
>
> GFP_SLAB_ARRAY new is best for large quantities in either allocator since
> SLAB also has to construct local metadata structures.

In case of SLAB, there is just a little more work to construct local metadata so
GFP_SLAB_ARRAY_NEW would not show better performance
than GFP_SLAB_ARRAY_LOCAL, because it would cause more overhead due to
more page allocations. Because of this characteristic, I said that
which option is
the best is implementation specific and therefore we should not expose it.

Even if we narrow down the problem to the SLUB, choosing correct option is
difficult enough. User should know how many objects are cached in this
kmem_cache
in order to choose best option since relative quantity would make
performance difference.

And, how many objects are cached in this kmem_cache could be changed
whenever implementation changed.

Thanks.
