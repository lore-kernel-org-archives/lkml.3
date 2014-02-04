Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964960AbaBDXOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 18:14:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58346 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932472AbaBDXO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 18:14:26 -0500
Date: Tue, 4 Feb 2014 15:14:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andi Kleen <andi@firstfloor.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Bob Liu <bob.liu@oracle.com>, Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, Greg Thelen <gthelen@google.com>,
        Hugh Dickins <hughd@google.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Luigi Semenzato <semenzato@google.com>, Mel Gorman <mgorman@suse.de>,
        Metin Doslu <metin@citusdata.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Ozgun Erdogan <ozgun@citusdata.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Roman Gushchin <klamm@yandex-team.ru>, Ryan Mallon <rmallon@gmail.com>,
        Tejun Heo <tj@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 00/10] mm: thrash detection-based file cache sizing v9
Message-Id: <20140204151424.d08301233c1f1801f43498b1@linux-foundation.org>
In-Reply-To: <1391475222-1169-1-git-send-email-hannes@cmpxchg.org>
References: <1391475222-1169-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  3 Feb 2014 19:53:32 -0500 Johannes Weiner <hannes@cmpxchg.org> wrote:

> o Fix vmstat build problems on UP (Fengguang Wu's build bot)
> 
> o Clarify why optimistic radix_tree_node->private_list link checking
>   is safe without holding the list_lru lock (Dave Chinner)
> 
> o Assert locking balance when the list_lru isolator says it dropped
>   the list lock (Dave Chinner)
> 
> o Remove remnant of a manual reclaim counter in the shadow isolator,
>   the list_lru-provided accounting is accurate now that we added
>   LRU_REMOVED_RETRY (Dave Chinner)
> 
> o Set an object limit for the shadow shrinker instead of messing with
>   its seeks setting.  The configured seeks define how pressure applied
>   to pages translates to pressure on the object pool, in itself it is
>   not enough to replace proper object valuation to classify expired
>   and in-use objects.  Shadow nodes contain up to 64 shadow entries
>   from different/alternating zones that have their own atomic age
>   counter, so determining if a node is overall expired is crazy
>   expensive.  Instead, use an object limit above which nodes are very
>   likely to be expired.
> 
> o __pagevec_lookup and __find_get_pages kerneldoc fixes (Minchan Kim)
> 
> o radix_tree_node->count accessors for pages and shadows (Minchan Kim)
> 
> o Rebase to v3.14-rc1 and add review tags

An earlier version caused a 24-byte inode bloatage.  That appears to
have been reduced to 8 bytes, yes?  What was done there?

> 69 files changed, 1438 insertions(+), 462 deletions(-)

omigod

