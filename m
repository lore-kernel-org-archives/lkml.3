Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaB0UYn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 15:24:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550AbaB0UYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 15:24:42 -0500
Message-ID: <530F9EB2.3070800@redhat.com>
Date: Thu, 27 Feb 2014 15:23:14 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Jan Stancek <jstancek@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] mm: page_alloc: reset aging cycle with GFP_THISNODE
References: <1393360022-22566-1-git-send-email-hannes@cmpxchg.org> <20140226095422.GY6732@suse.de> <20140226171206.GU6963@cmpxchg.org> <20140226201333.GV6963@cmpxchg.org>
In-Reply-To: <20140226201333.GV6963@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2014 03:13 PM, Johannes Weiner wrote:

> Would this be an acceptable replacement for 1/2?

Looks reasonable to me. This should avoid the issues that
were observed with NUMA migrations.

> ---
>
> From: Johannes Weiner <hannes@cmpxchg.org>
> Subject: [patch 1/2] mm: page_alloc: exempt GFP_THISNODE allocations from zone
>   fairness
>
> Jan Stancek reports manual page migration encountering allocation
> failures after some pages when there is still plenty of memory free,
> and bisected the problem down to 81c0a2bb515f ("mm: page_alloc: fair
> zone allocator policy").
>
> The problem is that GFP_THISNODE obeys the zone fairness allocation
> batches on one hand, but doesn't reset them and wake kswapd on the
> other hand.  After a few of those allocations, the batches are
> exhausted and the allocations fail.
>
> Fixing this means either having GFP_THISNODE wake up kswapd, or
> GFP_THISNODE not participating in zone fairness at all.  The latter
> seems safer as an acute bugfix, we can clean up later.
>
> Reported-by: Jan Stancek <jstancek@redhat.com>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: <stable@kernel.org> # 3.12+

Acked-by: Rik van Riel <riel@redhat.com>

