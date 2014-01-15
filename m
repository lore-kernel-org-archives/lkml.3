Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750998AbaAOGif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 01:38:35 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:59141 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaAOGic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 01:38:32 -0500
Date: Wed, 15 Jan 2014 07:38:27 +0100
From: Ingo Molnar <mingo@kernel.org>
To: John Stultz <john.stultz@linaro.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, sboyd@codeaurora.org, w@1wt.eu, khalasa@piap.pl,
        u.kleine-koenig@pengutronix.de, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/urgent] sched_clock: Disable seqlock lockdep usage in
 sched_clock()
Message-ID: <20140115063827.GA11941@gmail.com>
References: <1388704274-5278-2-git-send-email-john.stultz@linaro.org>
 <tip-7a06c41cbec33c6dbe7eec575c61986122617408@git.kernel.org>
 <52D58D7F.2030306@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52D58D7F.2030306@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* John Stultz <john.stultz@linaro.org> wrote:

> On 01/12/2014 10:42 AM, tip-bot for John Stultz wrote:
> > Commit-ID:  7a06c41cbec33c6dbe7eec575c61986122617408
> > Gitweb:     http://git.kernel.org/tip/7a06c41cbec33c6dbe7eec575c61986122617408
> > Author:     John Stultz <john.stultz@linaro.org>
> > AuthorDate: Thu, 2 Jan 2014 15:11:14 -0800
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Sun, 12 Jan 2014 10:14:00 +0100
> >
> > sched_clock: Disable seqlock lockdep usage in sched_clock()
> >
> > Unfortunately the seqlock lockdep enablement can't be used
> > in sched_clock(), since the lockdep infrastructure eventually
> > calls into sched_clock(), which causes a deadlock.
> >
> > Thus, this patch changes all generic sched_clock() usage
> > to use the raw_* methods.
> >
> > Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
> > Reported-by: Krzysztof Hałasa <khalasa@piap.pl>
> > Signed-off-by: John Stultz <john.stultz@linaro.org>
> > Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > Cc: Willy Tarreau <w@1wt.eu>
> > Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> > Link: http://lkml.kernel.org/r/1388704274-5278-2-git-send-email-john.stultz@linaro.org
> > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> 
> Hey Ingo,
>     Just wanted to follow up here, since I've still not seen this (and
> the raw_ renaming patch) submitted to Linus. These address a lockup that
> triggers on ARM systems if lockdep is enabled and it would be good to
> get it in before 3.13 is out.

It's in tip:core/urgent, i.e. lined up for v3.13, I plan to send it to 
Linus later today.

Thanks,

	Ingo
