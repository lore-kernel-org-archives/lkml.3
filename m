Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab3L3E4w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 23:56:52 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:47352 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab3L3E4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 23:56:51 -0500
MIME-Version: 1.0
In-Reply-To: <1388376508.5345.23.camel@marge.simpson.net>
References: <CALZhoST3oQnSOv0ZQ6CiHDgTC4D+t=Kd4Gp4oPqrnH__qMZ7Hw@mail.gmail.com>
	<1388376508.5345.23.camel@marge.simpson.net>
Date: Mon, 30 Dec 2013 12:56:49 +0800
Message-ID: <CALZhoSS6HBTsXBW=Oj213psTZ1h4Wdgr8QCspGcbMNadWqQofw@mail.gmail.com>
Subject: Re: [RFC] sched: update rq clock when only get preempt
From: Lei Wen <adrian.wenl@gmail.com>
To: Mike Galbraith <bitbucket@online.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, leiwen@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Mon, Dec 30, 2013 at 12:08 PM, Mike Galbraith <bitbucket@online.de> wrote:
> On Mon, 2013-12-30 at 11:14 +0800, Lei Wen wrote:
>> Since we would update rq clock at task enqueue/dequeue, or schedule
>> tick. If we don't update the rq clock when our previous task get
>> preempted, our new started task would get a relative stale rq clock
>> which is updated during the previous task enqueue, or the last schedule
>> clock update.
>
>> @@ -2555,6 +2556,8 @@ need_resched:
>>                 idle_balance(cpu, rq);
>>
>>         put_prev_task(rq, prev);
>> +       if (update)
>> +               update_rq_clock(rq);
>
> If prev remained enqueued, the clock was updated by put_prev_task().

It indeed like that, sorry for the noise...

Thanks,
Lei
