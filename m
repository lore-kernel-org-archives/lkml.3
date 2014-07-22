Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700AbaGVQet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 12:34:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:32960 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337AbaGVQes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 12:34:48 -0400
Date: Tue, 22 Jul 2014 18:34:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Baruch Siach <baruch@tkos.co.il>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] sched_clock: Track monotonic raw clock
Message-ID: <20140722163437.GI3935@laptop>
References: <1405705419-4194-1-git-send-email-pawel.moll@arm.com>
 <20140719050233.GA4408@netboy>
 <1406045849.25343.72.camel@hornet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406045849.25343.72.camel@hornet>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 05:17:29PM +0100, Pawel Moll wrote:
> With both Ingo and John showing preference towards the clock alignment,
> so that's where I looked this time (I've already done custom perf
> ioctls, posix clocks... don't really know how many different ways I've
> tried).

So we should probably also talk about which clock to track, MONO has the
advantage of making it far easier to trace clusters but has the
disadvantage of stacked control loops with NTP adjusting MONO and us
adjusting sched_clock.

And I would really prefer to pick 1 and not make it configurable.
