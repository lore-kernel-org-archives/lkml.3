Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678Ab3JQP7d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 11:59:33 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:51441 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757633Ab3JQP7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 11:59:31 -0400
Message-ID: <52600960.1090907@gmail.com>
Date: Thu, 17 Oct 2013 09:59:28 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v2] perf: disable PERF_RECORD_MMAP2 support
References: <20131017142839.GA8482@quad>	<52600821.9010304@gmail.com> <CABPqkBR1LhiL-HpbffZAZ=HouFnGRaxvkgREBFUy3HsMXCA=jg@mail.gmail.com>
In-Reply-To: <CABPqkBR1LhiL-HpbffZAZ=HouFnGRaxvkgREBFUy3HsMXCA=jg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/13 9:57 AM, Stephane Eranian wrote:
> On Thu, Oct 17, 2013 at 5:54 PM, David Ahern <dsahern@gmail.com> wrote:
>> On 10/17/13 8:28 AM, Stephane Eranian wrote:
>>>
>>>
>>> For now, we disable the extended MMAP record support (MMAP2).
>>> We have identified cases where it would not report the correct
>>> mapping information, clone(VM_CLONE) but with separate pids.
>>> We will revisit the support once we find a solution for this case.
>>>
>>> The patch changes the kernel to return EINVAL if attr->mmap2
>>> is set. The patch also modifies the perf tool to use regular
>>> PERF_RECORD_MMAP
>>> for synthetic events and it also prevents the tool from requesting
>>> attr->mmap2
>>> mode because the kernel would reject it.
>>>
>>> The support will be revisited once the kenrel interface is updated.
>>
>>
>> Why not disable mmap2 as well:
>>
>> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
>> index 0ce9febf1ba0..289f34dbe970 100644
>> --- a/tools/perf/util/evsel.c
>> +++ b/tools/perf/util/evsel.c
>> @@ -678,7 +678,7 @@ void perf_evsel__config(struct perf_evsel *evsel,
>>          attr->sample_type   |= PERF_SAMPLE_WEIGHT;
>>
>>      attr->mmap  = track;
>> -   attr->mmap2 = track && !perf_missing_features.mmap2;
>> +   /* attr->mmap2 = track && !perf_missing_features.mmap2; */
>>      attr->comm  = track;
>>
> It is disabled automatically later on. I checked that. Wanted to minimize
> the changes.
>

Understood that the fallback kicks in. Why fail the perf_event_open 
every single time when we know it is not going to succeed?

David
