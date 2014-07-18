Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761779AbaGRTeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 15:34:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:46440 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909AbaGRTeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 15:34:20 -0400
Date: Fri, 18 Jul 2014 21:34:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Pawel Moll <pawel.moll@arm.com>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Baruch Siach <baruch@tkos.co.il>,
        Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] sched_clock: Track monotonic raw clock
Message-ID: <20140718193417.GG3935@laptop>
References: <1405705419-4194-1-git-send-email-pawel.moll@arm.com>
 <20140718191338.GF3935@laptop>
 <CALAqxLX4ia_dBO-oNY1XMnSrJdDZc87EneHj9WcxtOZaupZaCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALAqxLX4ia_dBO-oNY1XMnSrJdDZc87EneHj9WcxtOZaupZaCg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 12:25:48PM -0700, John Stultz wrote:
> Also, assuming we someday will merge the x86 sched_clock logic into
> the generic sched_clock code, we'll have to handle cases where they
> aren't the same.

I prefer that to not happen. I spend quite a bit of time and effort to
make the x86 code go fast, and that generic code doesn't look like fast
at all.

