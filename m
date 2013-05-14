Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab3ENReu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 13:34:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936Ab3ENRet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 13:34:49 -0400
Message-ID: <51927531.8010507@redhat.com>
Date: Tue, 14 May 2013 13:32:33 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>
Subject: Re: [RFC 4/4] mm: free reclaimed pages instantly without depending
 next reclaim
References: <1368411048-3753-1-git-send-email-minchan@kernel.org> <1368411048-3753-5-git-send-email-minchan@kernel.org>
In-Reply-To: <1368411048-3753-5-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2013 10:10 PM, Minchan Kim wrote:
> Normally, file I/O for reclaiming is asynchronous so that
> when page writeback is completed, reclaimed page will be
> rotated into LRU tail for fast reclaiming in next turn.
> But it makes unnecessary CPU overhead and more iteration with higher
> priority of reclaim could reclaim too many pages than needed
> pages.
>
> This patch frees reclaimed pages by paging out instantly without
> rotating back them into LRU's tail when the I/O is completed so
> that we can get out of reclaim loop as soon as poosbile and avoid
> unnecessary CPU overhead for moving them.
>
> Signed-off-by: Minchan Kim <minchan@kernel.org>

I like this approach and am looking forward to your v2 series,
with the reworked patch 3/4.

