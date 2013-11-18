Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab3KRSFG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:05:06 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:47168 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab3KRSFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:05:02 -0500
Message-ID: <528A56A7.3020301@oracle.com>
Date: Mon, 18 Nov 2013 11:04:23 -0700
From: Khalid Aziz <khalid.aziz@oracle.com>
Organization: Oracle Corp
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Pravin Shelar <pshelar@nicira.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Christoph Lameter <cl@linux.com>, Johannes Weiner <jweiner@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Minchan Kim <minchan@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/3] mm: hugetlbfs: fix hugetlbfs optimization v2
References: <1384537668-10283-1-git-send-email-aarcange@redhat.com>
In-Reply-To: <1384537668-10283-1-git-send-email-aarcange@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2013 10:47 AM, Andrea Arcangeli wrote:
> Hi,
>
> 1/3 is a bugfix so it should be applied more urgently. 1/3 is not as
> fast as the current upstream code in the hugetlbfs + directio extreme
> 8GB/sec benchmark (but 3/3 should fill the gap later). The code is
> identical to the one I posted in v1 just rebased on upstream and was
> developed in collaboration with Khalid who already tested it.
>
> 2/3 and 3/3 had very little testing yet, and they're incremental
> optimization. 2/3 is minor and most certainly worth applying later.
>
> 3/3 instead complicates things a bit and adds more branches to the THP
> fast paths, so it should only be applied if the benchmarks of
> hugetlbfs + directio show that it is very worthwhile (that has not
> been verified yet). If it's not worthwhile 3/3 should be dropped (and
> the gap should be filled in some other way if the gap is not caused by
> the _mapcount mangling as I guessed). Ideally this should bring even
> more performance than current upstream code, as current upstream code
> still increased the _mapcount in gup_fast by mistake, while this
> eliminates the locked op on the tail page cacheline in gup_fast too
> (which is required for correctness too).

Hi Andrea,

I ran directio benchmark and here are the performance numbers (MBytes/sec):

Block size        3.12         3.12+patch 1      3.12+patch 1,2,3
----------        ----         ------------      ----------------
1M                8467           8114              7648
64K               4049           4043              4175

Performance numbers with 64K reads look good but there is further 
deterioration with 1M reads.

--
Khalid
