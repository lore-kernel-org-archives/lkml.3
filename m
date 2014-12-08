Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbaLHJQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 04:16:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51288 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111AbaLHJQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 04:16:36 -0500
Message-ID: <54856C72.4040705@suse.cz>
Date: Mon, 08 Dec 2014 10:16:34 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] enhance compaction success rate
References: <1418022980-4584-1-git-send-email-iamjoonsoo.kim@lge.com>
In-Reply-To: <1418022980-4584-1-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2014 08:16 AM, Joonsoo Kim wrote:
> This patchset aims at increase of compaction success rate. Changes are
> related to compaction finish condition and freepage isolation condition.
>
>  From these changes, I did stress highalloc test in mmtests with nonmovable
> order 7 allocation configuration, and success rate (%) at phase 1 are,
>
> Base	Patch-1	Patch-3	Patch-4
> 55.00	57.00	62.67	64.00
>
> And, compaction success rate (%) on same test are,
>
> Base	Patch-1	Patch-3	Patch-4
> 18.47	28.94	35.13	41.50

Did you test Patch-2 separately? Any difference to Patch 1?

> This patchset is based on my tracepoint update on compaction.
>
> https://lkml.org/lkml/2014/12/3/71
>
> Joonsoo Kim (4):
>    mm/compaction: fix wrong order check in compact_finished()
>    mm/page_alloc: expands broken freepage to proper buddy list when
>      steal
>    mm/compaction: enhance compaction finish condition
>    mm/compaction: stop the isolation when we isolate enough freepage
>
>   include/linux/mmzone.h      |    3 ++
>   include/trace/events/kmem.h |    7 +++--
>   mm/compaction.c             |   48 ++++++++++++++++++++++------
>   mm/internal.h               |    1 +
>   mm/page_alloc.c             |   73 +++++++++++++++++++++++++------------------
>   5 files changed, 89 insertions(+), 43 deletions(-)
>

