Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbaKDO31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 09:29:27 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:40008 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbaKDO3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:29:25 -0500
MIME-Version: 1.0
In-Reply-To: <20141104075237.4eb9b5e6@gandalf.local.home>
References: <1415099585-31174-1-git-send-email-pang.xunlei@linaro.org>
	<1415099585-31174-2-git-send-email-pang.xunlei@linaro.org>
	<20141104075237.4eb9b5e6@gandalf.local.home>
Date: Tue, 4 Nov 2014 22:29:24 +0800
Message-ID: <CADcy93XK9-p3iFw28qeA=q9Fp4_Qbd1Hoig6Tu5G+QfwxNWiow@mail.gmail.com>
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

On 4 November 2014 20:52, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue,  4 Nov 2014 19:13:01 +0800
> "pang.xunlei" <pang.xunlei@linaro.org> wrote:
>
>> When selecting the cpu for a waking RT task, if curr is a non-RT
>> task which is bound only on this cpu, then we can give it a chance
>> to select a different cpu(definitely an idle cpu if existing) for
>> the RT task to avoid curr starving.
>
> Absolutely not! An RT task doesn't give a crap if a non RT task is
> bound to a CPU or not. We are not going to migrate an RT task to be
> nice to a bounded non-RT task.
>
> Migration is not cheap. It causes cache misses and TLB flushes. This is
> not something that should be taken lightly.
Ok, thanks!
But I think the PUSH operation optimized by the former patch is reasonable,
since PUSH itselft does involve the Migration. Do I miss something?

>
> Nack
>
> -- Steve
>
