Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab3LCCwP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 21:52:15 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:53735 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab3LCCwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 21:52:14 -0500
MIME-Version: 1.0
In-Reply-To: <20131202152329.GD22695@tassilo.jf.intel.com>
References: <CABPqkBTiBHF4wZ3c_Czkh3JgvXGNWJW1LH42Jh4NG_ZJkGkbgw@mail.gmail.com>
	<20131115063457.GB12442@gmail.com>
	<CABPqkBQ2wD_knJP9FQxThSxNng4DZhtRxeUUAW0efAs9=jBXEA@mail.gmail.com>
	<20131115103405.GA18264@gmail.com>
	<20131117034134.GA19762@tassilo.jf.intel.com>
	<20131129133340.GA25751@krava.brq.redhat.com>
	<20131202152329.GD22695@tassilo.jf.intel.com>
Date: Tue, 3 Dec 2013 03:52:13 +0100
Message-ID: <CABPqkBQuY0VDKVhFGscAtK2vZjaSJQBCEtVCk4km-bKW85Zx-A@mail.gmail.com>
Subject: Re: [BUG] perf stat: explicit grouping yields unexpected results
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 2, 2013 at 4:23 PM, Andi Kleen <ak@linux.intel.com> wrote:
>> Something like below? user space supply buffer for error string.
>
> That would work, although I was thinking of making it a more
> generic mechanism (store it into task_struct, have a extra
> syscall to retrieve)
>
I don't understand why this need to be so complicated.
Maybe just change the error code in case of group
overcommitment? That way, the tool could distinguish
and report the appropriate error message.


>> jirka
>>
>>
>> ---
>> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
>> index e1802d6..a827870 100644
>> --- a/include/uapi/linux/perf_event.h
>> +++ b/include/uapi/linux/perf_event.h
>> @@ -331,8 +331,8 @@ struct perf_event_attr {
>>        */
>>       __u32   sample_stack_user;
>>
>> -     /* Align to u64. */
>> -     __u32   __reserved_2;
>> +     __u32   errstr_size;
>> +     char    *errstr;
>>  };
>>
>>  #define perf_flags(attr)     (*(&(attr)->read_format + 1))
>>
>
> --
> ak@linux.intel.com -- Speaking for myself only
