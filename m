Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbaANTSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:18:32 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:53606 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbaANTS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:18:27 -0500
Message-ID: <52D58D7F.2030306@linaro.org>
Date: Tue, 14 Jan 2014 11:18:23 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        sboyd@codeaurora.org, w@1wt.eu, khalasa@piap.pl,
        u.kleine-koenig@pengutronix.de, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/urgent] sched_clock: Disable seqlock lockdep usage
 in sched_clock()
References: <1388704274-5278-2-git-send-email-john.stultz@linaro.org> <tip-7a06c41cbec33c6dbe7eec575c61986122617408@git.kernel.org>
In-Reply-To: <tip-7a06c41cbec33c6dbe7eec575c61986122617408@git.kernel.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2014 10:42 AM, tip-bot for John Stultz wrote:
> Commit-ID:  7a06c41cbec33c6dbe7eec575c61986122617408
> Gitweb:     http://git.kernel.org/tip/7a06c41cbec33c6dbe7eec575c61986122617408
> Author:     John Stultz <john.stultz@linaro.org>
> AuthorDate: Thu, 2 Jan 2014 15:11:14 -0800
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Sun, 12 Jan 2014 10:14:00 +0100
>
> sched_clock: Disable seqlock lockdep usage in sched_clock()
>
> Unfortunately the seqlock lockdep enablement can't be used
> in sched_clock(), since the lockdep infrastructure eventually
> calls into sched_clock(), which causes a deadlock.
>
> Thus, this patch changes all generic sched_clock() usage
> to use the raw_* methods.
>
> Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
> Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
> Reported-by: Krzysztof Hałasa <khalasa@piap.pl>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Willy Tarreau <w@1wt.eu>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Link: http://lkml.kernel.org/r/1388704274-5278-2-git-send-email-john.stultz@linaro.org
> Signed-off-by: Ingo Molnar <mingo@kernel.org>

Hey Ingo,
    Just wanted to follow up here, since I've still not seen this (and
the raw_ renaming patch) submitted to Linus. These address a lockup that
triggers on ARM systems if lockdep is enabled and it would be good to
get it in before 3.13 is out.

thanks
-john


