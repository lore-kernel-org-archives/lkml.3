Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbaF2IgX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 04:36:23 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:43110 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbaF2IgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 04:36:21 -0400
Date: Sun, 29 Jun 2014 10:36:17 +0200
From: Andreas Mohr <andi@lisas.de>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mingo@redhat.com
Subject: Re: [PATCH] sched: Transform resched_task() into resched_curr()
Message-ID: <20140629083617.GA27653@rhlx01.hs-esslingen.de>
References: <20140629072059.GA18636@rhlx01.hs-esslingen.de>
 <53AFC6FD.5070508@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53AFC6FD.5070508@yandex.ru>
X-Priority: none
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jun 29, 2014 at 11:57:49AM +0400, Kirill Tkhai wrote:
> resched_curr(rq) means "to reschedule current task of the rq". It does
> not reschedule rq itself.
> 
> We already have resched_cpu(), which has cpu agrument, and it's not
> a task. I think this is just a similar case and we won't have any
> problems because of this.
> 
> We only can reschedule the current task, and the patch underlines that fact.

OK. I was arguing almost purely mechanically, and from a mechanical POV
I had some doubts.

I just noticed that there is a part touching rq->idle,
and ISTR that idle task handling is "special"
(after all that's the power management side of things).
Specifically, rq->curr and rq->idle are distinct rq members
(since they are distinct tasks AFAIK!),
so there might now be some issues with task state tracking here
(unless this cleanup happens to unify handling here anyway).

Thanks,

Andreas Mohr
