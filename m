Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab3FCIZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 04:25:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51650 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab3FCIZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 04:25:50 -0400
Date: Mon, 3 Jun 2013 10:25:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Andi Kleen <andi@firstfloor.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>,
        Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Roman Gushchin <klamm@yandex-team.ru>, metin d <metdos@yahoo.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 10/10] mm: workingset: keep shadow entries in check
Message-ID: <20130603082533.GH5910@twins.programming.kicks-ass.net>
References: <1369937046-27666-1-git-send-email-hannes@cmpxchg.org>
 <1369937046-27666-11-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369937046-27666-11-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 02:04:06PM -0400, Johannes Weiner wrote:
> Previously, page cache radix tree nodes were freed after reclaim
> emptied out their page pointers.  But now reclaim stores shadow
> entries in their place, which are only reclaimed when the inodes
> themselves are reclaimed.  This is problematic for bigger files that
> are still in use after they have a significant amount of their cache
> reclaimed, without any of those pages actually refaulting.  The shadow
> entries will just sit there and waste memory.  In the worst case, the
> shadow entries will accumulate until the machine runs out of memory.
> 

Can't we simply prune all refault entries that have a distance larger
than the memory size? Then we must assume that no refault entry means
its too old, which I think is a fair assumption.

