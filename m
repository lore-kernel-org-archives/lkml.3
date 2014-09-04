Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbaIDVFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 17:05:24 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:56632 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688AbaIDVFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 17:05:23 -0400
MIME-Version: 1.0
In-Reply-To: <20140904201752.GA3116@lerouge>
References: <20140811200931.GA18865@redhat.com> <1408566691-3023-1-git-send-email-iacobcatalin@gmail.com>
 <CAFTL4hxJ2roTB3tZBmXU3HRetgFSUT0LNVWfX-Y2hbpyXSo2pg@mail.gmail.com>
 <CAHg_5gq1XiZ1A08PtQ7Rof3rUXJ-pVYkXtmHqgFh6hB+++qPNg@mail.gmail.com>
 <20140822140009.GA8567@redhat.com> <20140901201429.GA1586@lerouge>
 <CAHg_5go_TT7CQ6U3AhjG4TxRM0zG562mxa+uV4UbOYd_-A0T-w@mail.gmail.com>
 <CAHg_5gr_tHeBsQfv1ydZRq9XgKipcrbijripqubE6c6j1S=jfg@mail.gmail.com> <20140904201752.GA3116@lerouge>
From: Catalin Iacob <iacobcatalin@gmail.com>
Date: Thu, 4 Sep 2014 23:05:02 +0200
Message-ID: <CAHg_5goeUsCP8zrZhkGyAvO3sPpt2VZFc5oNaQst9u0gSAmpdA@mail.gmail.com>
Subject: Re: nohz fail (was: perf related boot hang.)
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2014 at 10:17 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> Yeah, that's expected. You need to apply the nine patches on top of -rc1:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
>         nohz/fixes
>
> "nohz: Restore NMI safe local irq work for local nohz kick" only fixes
> part of the issue.

Ok, but if the whole series is needed, isn't it better if it all goes
into 3.17? Otherwise 3.17 is a clear regression for some users; it's
definitely for me since before 3.17-rc1 I never saw this bug and now I
see it every time I do something CPU intensive. Maybe the regression
is acceptable because the it's confined to some CONFIG_NO_HZ_*
combination (I think) which is still rather experimental, that's your
call to make, but it's still a regression.
