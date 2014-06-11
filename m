Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbaFKLqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 07:46:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53388 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbaFKLqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 07:46:49 -0400
Message-ID: <539841A7.3040202@suse.cz>
Date: Wed, 11 Jun 2014 13:46:47 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, Mel Gorman <mgorman@suse.de>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 08/10] mm, compaction: pass gfp mask to compact_control
References: <1402305982-6928-1-git-send-email-vbabka@suse.cz> <1402305982-6928-8-git-send-email-vbabka@suse.cz> <20140611024855.GH15630@bbox>
In-Reply-To: <20140611024855.GH15630@bbox>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2014 04:48 AM, Minchan Kim wrote:
> On Mon, Jun 09, 2014 at 11:26:20AM +0200, Vlastimil Babka wrote:
>> From: David Rientjes <rientjes@google.com>
>>
>> struct compact_control currently converts the gfp mask to a migratetype, but we
>> need the entire gfp mask in a follow-up patch.
>>
>> Pass the entire gfp mask as part of struct compact_control.
>>
>> Signed-off-by: David Rientjes <rientjes@google.com>
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> Cc: Minchan Kim <minchan@kernel.org>
>> Cc: Mel Gorman <mgorman@suse.de>
>> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>> Cc: Michal Nazarewicz <mina86@mina86.com>
>> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
>> Cc: Christoph Lameter <cl@linux.com>
>> Cc: Rik van Riel <riel@redhat.com>
>> ---
>>   mm/compaction.c | 12 +++++++-----
>>   mm/internal.h   |  2 +-
>>   2 files changed, 8 insertions(+), 6 deletions(-)
>>
>> diff --git a/mm/compaction.c b/mm/compaction.c
>> index c339ccd..d1e30ba 100644
>> --- a/mm/compaction.c
>> +++ b/mm/compaction.c
>> @@ -965,8 +965,8 @@ static isolate_migrate_t isolate_migratepages(struct zone *zone,
>>   	return ISOLATE_SUCCESS;
>>   }
>>
>> -static int compact_finished(struct zone *zone,
>> -			    struct compact_control *cc)
>> +static int compact_finished(struct zone *zone, struct compact_control *cc,
>> +			    const int migratetype)
>
> If we has gfp_mask, we could use gfpflags_to_migratetype from cc->gfp_mask.
> What's is your intention?

Can't speak for David but I left it this way as it means 
gfpflags_to_migratetype is only called once per compact_zone. Now I 
realize my patch 10/10 repeats the call in isolate_migratepages_range so 
I'll probably update that as well.
