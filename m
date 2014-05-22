Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349AbaEVSpL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 14:45:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47274 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbaEVSpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 14:45:09 -0400
Message-ID: <537E45B0.8040304@suse.cz>
Date: Thu, 22 May 2014 20:45:04 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mgorman@suse.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Jan Kara <jack@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 09/19] mm: page_alloc: Use word-based accesses for get/set
 pageblock bitmaps
References: <1399974350-11089-1-git-send-email-mgorman@suse.de>	<1399974350-11089-10-git-send-email-mgorman@suse.de>	<537DC247.5020801@suse.cz> <20140522112357.4715059bb69273f40c3ec4f2@linux-foundation.org>
In-Reply-To: <20140522112357.4715059bb69273f40c3ec4f2@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.5.2014 20:23, Andrew Morton wrote:
> On Thu, 22 May 2014 11:24:23 +0200 Vlastimil Babka <vbabka@suse.cz> wrote:
>
>>> In a test running dd onto tmpfs the overhead of the pageblock-related
>>> functions went from 1.27% in profiles to 0.5%.
>>>
>>> Signed-off-by: Mel Gorman <mgorman@suse.de>
>>> Acked-by: Vlastimil Babka <vbabka@suse.cz>
>> Hi, I've tested if this closes the race I've been previously trying to fix
>> with the series in http://marc.info/?l=linux-mm&m=139359694028925&w=2
>> And indeed with this patch I wasn't able to reproduce it in my stress test
>> (which adds lots of memory isolation calls) anymore. So thanks to Mel I can
>> dump my series in the trashcan :P
>>
>> Therefore I believe something like below should be added to the changelog,
>> and put to stable as well.
> OK, I made it so.

Thanks.

> Miraculously, the patch applies OK to 3.14.  And it compiles!

Great, shipping time!

Vlastimil
