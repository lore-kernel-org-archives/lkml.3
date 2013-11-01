Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab3KAJBL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 05:01:11 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41164 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab3KAJBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 05:01:08 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <52736DA4.8000303@jp.fujitsu.com>
Date: Fri, 1 Nov 2013 18:00:20 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, Mel Gorman <mgorman@suse.de>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] mm: get rid of unnecessary pageblock scanning in setup_zone_migrate_reserve
References: <1382562092-15570-1-git-send-email-kosaki.motohiro@gmail.com> <20131030151904.GO2400@suse.de> <527169BB.8020104@gmail.com> <20131031101525.GT2400@suse.de> <52729003.1060209@gmail.com>
In-Reply-To: <52729003.1060209@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel and Kosaki,

Thank you for posting patches.

I tested your patches. And following table shows time of onlining
a memory section.

Amount of memory        | 128GB | 192GB | 256GB|
------------------------------------------------
linux-3.12-rc7          |  24.3 |  30.2 | 45.6 |
Kosaki's first patch    |   8.3 |   8.3 |  8.6 |
Mel + Kosaki's nit pick |  10.9 |  19.2 | 31.3 |
------------------------------------------------
                                    (millisecond)

128GB : 4 nodes and each node has 32GB of memory
192GB : 6 nodes and each node has 32GB of memory
256GB : 8 nodes and each node has 32GB of memory

In my result, Mel's patch does not seem to fix the problem since time
is increasing with increasing amount of memory.

Thanks,
Yasuaki Ishimatsu

(2013/11/01 2:14), KOSAKI Motohiro wrote:
>>> Nit. I would like to add following hunk. This is just nit because moving
>>> reserve pageblock is extreme rare.
>>>
>>>         if (block_migratetype == MIGRATE_RESERVE) {
>>> +                       found++;
>>>             set_pageblock_migratetype(page, MIGRATE_MOVABLE);
>>>             move_freepages_block(zone, page, MIGRATE_MOVABLE);
>>>         }
>>
>> I don't really see the advantage but if you think it is necessary then I
>> do not object either.
>
> For example, a zone has five pageblock b1,b2,b3,b4,b5 and b1 has MIGRATE_RESERVE.
> When hotremove b1 and hotadd again, your code need to scan all of blocks. But
> mine only need to scan b1 and b2. I mean that's a hotplug specific optimization.
>
>


