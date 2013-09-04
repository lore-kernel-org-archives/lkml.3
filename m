Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762375Ab3IDX6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 19:58:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753612Ab3IDX6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 19:58:42 -0400
Message-ID: <5227C928.8080709@redhat.com>
Date: Wed, 04 Sep 2013 19:58:32 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, compaction: periodically schedule when freeing pages
References: <alpine.DEB.2.02.1309041625060.29607@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1309041625060.29607@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 07:25 PM, David Rientjes wrote:
> We've been getting warnings about an excessive amount of time spent
> allocating pages for migration during memory compaction without
> scheduling.  isolate_freepages_block() already periodically checks for
> contended locks or the need to schedule, but isolate_freepages() never
> does.
> 
> When a zone is massively long and no suitable targets can be found, this
> iteration can be quite expensive without ever doing cond_resched().
> 
> Check periodically for the need to reschedule while the compaction free
> scanner iterates.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
