Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbaG2Gqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 02:46:39 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:34314 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbaG2Gqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 02:46:38 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Tue, 29 Jul 2014 15:53:27 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v5 07/14] mm, compaction: khugepaged should not give up
 due to need_resched()
Message-ID: <20140729065327.GB1610@js1304-P5Q-DELUXE>
References: <1406553101-29326-1-git-send-email-vbabka@suse.cz>
 <1406553101-29326-8-git-send-email-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406553101-29326-8-git-send-email-vbabka@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 03:11:34PM +0200, Vlastimil Babka wrote:
> Async compaction aborts when it detects zone lock contention or need_resched()
> is true. David Rientjes has reported that in practice, most direct async
> compactions for THP allocation abort due to need_resched(). This means that a
> second direct compaction is never attempted, which might be OK for a page
> fault, but khugepaged is intended to attempt a sync compaction in such case and
> in these cases it won't.

I have a silly question here.
Why need_resched() is criteria to stop async compaction?
need_resched() is flagged up when time slice runs out or other reasons.
It means that we should stop async compaction at arbitrary timing
because process can be on compaction code at arbitrary moment. I think
that it isn't reasonable and it doesn't ensure anything. Instead of
this approach, how about doing compaction on certain amounts of pageblock
for async compaction?

Thanks.
