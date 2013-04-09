Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936117Ab3DIOFM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 10:05:12 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:54849 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762362Ab3DIOFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 10:05:08 -0400
MIME-Version: 1.0
In-Reply-To: <1365513368.25498.47.camel@gandalf.local.home>
References: <1365084959-28374-1-git-send-email-vincent.guittot@linaro.org>
	<1365497753.2609.163.camel@laptop>
	<CAKfTPtDKSkhi+nNsFV9Z6hsLxhbHd-Na9YxvNzr9iXG8SdQvhQ@mail.gmail.com>
	<1365513368.25498.47.camel@gandalf.local.home>
Date: Tue, 9 Apr 2013 16:05:07 +0200
Message-ID: <CAKfTPtCmARJS=VW52r43P_P+Dt5=dg_+5ochPcGZGH1b8bXGSw@mail.gmail.com>
Subject: Re: [PATCH v4] sched: fix wrong rq's runnable_avg update with rt tasks
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 April 2013 15:16, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2013-04-09 at 14:18 +0200, Vincent Guittot wrote:
>> On 9 April 2013 10:55, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Thu, 2013-04-04 at 16:15 +0200, Vincent Guittot wrote:
>> >> Changes since V2:
>> >> - remove useless definition for UP platform
>> >> - rebased on top of Steven Rostedt's patches :
>> >> https://lkml.org/lkml/2013/2/12/558
>> >
>> > So what's the status of those patches? I still worry about the extra
>> > context switch overhead for the high-frequency idle scenario.
>>
>> I don't know. I have seen a pulled answer from Ingo but can't find the
>> commits in the tip tree.
>>
>> Steve, have you got more info about the status of your patches ?
>>
>
> Yeah, I asked Ingo to revert it due to Peter's concerns. I was able to
> get the latencies I needed without that patch set. That made it not so
> urgent.
>
> Can you rebase your patches doing something similar? That is, still use
> the pre/post_schedule_idle() calls, but don't base it off of my patch
> set.

Yes. I'm going to rebase my patches and add the declaration of
post_schedule_idle in my patch instead of using your patch

Thanks,
Vincent

>
> Thanks,
>
> -- Steve
>
>
