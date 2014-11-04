Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbaKDUMJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 15:12:09 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42378 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbaKDUMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 15:12:06 -0500
Date: Tue, 4 Nov 2014 21:12:03 +0100
From: Pavel Machek <pavel@ucw.cz>
To: len.brown@intel.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        mingo@kernel.org, peterz@infradead.org, torvalds@linux-foundation.org,
        rjw@rjwysocki.net, hpa@zytor.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched/wait: Reimplement wait_event_freezable()
Message-ID: <20141104201203.GA15071@amd>
References: <tip-d86fz1jmso9wjxa8jfpinp8o@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-d86fz1jmso9wjxa8jfpinp8o@git.kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Commit-ID:  36df04bc5273a046f53b5e359febc1225f85aa7b
> Gitweb:     http://git.kernel.org/tip/36df04bc5273a046f53b5e359febc1225f85aa7b
> Author:     Peter Zijlstra <peterz@infradead.org>
> AuthorDate: Wed, 29 Oct 2014 12:21:57 +0100
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Tue, 4 Nov 2014 07:17:45 +0100
> 
> sched/wait: Reimplement wait_event_freezable()
> 
> Provide better implementations of wait_event_freezable() APIs.
> 
> The problem is with freezer_do_not_count(), it hides the thread from
> the freezer, even though this thread might not actually freeze/sleep
> at all.

Can you elaborate?

The thread will be in freezer_do_not_count() area, but it is just
waiting for event there, it should not do much damage.

If this is bugfix, should it be cc-ed to stable?

Did you test it with suspend/hibernation? Because I can't really see
how it works.

> +#define __wait_event_freezable(wq, condition)				\
> +	___wait_event(wq, condition, TASK_INTERRUPTIBLE, 0, 0,		\
> +			    schedule(); try_to_freeze())
> +

_Three_ underscores. And two underscore version exists, too,
fortunately it at least has different number of arguments.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
