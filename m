Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab3FQHxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 03:53:05 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:65270 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab3FQHxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 03:53:03 -0400
X-AuditID: cbfee68e-b7f276d000002279-fd-51bec05da2ee
Message-id: <51BEC0A1.7090807@samsung.com>
Date: Mon, 17 Jun 2013 16:54:09 +0900
From: Heesub Shin <heesub.shin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329
 Thunderbird/17.0.5
MIME-version: 1.0
To: Dave Chinner <david@fromorbit.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, riel@redhat.com,
        kyungmin.park@samsung.com, d.j.shin@samsung.com, sunae.seo@samsung.com
Subject: Re: [PATCH] mm: vmscan: remove redundant querying to shrinker
References: <1371204471-13518-1-git-send-email-heesub.shin@samsung.com>
 <20130617000827.GI29338@dastard>
In-reply-to: <20130617000827.GI29338@dastard>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zTd3YA/sCDfY807eYs34Nm8WJi7UW
	W47dY7Q4OHsJk8XZpjfsFpd3zWGzuLfmP6vF5HfPGC3+XlnPYtG4+x2bA5fHqUUSHps+TWL3
	ODHjN4vH+31X2Tz6tqxi9Nh8utrj8ya5APYoLpuU1JzMstQifbsErozuTZ/ZC85KVcw9uIex
	gfG7SBcjJ4eEgInEu/lbWCBsMYkL99azdTFycQgJLGOUeDtvCStM0ZkbL9ghEtMZJf5MWsAI
	4bxmlFg46S87SBWvgJbE5LdtYKNYBFQlVu3pAOrm4GAT0JY4tC0YJCwqECHxdkoDG0S5oMSP
	yffAykUE1CQmTdrBDDKTWWAvo0TThH9gRcICbhLdJ46BFQkJZEm8P74SzOYU0JV48H092HXM
	AtYSKydtY4Sw5SU2r3kLNkhC4Cu7xLQZH6EOEpD4NvkQC8hBEgKyEpsOMEN8JilxcMUNlgmM
	YrOQ3DQLydhZSMYuYGRexSiaWpBcUJyUXmSkV5yYW1yal66XnJ+7iRESpX07GG8esD7EmAy0
	ciKzlGhyPjDK80riDY3NjCxMTUyNjcwtzUgTVhLnVWuxDhQSSE8sSc1OTS1ILYovKs1JLT7E
	yMTBKdXAqChimdW3bf5sd69Ond7I+VOeaC5SWfbQf2Vh+hIZf7slicbiEW937JM+UPR4smSy
	1dzliz4+7wyZVrNX3T/hnv7uVTucf1ffSv2/f/OaI1r/tr8RsPe7tqyuyCZ9+Ye0v8HGaff/
	de8q1XKS35bddHvtz+vtFel8VxLyZpcKv56y1eXFVuPiM0osxRmJhlrMRcWJABV486PoAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jQd3YA/sCDe62aVvMWb+GzeLExVqL
	LcfuMVocnL2EyeJs0xt2i8u75rBZ3Fvzn9Vi8rtnjBZ/r6xnsWjc/Y7Ngcvj1CIJj02fJrF7
	nJjxm8Xj/b6rbB59W1Yxemw+Xe3xeZNcAHtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZ
	gaGuoaWFuZJCXmJuqq2Si0+ArltmDtB1SgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4Lg
	eowM0EDCOsaM7k2f2QvOSlXMPbiHsYHxu0gXIyeHhICJxJkbL9ghbDGJC/fWs3UxcnEICUxn
	lPgzaQEjhPOaUWLhpL9gVbwCWhKT37axgNgsAqoSq/Z0sHYxcnCwCWhLHNoWDBIWFYiQeDul
	gQ2iXFDix+R7YOUiAmoSkybtYAaZySywl1GiacI/sCJhATeJ7hPHwIqEBLIk3h9fCWZzCuhK
	PPi+nhXEZhawllg5aRsjhC0vsXnNW+YJjAKzkOyYhaRsFpKyBYzMqxhFUwuSC4qT0nMN9YoT
	c4tL89L1kvNzNzGCU8AzqR2MKxssDjEKcDAq8fBuqN4XKMSaWFZcmXuIUYKDWUmEN3YiUIg3
	JbGyKrUoP76oNCe1+BBjMjAEJjJLiSbnA9NTXkm8obGJmZGlkZmxibmxMWnCSuK8B1qtA4UE
	0hNLUrNTUwtSi2C2MHFwSjUwbswtYU68lHaT78wdW77sZae3Clf+OxeeEiL6LlYkdMfNtcXL
	8n+yBpda1U2peyb40U7/XqfPnQXxkSVVUcx5RTYPOBqv/VhY9NuYWV7itXJTy83j9ue/z1hU
	7VNp9T8zRNiD96Nw7Yqwhb8rTsfseSrq9cwoKfXgvj/tjOHKLZ4qAcoHowWUWIozEg21mIuK
	EwHH+GTPRQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/17/2013 09:08 AM, Dave Chinner wrote:
> On Fri, Jun 14, 2013 at 07:07:51PM +0900, Heesub Shin wrote:
>> shrink_slab() queries each slab cache to get the number of
>> elements in it. In most cases such queries are cheap but,
>> on some caches. For example, Android low-memory-killer,
>> which is operates as a slab shrinker, does relatively
>> long calculation once invoked and it is quite expensive.
>
> As has already been pointed out, the low memory killer is a badly
> broken piece of code. I can't run a normal machine with it enabled
> because it randomly kills processes whenever memory pressure is
> generated. What it does is simply broken and hence arguing that it
> has too much overhead is not a convincing argument for changing core
> shrinker infrastructure.
>
>> This patch removes redundant queries to shrinker function
>> in the loop of shrink batch.
>>
>> Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
>> ---
>>   mm/vmscan.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index fa6a853..11b6695 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -282,9 +282,8 @@ unsigned long shrink_slab(struct shrink_control *shrink,
>>   					max_pass, delta, total_scan);
>>
>>   		while (total_scan >= batch_size) {
>> -			int nr_before;
>> +			int nr_before = max_pass;
>>
>> -			nr_before = do_shrinker_shrink(shrinker, shrink, 0);
>>   			shrink_ret = do_shrinker_shrink(shrinker, shrink,
>>   							batch_size);
>>   			if (shrink_ret == -1)
>> @@ -293,6 +292,7 @@ unsigned long shrink_slab(struct shrink_control *shrink,
>>   				ret += nr_before - shrink_ret;
>>   			count_vm_events(SLABS_SCANNED, batch_size);
>>   			total_scan -= batch_size;
>> +			max_pass = shrink_ret;
>>
>>   			cond_resched();
>>   		}
>
> Shrinkers run concurrently on different CPUs, and so the state of
> the cache being shrunk can change significantly when cond_resched()
> actually yields the CPU.  Hence we need to recalculate the current
> state of the cache before we shrink again to get an accurate idea of
> how much work the current loop has done. If we get this badly wrong,
> the caller of shrink_slab() will get an incorrect idea of how much
> work was actually done by the shrinkers....
>
> This problem is fixed in mmtom by the change of shrinker API that
> results shrinker->scan_objects() returning the number of objects
> freed directly, and hence it isn't necessary to have a
> shrinker->count_objects() call in the scan loop anymore. i.e. the
> reworked scan loop ends up like:
>
> 	while (total_scan >= batch_size) {
> 		unsigned long ret;
> 		shrinkctl->nr_to_scan = batch_size;
> 		ret = shrinker->scan_objects(shrinker, shrinkctl);
>
> 		if (ret == SHRINK_STOP)
> 			break;
> 		freed += ret;
>
> 		count_vm_events(SLABS_SCANNED, batch_size);
> 		total_scan -= batch_size;
> 	}
>
> So we've already solved the problem you are concerned about....
>
> Cheers,
>
> Dave.
>

Thank you for all your comments. I have been keeping up with the mm-list 
for a while, but it was my first time having to send out patches and 
stuff. I only intended to ask for your reviews and feedbacks. Will make 
sure I get over the learning curve until next time around.

Thank you mm guys, Dave, Minchan and Andrew again.

-- 
Heesub
