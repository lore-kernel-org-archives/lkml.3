Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab3L3EIe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 23:08:34 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:49994 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686Ab3L3EId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 23:08:33 -0500
Message-ID: <1388376508.5345.23.camel@marge.simpson.net>
Subject: Re: [RFC] sched: update rq clock when only get preempt
From: Mike Galbraith <bitbucket@online.de>
To: Lei Wen <adrian.wenl@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, leiwen@marvell.com
Date: Mon, 30 Dec 2013 05:08:28 +0100
In-Reply-To: <CALZhoST3oQnSOv0ZQ6CiHDgTC4D+t=Kd4Gp4oPqrnH__qMZ7Hw@mail.gmail.com>
References: <CALZhoST3oQnSOv0ZQ6CiHDgTC4D+t=Kd4Gp4oPqrnH__qMZ7Hw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:5CzbQumrnWhSFssxxnED/UylOUf5bdETxUCz8VqLta8
 ThnGh6U3usfpjjZus+8Zc3iT4/mEntJnDbkyaJpntID27IfLEJ
 dBdUoiLGVjRYvOW7xAsPlTO4hSnE3BH3TnRrL2kyBOEhCdUme0
 yt4aGRH2cOg7jIV0Eb1vfUM+BxkkGvE44OCQB5h0E3fW9xds3A
 kfUD26biTxqh09dxB8mmAKgf/W4aFYU100vWbcAK+VS4bi5NKj
 Gg6+4PkrML2Xk6AnX1DOfa98kNyjFS3v/E9MUG896vJA5pTx0b
 H9yDWyvb66zwXWoUgMD8spcxPvsEqnGx65sRCk/uQEhFldxU0O
 YCb8ZZFOBOpDd+lyWKnR+nuTS7/N9CtX/n7yC7XSRigHacQDeZ
 Utl4IuFywkcWg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-30 at 11:14 +0800, Lei Wen wrote: 
> Since we would update rq clock at task enqueue/dequeue, or schedule
> tick. If we don't update the rq clock when our previous task get
> preempted, our new started task would get a relative stale rq clock
> which is updated during the previous task enqueue, or the last schedule
> clock update.

> @@ -2555,6 +2556,8 @@ need_resched:
>                 idle_balance(cpu, rq);
> 
>         put_prev_task(rq, prev);
> +       if (update)
> +               update_rq_clock(rq);

If prev remained enqueued, the clock was updated by put_prev_task().

-Mike

