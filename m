Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012Ab3KYIVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 03:21:09 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:49191 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908Ab3KYIVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 03:21:07 -0500
X-AuditID: 9c930197-b7caaae000001cef-aa-529308701268
Date: Mon, 25 Nov 2013 17:21:52 +0900
From: Minchan Kim <minchan@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Rik van Riel <riel@redhat.com>,
        Jan Kara <jack@suse.cz>, Vlastimil Babka <vbabka@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Greg Thelen <gthelen@google.com>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Michel Lespinasse <walken@google.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Roman Gushchin <klamm@yandex-team.ru>,
        Ozgun Erdogan <ozgun@citusdata.com>, Metin Doslu <metin@citusdata.com>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 3/9] mm: shmem: save one radix tree lookup when
 truncating swapped pages
Message-ID: <20131125082152.GC4731@bbox>
References: <1385336308-27121-1-git-send-email-hannes@cmpxchg.org>
 <1385336308-27121-4-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385336308-27121-4-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 24, 2013 at 06:38:22PM -0500, Johannes Weiner wrote:
> Page cache radix tree slots are usually stabilized by the page lock,
> but shmem's swap cookies have no such thing.  Because the overall
> truncation loop is lockless, the swap entry is currently confirmed by
> a tree lookup and then deleted by another tree lookup under the same
> tree lock region.
> 
> Use radix_tree_delete_item() instead, which does the verification and
> deletion with only one lookup.  This also allows removing the
> delete-only special case from shmem_radix_tree_replace().
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Minchan Kim <minchan@kernel.org>

Nice cleanup!

-- 
Kind regards,
Minchan Kim
