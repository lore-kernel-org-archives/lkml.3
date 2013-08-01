Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751228Ab3HAEb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 00:31:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826Ab3HAEbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 00:31:55 -0400
Message-ID: <51F9E4A6.2090909@redhat.com>
Date: Thu, 01 Aug 2013 00:31:34 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] mm: page_alloc: fair zone allocator policy
References: <1374267325-22865-1-git-send-email-hannes@cmpxchg.org> <1374267325-22865-4-git-send-email-hannes@cmpxchg.org> <20130801025636.GC19540@bbox>
In-Reply-To: <20130801025636.GC19540@bbox>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2013 10:56 PM, Minchan Kim wrote:

> Yes, it's not really slow path because it could return to normal status
> without calling significant slow functions by reset batchcount of
> prepare_slowpath.
>
> I think it's tradeoff and I am biased your approach although we would
> lose a little performance because fair aging would recover the loss by
> fastpath's overhead. But who knows? Someone has a concern.
>
> So we should mention about such problems.

If the atomic operation in the fast path turns out to be a problem,
I suspect we may be able to fix it by using per-cpu counters, and
consolidating those every once in a while.

However, it may be good to see whether there is a problem in the
first place, before adding complexity.

-- 
All rights reversed
