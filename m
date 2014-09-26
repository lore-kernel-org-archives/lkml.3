Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbaIZM2W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 08:28:22 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:53113 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbaIZM2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 08:28:20 -0400
MIME-Version: 1.0
In-Reply-To: <542543D8.8020604@vmware.com>
References: <54246506.50401@hurleysoftware.com>
	<20140925143555.1f276007@as>
	<5424AAD0.9010708@hurleysoftware.com>
	<542512AD.9070304@vmware.com>
	<20140926054005.5c7985c0@as>
	<542543D8.8020604@vmware.com>
Date: Fri, 26 Sep 2014 08:28:19 -0400
Message-ID: <CAF6AEGvOkPq5LQR76-VbspYyCvUxL1=W-dLc4g_aWX2wkUmRpg@mail.gmail.com>
Subject: Re: page allocator bug in 3.16?
From: Rob Clark <robdclark@gmail.com>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Chuck Ebbert <cebbert.lkml@gmail.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickens <hughd@google.com>,
        Linux kernel <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-mm <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shaohua Li <shli@kernel.org>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 6:45 AM, Thomas Hellstrom <thellstrom@vmware.com> wrote:
> On 09/26/2014 12:40 PM, Chuck Ebbert wrote:
>> On Fri, 26 Sep 2014 09:15:57 +0200
>> Thomas Hellstrom <thellstrom@vmware.com> wrote:
>>
>>> On 09/26/2014 01:52 AM, Peter Hurley wrote:
>>>> On 09/25/2014 03:35 PM, Chuck Ebbert wrote:
>>>>> There are six ttm patches queued for 3.16.4:
>>>>>
>>>>> drm-ttm-choose-a-pool-to-shrink-correctly-in-ttm_dma_pool_shrink_scan.patch
>>>>> drm-ttm-fix-handling-of-ttm_pl_flag_topdown-v2.patch
>>>>> drm-ttm-fix-possible-division-by-0-in-ttm_dma_pool_shrink_scan.patch
>>>>> drm-ttm-fix-possible-stack-overflow-by-recursive-shrinker-calls.patch
>>>>> drm-ttm-pass-gfp-flags-in-order-to-avoid-deadlock.patch
>>>>> drm-ttm-use-mutex_trylock-to-avoid-deadlock-inside-shrinker-functions.patch
>>>> Thanks for info, Chuck.
>>>>
>>>> Unfortunately, none of these fix TTM dma allocation doing CMA dma allocation,
>>>> which is the root problem.
>>>>
>>>> Regards,
>>>> Peter Hurley
>>> The problem is not really in TTM but in CMA, There was a guy offering to
>>> fix this in the CMA code but I guess he didn't probably because he
>>> didn't receive any feedback.
>>>
>> Yeah, the "solution" to this problem seems to be "don't enable CMA on
>> x86". Maybe it should even be disabled in the config system.
> Or, as previously suggested, don't use CMA for order 0 (single page)
> allocations....

On devices that actually need CMA pools to arrange for memory to be in
certain ranges, I think you probably do want to have order 0 pages
come from the CMA pool.

Seems like disabling CMA on x86 (where it should be unneeded) is the
better way, IMO

BR,
-R


> /Thomas
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
