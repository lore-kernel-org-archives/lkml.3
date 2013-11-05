Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab3KEOEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 09:04:13 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:34571 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905Ab3KEOEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 09:04:12 -0500
MIME-Version: 1.0
In-Reply-To: <20131105140030.GA30283@krava.brq.redhat.com>
References: <1383231582-15856-1-git-send-email-eranian@google.com>
	<1383231582-15856-3-git-send-email-eranian@google.com>
	<20131101105722.GA1088@krava.brq.redhat.com>
	<CABPqkBRXPYHNmCbcGDvqSNxY_zWfUiy3S3_9SasrVw9nbNL9Mg@mail.gmail.com>
	<20131104145110.GA2805@krava.brq.redhat.com>
	<CABPqkBQ1Kv9MMBhRdNoBA4k=n=cGVQtuUn810P7-PSu_SRwLug@mail.gmail.com>
	<20131105140030.GA30283@krava.brq.redhat.com>
Date: Tue, 5 Nov 2013 15:04:09 +0100
Message-ID: <CABPqkBTUJhnCNM_qMAbmHSam4W+j6Vq+X+9awEyOJn1nCt9aFg@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] perf stat: add event unit and scale support
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Borislav Petkov <bp@alien8.de>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 5, 2013 at 3:00 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Tue, Nov 05, 2013 at 02:34:45PM +0100, Stephane Eranian wrote:
>> Hi,
>>
>> One thing I realized while testing is that we cannot simply add the
>> unit printout like that.
>> This may break all the scripts people may have written to parse the
>> output of perf stat.
>
> isn't it what the -x output is meant for?
>
>   perf stat -x, ...
>
Somewhat. It is used to make parsing easy for the perf stat output.
But if you have a script that was expecting 2222267,cycles and now
is getting 222267,?,cycles. Things will break.


>   1.738605,task-clock
>   367,context-switches
>   0,cpu-migrations
>   272,page-faults
>   6722006,cycles
>   2592661,stalled-cycles-frontend
>   1935855,stalled-cycles-backend
>   4324013,instructions
>   823229,branches
>   11192,branch-misses
>
>> I think we need to make the display of the unit optional. If I do:
>>    $ perf stat -e cycles ls
>>
>> The output should remain as it was before and not show:
>> $ perf stat -e cycles ls
>>       22782847475 ? cycles
>
> maybe we should display just space ' ' instead
> of the '?' ...seems confusing
>
But then, it is not so good for the -x option to get ' ' in the csv output.

>>
>> So I think we need a --show-unit option. It would be off by default.
>> Of course doing this causes a mess with the current code because
>> of all the various printf() in builtin-stat.c but I think it is better for
>> the end user.
>>
>> Any opinion?
>
> I haven't checked by I think we changed the default perf stat
> output in the past without any fuzz
>
> maybe just keep the -x output or add the unit
> to the end of the line
>
Well, that's what I had initially. But then people thought it was more
natural to have in before the event. I agreed with that.

I almost have the --show-unit option working now. I think we should
go with that.
