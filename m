Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934446AbaE3Q7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:59:13 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54723 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbaE3Q7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:59:08 -0400
Message-ID: <5388B8D7.1020907@wwwdotorg.org>
Date: Fri, 30 May 2014 10:59:03 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Vlastimil Babka <vbabka@suse.cz>, Shawn Guo <shawn.guo@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>, David Rientjes <rientjes@google.com>,
        Hugh Dickins <hughd@google.com>, Greg Thelen <gthelen@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Olof Johansson <olof@lixom.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] mm, compaction: properly signal and act upon lock
 and need_sched() contention
References: <1399904111-23520-1-git-send-email-vbabka@suse.cz>	<1400233673-11477-1-git-send-email-vbabka@suse.cz>	<CAGa+x87-NRyK6kUiXNL_bRNEGm+DR6M3HPSLYEoq4t6Nrtnd_g@mail.gmail.com> <CAAQ0ZWQDVxAzZVm86ATXd1JGUVoLXj_Y5Ske7htxH_6a4GPKRg@mail.gmail.com> <537F082F.50501@suse.cz>
In-Reply-To: <537F082F.50501@suse.cz>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2014 02:34 AM, Vlastimil Babka wrote:
> On 05/23/2014 04:48 AM, Shawn Guo wrote:
>> On 23 May 2014 07:49, Kevin Hilman <khilman@linaro.org> wrote:
>>> On Fri, May 16, 2014 at 2:47 AM, Vlastimil Babka <vbabka@suse.cz> wrote:
>>>> Compaction uses compact_checklock_irqsave() function to periodically check for
>>>> lock contention and need_resched() to either abort async compaction, or to
>>>> free the lock, schedule and retake the lock. When aborting, cc->contended is
>>>> set to signal the contended state to the caller. Two problems have been
>>>> identified in this mechanism.
>>>
>>> This patch (or later version) has hit next-20140522 (in the form
>>> commit 645ceea9331bfd851bc21eea456dda27862a10f4) and according to my
>>> bisect, appears to be the culprit of several boot failures on ARM
>>> platforms.
>>
>> On i.MX6 where CMA is enabled, the commit causes the drivers calling
>> dma_alloc_coherent() fail to probe.  Tracing it a little bit, it seems
>> dma_alloc_from_contiguous() always return page as NULL after this
>> commit.
>>
>> Shawn
>>
> 
> Really sorry, guys :/
> 
> -----8<-----
> From: Vlastimil Babka <vbabka@suse.cz>
> Date: Fri, 23 May 2014 10:18:56 +0200
> Subject: mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention-fix2
> 
> Step 1: Change function name and comment between v1 and v2 so that the return
>         value signals the opposite thing.
> Step 2: Change the call sites to reflect the opposite return value.
> Step 3: ???
> Step 4: Make a complete fool of yourself.

Tested-by: Stephen Warren <swarren@nvidia.com>

This fix doesn't seem to be in linux-next yet:-(
