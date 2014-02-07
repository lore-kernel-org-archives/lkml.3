Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbaBGJOf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 04:14:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60921 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbaBGJOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 04:14:31 -0500
Message-ID: <52F4A3F2.1050809@suse.cz>
Date: Fri, 07 Feb 2014 10:14:26 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mgorman@suse.de>, Joonsoo Kim <js1304@gmail.com>,
        Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] compaction related commits
References: <1391749726-28910-1-git-send-email-iamjoonsoo.kim@lge.com>
In-Reply-To: <1391749726-28910-1-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2014 06:08 AM, Joonsoo Kim wrote:
> This patchset is related to the compaction.
> 
> patch 1 fixes contrary implementation of the purpose of compaction.
> patch 2~4 are for optimization.
> patch 5 is just for clean-up.
> 
> I tested this patchset with stress-highalloc benchmark on Mel's mmtest
> and cannot find any regression in terms of success rate. And I find
> much reduced system time. Below is result of 3 runs.

What was the memory size? Mel told me this test shouldn't be run with more than 4GB.

> * Before
> time :: stress-highalloc 3276.26 user 740.52 system 1664.79 elapsed
> time :: stress-highalloc 3640.71 user 771.32 system 1633.83 elapsed
> time :: stress-highalloc 3691.64 user 775.44 system 1638.05 elapsed
> 
> avg system: 1645 s
> 
> * After
> time :: stress-highalloc 3225.51 user 732.40 system 1542.76 elapsed
> time :: stress-highalloc 3524.31 user 749.63 system 1512.88 elapsed
> time :: stress-highalloc 3610.55 user 757.20 system 1505.70 elapsed
> 
> avg system: 1519 s
> 
> That is 7% reduced system time.

Why not post the whole compare-mmtests output? There are more metrics in there and extra
eyes never hurt.

Vlastimil

> Thanks.
> 
> Joonsoo Kim (5):
>   mm/compaction: disallow high-order page for migration target
>   mm/compaction: do not call suitable_migration_target() on every page
>   mm/compaction: change the timing to check to drop the spinlock
>   mm/compaction: check pageblock suitability once per pageblock
>   mm/compaction: clean-up code on success of ballon isolation
> 
>  mm/compaction.c |   75 +++++++++++++++++++++++++++++--------------------------
>  1 file changed, 39 insertions(+), 36 deletions(-)
> 

