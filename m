Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015AbaBST7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 14:59:11 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:59448 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640AbaBST7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 14:59:09 -0500
MIME-Version: 1.0
In-Reply-To: <20140219183623.GL27965@twins.programming.kicks-ass.net>
References: <20140210221758.GB11542@dreric01-Precision-T1600>
	<20140218101831.GB4178@mudshark.cambridge.arm.com>
	<20140219162819.GP15586@twins.programming.kicks-ass.net>
	<CABPqkBQS355_XW-2KthkdZkzQnApRvOpANkB3SnfFyac-qsJaw@mail.gmail.com>
	<20140219183623.GL27965@twins.programming.kicks-ass.net>
Date: Wed, 19 Feb 2014 20:59:08 +0100
Message-ID: <CABPqkBS15h1p4gaaqJ0ExE35QcoFQ5dsVKeYcXi=jZ_9GB-BHg@mail.gmail.com>
Subject: Re: Perf Oops on 3.14-rc2
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>,
        Drew Richardson <drew.richardson@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo <acme@redhat.com>, Pawel Moll <Pawel.Moll@arm.com>,
        Wade Cherry <Wade.Cherry@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 7:36 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Feb 19, 2014 at 07:03:13PM +0100, Stephane Eranian wrote:
>> I am trying to understand the context here.
>> Are you saying, we may call an offline CPU?
>
> Yes, that is what's happening.
>
>> I saw that sometimes you retry, sometimes you don't.
>
> I tried to do exactly what we do for the task case which is far more
> likely to fail. Could be I messed up.
>
I am not sure why you need to retry. If the CPU is offline, it is offline.
Or are you saying, you get an error, but you don't know the exact
reason, thus you keep trying? But how do you get out of this if
the CPU stays offline?


> I should probably write the function differently and have a common retry
> path instead of duplicating everything.
>
>> For perf_cgroup_attach(), we invoke task_function_call()
>> to force a PMU context switch on the task which is now monitored in cgroup mode.
>> If the CPU is offline then, the task is switched out and monitoring
>> has been stoppe,
>>  no need to retry or do anything more.
>>
>> For perf_cgroup_exit(), this is pretty much the same logic.
>>
>> am I missing anything else?
>
> Don't think so; I'll add a comment there. I was just too tired to make
> sense of things.
