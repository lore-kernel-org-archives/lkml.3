Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813AbaJHAun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 20:50:43 -0400
Received: from mga14.intel.com ([192.55.52.115]:29446 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755431AbaJHAum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 20:50:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="396849937"
From: Andi Kleen <andi@firstfloor.org>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@kernel.org>
Subject: Re: PERF_EVENT_IOC_SET_FILTER has different values based on bitness
References: <54347238.2060908@gmail.com> <5434749D.9070301@gmail.com>
Date: Tue, 07 Oct 2014 17:50:39 -0700
In-Reply-To: <5434749D.9070301@gmail.com> (David Ahern's message of "Tue, 07
	Oct 2014 17:17:49 -0600")
Message-ID: <87a957qt9c.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:
>>
>> diff --git a/kernel/events/core.c b/kernel/events/core.c
>> index 963bf139e2b2..c805132ac1cf 100644
>> --- a/kernel/events/core.c
>> +++ b/kernel/events/core.c
>> @@ -3714,6 +3714,7 @@ static long perf_ioctl(struct file *file, unsigned
>> int cmd, unsigned long arg)
>>      }
>>
>>      case PERF_EVENT_IOC_SET_FILTER:
>> +   case PERF_EVENT_IOC_SET_FILTER_32:
>>          return perf_event_set_filter(event, (void __user *)arg);
>>
>>      default:
>>
>
> Oh, PERF_EVENT_IOC_ID has the same problem:
>
> #define PERF_EVENT_IOC_ID               _IOR('$', 7, __u64 *)

The right way is to add a compat_perf_ioctl() 

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
