Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760252Ab3HODjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 23:39:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:31015 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760198Ab3HODje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 23:39:34 -0400
X-IronPort-AV: E=Sophos;i="4.89,881,1367942400"; 
   d="scan'208";a="8206498"
Message-ID: <520C4D24.40701@cn.fujitsu.com>
Date: Thu, 15 Aug 2013 11:38:12 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org,
        liwanp@linux.vnet.ibm.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] memblock cleanup: Remove unnecessary check in memblock_find_in_range_node()
References: <1376536999-4562-1-git-send-email-tangchen@cn.fujitsu.com> <20130815032746.GC4439@htj.dyndns.org>
In-Reply-To: <20130815032746.GC4439@htj.dyndns.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/15 11:37:57,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/15 11:37:57,
	Serialize complete at 2013/08/15 11:37:57
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2013 11:27 AM, Tejun Heo wrote:
> Hello, Tang.
>
> On Thu, Aug 15, 2013 at 11:23:19AM +0800, Tang Chen wrote:
>> Furthermore, we don't need to check "if (this_end<  size)" actually. Without
>> this confusing check, we only waste some loops. So this patch removes the
>> check.
>>
>> Signed-off-by: Tang Chen<tangchen@cn.fujitsu.com>
>> ---
>>   mm/memblock.c |    3 ---
>>   1 files changed, 0 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/memblock.c b/mm/memblock.c
>> index a847bfe..e0c626e 100644
>> --- a/mm/memblock.c
>> +++ b/mm/memblock.c
>> @@ -114,9 +114,6 @@ phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
>>   		this_start = clamp(this_start, start, end);
>>   		this_end = clamp(this_end, start, end);
>>
>> -		if (this_end<  size)
>> -			continue;
>> -
>>   		cand = round_down(this_end - size, align);
>>   		if (cand>= this_start)
>>   			return cand;
>
> Hmmm... maybe I'm missing something but are you sure?  "this_end -
> size" can underflow and "cand>= this_start" will be true incorrectly.
>

Oh, you are right... Please ignore this. I didn't read it carefully.

Thanks.

