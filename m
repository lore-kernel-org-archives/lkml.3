Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbaIZHQW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 03:16:22 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:39392 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753029AbaIZHQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 03:16:21 -0400
Message-ID: <542512AD.9070304@vmware.com>
Date: Fri, 26 Sep 2014 09:15:57 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Chuck Ebbert <cebbert.lkml@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Shaohua Li <shli@kernel.org>, Rik van Riel <riel@redhat.com>,
        "Maarten Lankhorst" <maarten.lankhorst@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Ingo Molnar <mingo@kernel.org>,
        Hugh Dickens <hughd@google.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: page allocator bug in 3.16?
References: <54246506.50401@hurleysoftware.com> <20140925143555.1f276007@as> <5424AAD0.9010708@hurleysoftware.com>
In-Reply-To: <5424AAD0.9010708@hurleysoftware.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.160.246]
X-ClientProxiedBy: EX13-CAS-013.vmware.com (10.113.191.65) To
 EX13-MBX-024.vmware.com (10.113.191.44)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2014 01:52 AM, Peter Hurley wrote:
> On 09/25/2014 03:35 PM, Chuck Ebbert wrote:
>> There are six ttm patches queued for 3.16.4:
>>
>> drm-ttm-choose-a-pool-to-shrink-correctly-in-ttm_dma_pool_shrink_scan.patch
>> drm-ttm-fix-handling-of-ttm_pl_flag_topdown-v2.patch
>> drm-ttm-fix-possible-division-by-0-in-ttm_dma_pool_shrink_scan.patch
>> drm-ttm-fix-possible-stack-overflow-by-recursive-shrinker-calls.patch
>> drm-ttm-pass-gfp-flags-in-order-to-avoid-deadlock.patch
>> drm-ttm-use-mutex_trylock-to-avoid-deadlock-inside-shrinker-functions.patch
> Thanks for info, Chuck.
>
> Unfortunately, none of these fix TTM dma allocation doing CMA dma allocation,
> which is the root problem.
>
> Regards,
> Peter Hurley

The problem is not really in TTM but in CMA, There was a guy offering to
fix this in the CMA code but I guess he didn't probably because he
didn't receive any feedback.


/Thomas

