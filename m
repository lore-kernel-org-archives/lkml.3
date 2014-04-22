Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449AbaDVMK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 08:10:57 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:47477 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932386AbaDVMKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 08:10:53 -0400
Message-ID: <53565C45.10101@gmail.com>
Date: Tue, 22 Apr 2014 20:10:45 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Pavel Machek <pavel@ucw.cz>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        len.brown@intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v2] kernel/power/hibernate.c: use 'u64' instead of 's64'
 to avoid warning
References: <5355C5F0.6020606@gmail.com> <535620C7.2080700@gmail.com> <53563BE4.6070703@gmail.com> <2615793.oZSY6rO6uY@vostro.rjw.lan>
In-Reply-To: <2615793.oZSY6rO6uY@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/22/2014 07:29 PM, Rafael J. Wysocki wrote:
> On Tuesday, April 22, 2014 05:52:36 PM Chen Gang wrote:
>> On 04/22/2014 03:56 PM, Chen Gang wrote:
>>> On 04/22/2014 03:21 PM, Pavel Machek wrote:
>>>> On Tue 2014-04-22 09:29:20, Chen Gang wrote:
>>>>> For do_div(), it need 'u64' type, which means the outside must be sure
>>>>> of 'start' is not bigger than 'stop', or it will report warning.
>>>>>
>>>>> Even if 'start' was really bigger than 'stop', it would print incorrect
>>>>> information, but for kernel, it still can continue, so use WARN_ON() is
>>>>> enough.
>>>>>
>>>>> The related warning (with allmodconfig for unicore32):
>>>>>
>>>>>     CC      kernel/power/hibernate.o
>>>>>   kernel/power/hibernate.c: In function ‘swsusp_show_speed’:
>>>>>   kernel/power/hibernate.c:237: warning: comparison of distinct pointer types lacks a cast
>>>>>
>>>>>
>>>>
>>>> Certainly better, but
>>>>
>>>>> -	s64 elapsed_centisecs64;
>>>>> +	u64 elapsed_centisecs64;
>>>>>  	int centisecs;
>>>>>  	int k;
>>>>>  	int kps;
>>>>>  
>>>>>  	elapsed_centisecs64 = timeval_to_ns(stop) - timeval_to_ns(start);
>>>>> +	WARN_ON((s64)elapsed_centisecs64 < 0);
>>
>> How about to use one line comments instead of WARN_ON()?
>>
>> 	/*
>> 	 * If "(s64)elapsed_centisecs64 < 0", it will print long elapsed
>> 	 * time, it is obvious enough to user for what went wrong.
>> 	 */
> 
> And will the users actually read this comment?
> 

For subtractions, normally, need signed number, or may let code readers
notice about it. When the code readers read this comment, they will
understand, and save their time to think of.

Normally, it is not good to add comment within a function, except the
code is not written in a normal way, and need some comments to avoid
wasting readers' time.

> Please just change the type to silence the warning.  And you can change all of
> the other local variables in that function to unsigned int when you're at it.
> 

It is fine to me -- change all of the other local variables to unsigned int.


Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
