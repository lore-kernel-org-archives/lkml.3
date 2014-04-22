Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbaDVJwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 05:52:49 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:50354 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779AbaDVJwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 05:52:43 -0400
Message-ID: <53563BE4.6070703@gmail.com>
Date: Tue, 22 Apr 2014 17:52:36 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        len.brown@intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v2] kernel/power/hibernate.c: use 'u64' instead of 's64'
 to avoid warning
References: <5355C5F0.6020606@gmail.com> <20140422072112.GB14108@amd.pavel.ucw.cz> <535620C7.2080700@gmail.com>
In-Reply-To: <535620C7.2080700@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2014 03:56 PM, Chen Gang wrote:
> On 04/22/2014 03:21 PM, Pavel Machek wrote:
>> On Tue 2014-04-22 09:29:20, Chen Gang wrote:
>>> For do_div(), it need 'u64' type, which means the outside must be sure
>>> of 'start' is not bigger than 'stop', or it will report warning.
>>>
>>> Even if 'start' was really bigger than 'stop', it would print incorrect
>>> information, but for kernel, it still can continue, so use WARN_ON() is
>>> enough.
>>>
>>> The related warning (with allmodconfig for unicore32):
>>>
>>>     CC      kernel/power/hibernate.o
>>>   kernel/power/hibernate.c: In function ‘swsusp_show_speed’:
>>>   kernel/power/hibernate.c:237: warning: comparison of distinct pointer types lacks a cast
>>>
>>>
>>
>> Certainly better, but
>>
>>> -	s64 elapsed_centisecs64;
>>> +	u64 elapsed_centisecs64;
>>>  	int centisecs;
>>>  	int k;
>>>  	int kps;
>>>  
>>>  	elapsed_centisecs64 = timeval_to_ns(stop) - timeval_to_ns(start);
>>> +	WARN_ON((s64)elapsed_centisecs64 < 0);

How about to use one line comments instead of WARN_ON()?

	/*
	 * If "(s64)elapsed_centisecs64 < 0", it will print long elapsed
	 * time, it is obvious enough to user for what went wrong.
	 */

>>>  	do_div(elapsed_centisecs64, NSEC_PER_SEC / 100);
>>>  	centisecs = elapsed_centisecs64;
>>
>> ...do we need to do the WARN_ON()? Only result of underflow will be
>> very long elapsed time reported... that does not sound too
>> bad. ... and it will be quite obvious what went wrong.
>> 									Pavel
>>
> 
> Hmm... that sounds reasonable to me.  If no any other reply within 2
> days, I shall send patch v3 for it.
> 
> BTW: sorry, I guess I can not finish allmodconfig for unicore32 within
> this month (2014-04-30) -- at present I only finish 40-50%, I
> will/should try to finish it within next month.
> 
> 
> Thanks.
> 

-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
