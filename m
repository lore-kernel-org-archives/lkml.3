Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbaKDPJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:09:14 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:52640 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbaKDPJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:09:10 -0500
MIME-Version: 1.0
In-Reply-To: <20141104094707.79e9ca86@gandalf.local.home>
References: <1415099585-31174-1-git-send-email-pang.xunlei@linaro.org>
	<1415099585-31174-2-git-send-email-pang.xunlei@linaro.org>
	<20141104075237.4eb9b5e6@gandalf.local.home>
	<CADcy93XK9-p3iFw28qeA=q9Fp4_Qbd1Hoig6Tu5G+QfwxNWiow@mail.gmail.com>
	<20141104094707.79e9ca86@gandalf.local.home>
Date: Tue, 4 Nov 2014 23:09:09 +0800
Message-ID: <CADcy93Xeb8+pkyjPCazpA5_fhZycrYNf654Ev6j2tEkwqdJXmg@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] sched/rt: Optimize select_task_rq_rt() for non-RT
 curr task
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 November 2014 22:47, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 4 Nov 2014 22:29:24 +0800
> "pang.xunlei" <pang.xunlei@linaro.org> wrote:
>
>
>> > Migration is not cheap. It causes cache misses and TLB flushes. This is
>> > not something that should be taken lightly.
>> Ok, thanks!
>> But I think the PUSH operation optimized by the former patch is reasonable,
>> since PUSH itselft does involve the Migration. Do I miss something?
>
> For the first patch you may be right, but I want to think about it some
> more. I want to make sure we are not adding any other type of overhead
> with the extra calls.
Yes, this may cause some overhead/latency in idle especially its exit
stage, if that can't be accepted, I think it can also be done just in
find_lowest_rq() after cpupri_find(), we can modify cpupri_find() for
example to return a pri_to_cpu[] index plus one instead of 1, then if
the return index equals CPUPRI_NORMAL+1, then iterate the
"lowest_mask" with something like cpu_idle() judgement to select the
idle cpu.

>
> -- Steve
