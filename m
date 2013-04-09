Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936430Ab3DIOqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 10:46:24 -0400
Received: from a9-62.smtp-out.amazonses.com ([54.240.9.62]:52827 "EHLO
	a9-62.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936365Ab3DIOqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 10:46:23 -0400
X-Greylist: delayed 839 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Apr 2013 10:46:23 EDT
Date: Tue, 9 Apr 2013 14:32:22 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Simon Jeons <simon.jeons@gmail.com>
cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 2/3] mm, slub: count freed pages via rcu as this task's
 reclaimed_slab
In-Reply-To: <5163E194.3080600@gmail.com>
Message-ID: <0000013def363b50-9a16dd09-72ad-494f-9c25-17269fc3aab3-000000@email.amazonses.com>
References: <1365470478-645-1-git-send-email-iamjoonsoo.kim@lge.com> <1365470478-645-2-git-send-email-iamjoonsoo.kim@lge.com> <5163E194.3080600@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.04.09-54.240.9.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Apr 2013, Simon Jeons wrote:

> > +	int pages = 1 << compound_order(page);
>
> One question irrelevant this patch. Why slab cache can use compound
> page(hugetlbfs pages/thp pages)? They are just used by app to optimize tlb
> miss, is it?

Slab caches can use any order pages because these pages are never on
the LRU and are not part of the page cache. Large continuous physical
memory means that objects can be arranged in a more efficient way in the
page. This is particularly useful for larger objects where we might use a
lot of memory because objects do not fit well into a 4k page.

It also reduces the slab page management if higher order pages are used.
In the case of slub the page size also determines the number of objects
that can be allocated/freed without the need for some form of
synchronization.

