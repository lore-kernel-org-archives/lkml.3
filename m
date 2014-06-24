Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbaFXPee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:34:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47384 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574AbaFXPed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:34:33 -0400
Message-ID: <53A99A88.1040500@suse.cz>
Date: Tue, 24 Jun 2014 17:34:32 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 04/13] mm, compaction: move pageblock checks up from
 isolate_migratepages_range()
References: <1403279383-5862-1-git-send-email-vbabka@suse.cz> <1403279383-5862-5-git-send-email-vbabka@suse.cz> <20140624045252.GA18289@nhori.bos.redhat.com>
In-Reply-To: <20140624045252.GA18289@nhori.bos.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2014 06:52 AM, Naoya Horiguchi wrote:
>> -	low_pfn = isolate_migratepages_range(zone, cc, low_pfn, end_pfn, false);
>> -	if (!low_pfn || cc->contended)
>> -		return ISOLATE_ABORT;
>> +		/* Do not scan within a memory hole */
>> +		if (!pfn_valid(low_pfn))
>> +			continue;
>> +
>> +		page = pfn_to_page(low_pfn);
>
> Can we move (page_zone != zone) check here as isolate_freepages() does?

Duplicate perhaps, not sure about move. Does CMA make sure that all 
pages are in the same zone? Common sense tells me it would be useless 
otherwise, but I haven't checked if we can rely on it.

> Thanks,
> Naoya Horiguchi
>

