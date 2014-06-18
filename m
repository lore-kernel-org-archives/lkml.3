Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbaFRPbK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:31:10 -0400
Received: from g6t1525.atlanta.hp.com ([15.193.200.68]:32068 "EHLO
	g6t1525.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaFRPbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:31:08 -0400
Message-ID: <53A1B0B8.6070505@hp.com>
Date: Wed, 18 Jun 2014 11:31:04 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v2 1/2] mm, thp: move invariant bug check out of loop
 in __split_huge_page_map
References: <1403044679-9993-1-git-send-email-Waiman.Long@hp.com> <1403044679-9993-2-git-send-email-Waiman.Long@hp.com> <20140618122442.GB5957@node.dhcp.inet.fi>
In-Reply-To: <20140618122442.GB5957@node.dhcp.inet.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2014 08:24 AM, Kirill A. Shutemov wrote:
> On Tue, Jun 17, 2014 at 06:37:58PM -0400, Waiman Long wrote:
>> In the __split_huge_page_map() function, the check for
>> page_mapcount(page) is invariant within the for loop. Because of the
>> fact that the macro is implemented using atomic_read(), the redundant
>> check cannot be optimized away by the compiler leading to unnecessary
>> read to the page structure.
>>
>> This patch moves the invariant bug check out of the loop so that it
>> will be done only once. On a 3.16-rc1 based kernel, the execution
>> time of a microbenchmark that broke up 1000 transparent huge pages
>> using munmap() had an execution time of 38,245us and 38,548us with
>> and without the patch respectively. The performance gain is about 1%.
> For this low difference it would be nice to average over few runs +
> stddev. It can easily can be a noise.

The timing data was the average of 5 runs with a SD of 100-200us.
>> Signed-off-by: Waiman Long<Waiman.Long@hp.com>
> But okay:
>
> Acked-by: Kirill A. Shutemov<kirill.shutemov@linux.intel.com>
>

Thank for the review.

-Longman
