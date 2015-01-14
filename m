Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbbANL2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 06:28:08 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:39672 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbbANL2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 06:28:07 -0500
Message-ID: <54B652BF.9020300@codeaurora.org>
Date: Wed, 14 Jan 2015 16:57:59 +0530
From: Vinayak Menon <vinmenon@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, vdavydov@parallels.com, mhocko@suse.cz,
        mgorman@suse.de, minchan@kernel.org
Subject: Re: [PATCH] mm: vmscan: fix the page state calculation in too_many_isolated
References: <1421147247-10870-1-git-send-email-vinmenon@codeaurora.org> <20150113160940.GD8180@phnom.home.cmpxchg.org>
In-Reply-To: <20150113160940.GD8180@phnom.home.cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2015 09:39 PM, Johannes Weiner wrote:
> On Tue, Jan 13, 2015 at 04:37:27PM +0530, Vinayak Menon wrote:
>> @@ -1392,6 +1392,44 @@ int isolate_lru_page(struct page *page)
>>   	return ret;
>>   }
>>
>> +static int __too_many_isolated(struct zone *zone, int file,
>> +	struct scan_control *sc, int safe)
>> +{
>> +	unsigned long inactive, isolated;
>> +
>> +	if (file) {
>> +		if (safe) {
>> +			inactive = zone_page_state_snapshot(zone,
>> +					NR_INACTIVE_FILE);
>> +			isolated = zone_page_state_snapshot(zone,
>> +					NR_ISOLATED_FILE);
>> +		} else {
>> +			inactive = zone_page_state(zone, NR_INACTIVE_FILE);
>> +			isolated = zone_page_state(zone, NR_ISOLATED_FILE);
>> +		}
>> +	} else {
>> +		if (safe) {
>> +			inactive = zone_page_state_snapshot(zone,
>> +					NR_INACTIVE_ANON);
>> +			isolated = zone_page_state_snapshot(zone,
>> +					NR_ISOLATED_ANON);
>> +		} else {
>> +			inactive = zone_page_state(zone, NR_INACTIVE_ANON);
>> +			isolated = zone_page_state(zone, NR_ISOLATED_ANON);
>> +		}
>> +	}
>
> 	if (safe) {
> 		inactive = zone_page_state_snapshot(zone, NR_INACTIVE_ANON + 2*file)
> 		isolated = zone_page_state_snapshot(zone, NR_ISOLATED_ANON + file)
> 	} else {
> 		inactive = zone_page_state(zone, NR_INACTIVE_ANON + 2*file)
> 		isolated = zone_page_state(zone, NR_ISOLATED_ANON + file)
> 	}
>

Ok. Will change that.

-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a
member of the Code Aurora Forum, hosted by The Linux Foundation
