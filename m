Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbbA1Uwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:52:39 -0500
Received: from mail-yk0-f178.google.com ([209.85.160.178]:36683 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbbA1Uwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:52:35 -0500
MIME-Version: 1.0
In-Reply-To: <20150127180438.445d8e76@gandalf.local.home>
References: <1421642980-10045-1-git-send-email-pang.xunlei@linaro.org>
	<1421642980-10045-4-git-send-email-pang.xunlei@linaro.org>
	<20150127125859.GD21418@twins.programming.kicks-ass.net>
	<20150127180438.445d8e76@gandalf.local.home>
Date: Wed, 28 Jan 2015 23:21:03 +0800
Message-ID: <CADcy93WTRp6L7voorN59EeB+-1ry9kUn4kv73pmqMoQ8KqvSpQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] sched/rt: Consider deadline tasks in cpupri_find()
From: Xunlei Pang <pang.xunlei@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, lkml <linux-kernel@vger.kernel.org>,
        Juri Lelli <juri.lelli@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On 28 January 2015 at 07:04, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 27 Jan 2015 13:58:59 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:
>
>
>> Not a bad idea, Cc'ed Steve who likes to look after the RT bits,
>> excessive quoting for him.
>
> Yep I do.
>
>
>> > index ade2958..48c9576 100644
>> > --- a/kernel/sched/core.c
>> > +++ b/kernel/sched/core.c
>> > @@ -5652,6 +5652,8 @@ static int init_rootdomain(struct root_domain *rd)
>> >
>> >     if (cpupri_init(&rd->cpupri) != 0)
>> >             goto free_rto_mask;
>> > +
>> > +   rd->cpupri.cpudl = &rd->cpudl;
>>
>> This is disgusting though; it breaks the cpuri abstraction. Why not pass
>> in the mask in the one place you actually need it?
>
> Yeah, probably should change cpupri_init() to take the rd->cpudl as a
> parameter.

Ok, thanks for your advice.
I'll refine this patch and send it out separately soon.

Thanks,
Xunlei

>
> Rest looks good (ignoring Peter's other comment that he realized wasn't
> an issue).
>
> -- Steve
>
