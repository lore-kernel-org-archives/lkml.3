Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab3IKBEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 21:04:16 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:65174 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab3IKBEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 21:04:15 -0400
X-AuditID: 9c93017e-b7c76ae000003897-33-522fc18d1a07
Date: Wed, 11 Sep 2013 10:04:34 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [REPOST PATCH 3/4] slab: introduce byte sized index for the
 freelist of a slab
Message-ID: <20130911010434.GB24671@lge.com>
References: <1378447067-19832-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1378447067-19832-4-git-send-email-iamjoonsoo.kim@lge.com>
 <00000140f3fed229-f49b95d4-7087-476f-b2c9-37846749aad6-000000@email.amazonses.com>
 <20130909043217.GB22390@lge.com>
 <00000141032dea11-c5aa9c77-b2f2-4cab-b7a0-d37665a6cec8-000000@email.amazonses.com>
 <20130910054342.GB24602@lge.com>
 <0000014109c372c6-5f3c49d4-ce8b-4760-b80d-a32e042ec09b-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000014109c372c6-5f3c49d4-ce8b-4760-b80d-a32e042ec09b-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 09:25:05PM +0000, Christoph Lameter wrote:
> On Tue, 10 Sep 2013, Joonsoo Kim wrote:
> 
> > On Mon, Sep 09, 2013 at 02:44:03PM +0000, Christoph Lameter wrote:
> > > On Mon, 9 Sep 2013, Joonsoo Kim wrote:
> > >
> > > > 32 byte is not minimum object size, minimum *kmalloc* object size
> > > > in default configuration. There are some slabs that their object size is
> > > > less than 32 byte. If we have a 8 byte sized kmem_cache, it has 512 objects
> > > > in 4K page.
> > >
> > > As far as I can recall only SLUB supports 8 byte objects. SLABs mininum
> > > has always been 32 bytes.
> >
> > No.
> > There are many slabs that their object size are less than 32 byte.
> > And I can also create a 8 byte sized slab in my kernel with SLAB.
> 
> Well the minimum size for the kmalloc array is 32 bytes. These are custom
> slabs. KMALLOC_SHIFT_LOW is set to 5 in include/linux/slab.h.
> 
> Ok so there are some slabs like that. Hmmm.. We have sizes 16 and 24 in
> your list. 16*256 is still 4096. So this would still work fine if we would
> forbid a size of 8 or increase that by default to 16.
> 
> > > On x86 f.e. it would add useless branching. The branches are never taken.
> > > You only need these if you do bad things to the system like requiring
> > > large contiguous allocs.
> >
> > As I said before, since there is a possibility that some runtime loaded modules
> > use a 8 byte sized slab, we can't determine index size in compile time. Otherwise
> > we should always use short int sized index and I think that it is worse than
> > adding a branch.
> 
> We can enforce a mininum slab size and an order limit so that it fits. And
> then there would be no additional branching.
> 

Okay. I will respin this patchset with your suggestion.

Anyway, could you review my previous patchset, that is, 'overload struct slab
over struct page to reduce memory usage'? I'm not sure whether your answer is
ack or not.

Thanks.
