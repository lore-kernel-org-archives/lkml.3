Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab3IIOoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 10:44:09 -0400
Received: from a10-63.smtp-out.amazonses.com ([54.240.10.63]:42855 "EHLO
	a10-63.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751506Ab3IIOoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 10:44:07 -0400
Date: Mon, 9 Sep 2013 14:44:03 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [REPOST PATCH 3/4] slab: introduce byte sized index for the
 freelist of a slab
In-Reply-To: <20130909043217.GB22390@lge.com>
Message-ID: <00000141032dea11-c5aa9c77-b2f2-4cab-b7a0-d37665a6cec8-000000@email.amazonses.com>
References: <1378447067-19832-1-git-send-email-iamjoonsoo.kim@lge.com> <1378447067-19832-4-git-send-email-iamjoonsoo.kim@lge.com> <00000140f3fed229-f49b95d4-7087-476f-b2c9-37846749aad6-000000@email.amazonses.com> <20130909043217.GB22390@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.09.09-54.240.10.63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Sep 2013, Joonsoo Kim wrote:

> 32 byte is not minimum object size, minimum *kmalloc* object size
> in default configuration. There are some slabs that their object size is
> less than 32 byte. If we have a 8 byte sized kmem_cache, it has 512 objects
> in 4K page.

As far as I can recall only SLUB supports 8 byte objects. SLABs mininum
has always been 32 bytes.

> Moreover, we can configure slab_max_order in boot time so that we can't know
> how many object are in a certain slab in compile time. Therefore we can't
> decide the size of the index in compile time.

You can ignore the slab_max_order if necessary.

> I think that byte and short int sized index support would be enough, but
> it should be determined at runtime.

On x86 f.e. it would add useless branching. The branches are never taken.
You only need these if you do bad things to the system like requiring
large contiguous allocs.
