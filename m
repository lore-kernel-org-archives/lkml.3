Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896AbaIDV3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 17:29:34 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:44120 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342AbaIDV3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 17:29:31 -0400
Date: Thu, 4 Sep 2014 23:29:27 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Catalin Iacob <iacobcatalin@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: nohz fail (was: perf related boot hang.)
Message-ID: <20140904212925.GB3116@lerouge>
References: <20140811200931.GA18865@redhat.com>
 <1408566691-3023-1-git-send-email-iacobcatalin@gmail.com>
 <CAFTL4hxJ2roTB3tZBmXU3HRetgFSUT0LNVWfX-Y2hbpyXSo2pg@mail.gmail.com>
 <CAHg_5gq1XiZ1A08PtQ7Rof3rUXJ-pVYkXtmHqgFh6hB+++qPNg@mail.gmail.com>
 <20140822140009.GA8567@redhat.com>
 <20140901201429.GA1586@lerouge>
 <CAHg_5go_TT7CQ6U3AhjG4TxRM0zG562mxa+uV4UbOYd_-A0T-w@mail.gmail.com>
 <CAHg_5gr_tHeBsQfv1ydZRq9XgKipcrbijripqubE6c6j1S=jfg@mail.gmail.com>
 <20140904201752.GA3116@lerouge>
 <CAHg_5goeUsCP8zrZhkGyAvO3sPpt2VZFc5oNaQst9u0gSAmpdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHg_5goeUsCP8zrZhkGyAvO3sPpt2VZFc5oNaQst9u0gSAmpdA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 11:05:02PM +0200, Catalin Iacob wrote:
> On Thu, Sep 4, 2014 at 10:17 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > Yeah, that's expected. You need to apply the nine patches on top of -rc1:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> >         nohz/fixes
> >
> > "nohz: Restore NMI safe local irq work for local nohz kick" only fixes
> > part of the issue.
> 
> Ok, but if the whole series is needed, isn't it better if it all goes
> into 3.17? Otherwise 3.17 is a clear regression for some users; it's
> definitely for me since before 3.17-rc1 I never saw this bug and now I
> see it every time I do something CPU intensive. Maybe the regression
> is acceptable because the it's confined to some CONFIG_NO_HZ_*
> combination (I think) which is still rather experimental, that's your
> call to make, but it's still a regression.

Yeah the bug is there for a while but likely something got merged in the
last -rc1 that made the bug more likely to happen.

This is probably due to the fact that we converted remote nohz kick to use
irq work instead of the scheduler IPI. So it fires more likely and if we
are unlucky enough, some tick sees the irq work before the irq work IPI
can fire.

Or some code enqueues that irq work from the tick itself.

Awyway you're right that it belongs to the category of regressions. Unfortunately
the fix is invasive.

Also I don't know much users of nohz full so probably this won't
have much impact. Or this could be a good way to know who uses this feature after all :o)

I'm not sure what I should do. Lets see how the final fix will look like, Peter
is proposing some simplifications. Then we'll know better.

BTW, do you run some specific workloads to trigger this?

Thanks.
