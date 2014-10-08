Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbaJHAx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 20:53:29 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:44975 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827AbaJHAx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 20:53:27 -0400
Message-ID: <54348AFF.7040809@gmail.com>
Date: Tue, 07 Oct 2014 18:53:19 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@kernel.org>
Subject: Re: PERF_EVENT_IOC_SET_FILTER has different values based on bitness
References: <54347238.2060908@gmail.com> <5434749D.9070301@gmail.com> <87a957qt9c.fsf@tassilo.jf.intel.com>
In-Reply-To: <87a957qt9c.fsf@tassilo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/7/14, 6:50 PM, Andi Kleen wrote:
> David Ahern <dsahern@gmail.com> writes:
>>>
>>> diff --git a/kernel/events/core.c b/kernel/events/core.c
>>> index 963bf139e2b2..c805132ac1cf 100644
>>> --- a/kernel/events/core.c
>>> +++ b/kernel/events/core.c
>>> @@ -3714,6 +3714,7 @@ static long perf_ioctl(struct file *file, unsigned
>>> int cmd, unsigned long arg)
>>>       }
>>>
>>>       case PERF_EVENT_IOC_SET_FILTER:
>>> +   case PERF_EVENT_IOC_SET_FILTER_32:
>>>           return perf_event_set_filter(event, (void __user *)arg);
>>>
>>>       default:
>>>
>>
>> Oh, PERF_EVENT_IOC_ID has the same problem:
>>
>> #define PERF_EVENT_IOC_ID               _IOR('$', 7, __u64 *)
>
> The right way is to add a compat_perf_ioctl()

Sure, looked into that way as well. But SET_FILTER and IOC_ID will still 
compile to the same values for a 64-bit kernel.

David

