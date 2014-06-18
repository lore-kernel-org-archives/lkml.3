Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965657AbaFRJy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 05:54:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756481AbaFRJy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 05:54:26 -0400
Message-ID: <53A161C1.2070304@redhat.com>
Date: Wed, 18 Jun 2014 11:54:09 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Chen Yucong <slaoub@gmail.com>
CC: akpm@linux-foundation.org, minchan@kernel.org, mgorman@suse.de,
        hannes@cmpxchg.org, mhocko@suse.cz, riel@redhat.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan.c: fix an implementation flaw in proportional
 scanning
References: <1402980902-6345-1-git-send-email-slaoub@gmail.com>	 <53A15544.2010505@redhat.com> <1403082532.9368.4.camel@debian>
In-Reply-To: <1403082532.9368.4.camel@debian>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2014 11:08 AM, Chen Yucong wrote:
> On Wed, 2014-06-18 at 11:00 +0200, Jerome Marchand wrote:
>>>               if (!nr_file || !nr_anon)
>>>                       break;
>>>  
>>> -             if (nr_file > nr_anon) {
>>> -                     unsigned long scan_target =
>> targets[LRU_INACTIVE_ANON] +
>>>
>> -                                             targets[LRU_ACTIVE_ANON]
>> + 1;
>>> +             file_percent = nr_file * 100 / file_target;
>>> +             anon_percent = nr_anon * 100 / anon_target;
>>
>> Here it could happen.
>>
>>
> The snippet 
> 	...
>                if (!nr_file || !nr_anon)
>                       break;

Looks like nr[] values can only decrease and stay positive. Then the
following should be true at all times:

file_target >= nr_file >= 0
anon_target >= nr_anon >= 0

and the code above should indeed avoid the divide by zero.

Thanks,
Jerome

>         ...
>  can help us to filter the situation which you have described. It comes
> from Mel's patch that is called:
> 
> mm: vmscan: use proportional scanning during direct reclaim and full
> scan at DEF_PRIORITY
> 
> thx!
> cyc
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

