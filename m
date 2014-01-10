Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769AbaAJS03 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 13:26:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbaAJS01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 13:26:27 -0500
Message-ID: <52D03B13.60401@redhat.com>
Date: Fri, 10 Jan 2014 13:25:23 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Andi Kleen <andi@firstfloor.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Bob Liu <bob.liu@oracle.com>, Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, Greg Thelen <gthelen@google.com>,
        Hugh Dickins <hughd@google.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Luigi Semenzato <semenzato@google.com>, Mel Gorman <mgorman@suse.de>,
        Metin Doslu <metin@citusdata.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Ozgun Erdogan <ozgun@citusdata.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Roman Gushchin <klamm@yandex-team.ru>, Ryan Mallon <rmallon@gmail.com>,
        Tejun Heo <tj@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 3/9] mm: shmem: save one radix tree lookup when truncating
 swapped pages
References: <1389377443-11755-1-git-send-email-hannes@cmpxchg.org> <1389377443-11755-4-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1389377443-11755-4-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2014 01:10 PM, Johannes Weiner wrote:
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
> Reviewed-by: Minchan Kim <minchan@kernel.org>

Reviewed-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
