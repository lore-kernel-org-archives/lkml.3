Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbaCYIsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 04:48:11 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:55404 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbaCYIsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 04:48:06 -0400
Date: Tue, 25 Mar 2014 09:48:02 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: =?iso-8859-1?Q?H=E5vard?= Skinnemoen <hskinnemoen@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/avr32/mm/cache.c: export symbol
 flush_icache_range() for module using
Message-ID: <20140325084802.GA30149@samfundet.no>
References: <531B8D32.6000000@gmail.com>
 <531B8FD8.6040704@gmail.com>
 <20140308221721.GA30934@samfundet.no>
 <531C8683.2010908@gmail.com>
 <5324C3B2.1000802@gmail.com>
 <532E18EE.3090008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <532E18EE.3090008@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Sun 23 Mar 2014 07:12:46 +0800 or thereabout, Chen Gang wrote:
> Is this patch OK?
> 

I reread everything you said, and it looks sane.

> If it is necessary to continue analysing more details, please let me
> know, and I will/should continue.

No, I will append it to my for-linus branch, and submit it early in the next
cycle. It should be just around the corner, Linus just released rc8 (-:

> On 03/16/2014 05:18 AM, Chen Gang wrote:
>> On 03/09/2014 11:19 PM, Chen Gang wrote:
>>> On 03/09/2014 06:17 AM, Hans-Christian Egtvedt wrote:
>>>> Around Sun 09 Mar 2014 05:47:04 +0800 or thereabout, Chen Gang wrote:
>>>>>
>>>>> After this patch, our linux kernel can pass "avr32-linux-" allmodconfig
>>>>> (it contents quite a few of warnings, but after check, I guess they are
>>>>> not kernel's issue).
>>>>
>>>> That sounds great, I am a bit surprised however that the lkdtm module need
>>>> flush_icache_range. Would have been interesting to look into what causes this
>>>> dependency.
>>>>
>> 
>> After read a little more details for lkdtm, I guess "after overwrite an
>> executable area by do_nothing(), it needs flush_icache_range() to be
>> sure the new instructions/data must have effect with all cpu".
>> 
>> Welcome any additional information for it.
>> 
>> Thanks.
>> 
>>>
>>> "driver/misc/lkdtm.c" will use this flush_icache_range().
>>>
>>> And some architectures export it to modules.
>>>
>>>   [root@gchen arch]# grep -rn flush_icache_range * | grep EXPORT
>>>   arm64/mm/flush.c:105:EXPORT_SYMBOL(flush_icache_range);
>>>   avr32/mm/cache.c:114:EXPORT_SYMBOL(flush_icache_range);
>>>   m68k/mm/cache.c:106:EXPORT_SYMBOL(flush_icache_range);
>>>   mn10300/mm/cache-inv-icache.c:129:EXPORT_SYMBOL(flush_icache_range);
>>>   mn10300/mm/cache-flush-icache.c:155:EXPORT_SYMBOL(flush_icache_range);
>>>   sparc/mm/init_64.c:435:EXPORT_SYMBOL(flush_icache_range);
>>>
>>> Welcome any more details information by any other members, thanks.
>> 
>> Thanks.
-- 
mvh
Hans-Christian Egtvedt
