Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994Ab3JQQJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 12:09:53 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:51529 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757077Ab3JQQJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 12:09:52 -0400
MIME-Version: 1.0
In-Reply-To: <52600960.1090907@gmail.com>
References: <20131017142839.GA8482@quad>
	<52600821.9010304@gmail.com>
	<CABPqkBR1LhiL-HpbffZAZ=HouFnGRaxvkgREBFUy3HsMXCA=jg@mail.gmail.com>
	<52600960.1090907@gmail.com>
Date: Thu, 17 Oct 2013 18:09:47 +0200
Message-ID: <CABPqkBQDm=Kja99P=4C5n72LfNVN5HPtm4STxW5tKgwkQOJ-LA@mail.gmail.com>
Subject: Re: [PATCH v2] perf: disable PERF_RECORD_MMAP2 support
From: Stephane Eranian <eranian@google.com>
To: David Ahern <dsahern@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 5:59 PM, David Ahern <dsahern@gmail.com> wrote:
> On 10/17/13 9:57 AM, Stephane Eranian wrote:
>>
>> On Thu, Oct 17, 2013 at 5:54 PM, David Ahern <dsahern@gmail.com> wrote:
>>>
>>> On 10/17/13 8:28 AM, Stephane Eranian wrote:
>>>>
>>>>
>>>>
>>>> For now, we disable the extended MMAP record support (MMAP2).
>>>> We have identified cases where it would not report the correct
>>>> mapping information, clone(VM_CLONE) but with separate pids.
>>>> We will revisit the support once we find a solution for this case.
>>>>
>>>> The patch changes the kernel to return EINVAL if attr->mmap2
>>>> is set. The patch also modifies the perf tool to use regular
>>>> PERF_RECORD_MMAP
>>>> for synthetic events and it also prevents the tool from requesting
>>>> attr->mmap2
>>>> mode because the kernel would reject it.
>>>>
>>>> The support will be revisited once the kenrel interface is updated.
>>>
>>>
>>>
>>> Why not disable mmap2 as well:
>>>
>>> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
>>> index 0ce9febf1ba0..289f34dbe970 100644
>>> --- a/tools/perf/util/evsel.c
>>> +++ b/tools/perf/util/evsel.c
>>> @@ -678,7 +678,7 @@ void perf_evsel__config(struct perf_evsel *evsel,
>>>          attr->sample_type   |= PERF_SAMPLE_WEIGHT;
>>>
>>>      attr->mmap  = track;
>>> -   attr->mmap2 = track && !perf_missing_features.mmap2;
>>> +   /* attr->mmap2 = track && !perf_missing_features.mmap2; */
>>>      attr->comm  = track;
>>>
>> It is disabled automatically later on. I checked that. Wanted to minimize
>> the changes.
>>
>
> Understood that the fallback kicks in. Why fail the perf_event_open every
> single time when we know it is not going to succeed?
>
Ok, I can add that.
