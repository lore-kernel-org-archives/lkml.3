Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbaEVQE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 12:04:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbaEVQEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 12:04:25 -0400
Message-ID: <537E1FFC.40608@redhat.com>
Date: Thu, 22 May 2014 12:04:12 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Bob Liu <bob.liu@oracle.com>, Jan Kara <jack@suse.cz>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 3/3] mm: vmscan: Use proportional scanning during direct
 reclaim and full scan at DEF_PRIORITY
References: <1400749779-24879-1-git-send-email-mgorman@suse.de> <1400749779-24879-4-git-send-email-mgorman@suse.de>
In-Reply-To: <1400749779-24879-4-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2014 05:09 AM, Mel Gorman wrote:
> Commit "mm: vmscan: obey proportional scanning requirements for kswapd"
> ensured that file/anon lists were scanned proportionally for reclaim from
> kswapd but ignored it for direct reclaim. The intent was to minimse direct
> reclaim latency but Yuanhan Liu pointer out that it substitutes one long
> stall for many small stalls and distorts aging for normal workloads like
> streaming readers/writers.  Hugh Dickins pointed out that a side-effect of
> the same commit was that when one LRU list dropped to zero that the entirety
> of the other list was shrunk leading to excessive reclaim in memcgs.
> This patch scans the file/anon lists proportionally for direct reclaim
> to similarly age page whether reclaimed by kswapd or direct reclaim but
> takes care to abort reclaim if one LRU drops to zero after reclaiming the
> requested number of pages.
> 

> Note that there are fewer allocation stalls even though the amount
> of direct reclaim scanning is very approximately the same.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
