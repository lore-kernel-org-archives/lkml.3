Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbaF2I7r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 04:59:47 -0400
Received: from forward8l.mail.yandex.net ([84.201.143.141]:45010 "EHLO
	forward8l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbaF2I7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 04:59:45 -0400
X-Yandex-Uniq: 0f3b7745-286e-46e8-a373-50e2d75ca59f
Authentication-Results: smtp2h.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <53AFD57D.4090008@yandex.ru>
Date: Sun, 29 Jun 2014 12:59:41 +0400
From: Kirill Tkhai <tkhai@yandex.ru>
Reply-To: tkhai@yandex.ru
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Andreas Mohr <andi@lisas.de>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@redhat.com
Subject: Re: [PATCH] sched: Transform resched_task() into resched_curr()
References: <20140629072059.GA18636@rhlx01.hs-esslingen.de> <53AFC6FD.5070508@yandex.ru> <20140629083617.GA27653@rhlx01.hs-esslingen.de>
In-Reply-To: <20140629083617.GA27653@rhlx01.hs-esslingen.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.06.2014 12:36, Andreas Mohr wrote:
> Hi,
> 
> On Sun, Jun 29, 2014 at 11:57:49AM +0400, Kirill Tkhai wrote:
>> resched_curr(rq) means "to reschedule current task of the rq". It does
>> not reschedule rq itself.
>>
>> We already have resched_cpu(), which has cpu agrument, and it's not
>> a task. I think this is just a similar case and we won't have any
>> problems because of this.
>>
>> We only can reschedule the current task, and the patch underlines that fact.
> 
> OK. I was arguing almost purely mechanically, and from a mechanical POV
> I had some doubts.
> 
> I just noticed that there is a part touching rq->idle,
> and ISTR that idle task handling is "special"
> (after all that's the power management side of things).
> Specifically, rq->curr and rq->idle are distinct rq members
> (since they are distinct tasks AFAIK!),
> so there might now be some issues with task state tracking here
> (unless this cleanup happens to unify handling here anyway).

Are you worrying about check_preempt_curr_idle()? I've looked
at check_preempt_curr() and found, we never call this function
in current scheduler logic.

It's called only if just enqueued task is of the same class as
rq's current, but we can't have two idle class tasks enqueued
on the same rq. So, it's just a stub. We can do not worry
about this.

Thanks,
Kirill
