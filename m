Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762084AbaGRTqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 15:46:34 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:41539 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906AbaGRTqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 15:46:33 -0400
Message-ID: <53C97995.2090500@linaro.org>
Date: Fri, 18 Jul 2014 12:46:29 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Pawel Moll <pawel.moll@arm.com>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Baruch Siach <baruch@tkos.co.il>,
        Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] sched_clock: Track monotonic raw clock
References: <1405705419-4194-1-git-send-email-pawel.moll@arm.com> <20140718191338.GF3935@laptop> <CALAqxLX4ia_dBO-oNY1XMnSrJdDZc87EneHj9WcxtOZaupZaCg@mail.gmail.com> <20140718193417.GG3935@laptop>
In-Reply-To: <20140718193417.GG3935@laptop>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2014 12:34 PM, Peter Zijlstra wrote:
> On Fri, Jul 18, 2014 at 12:25:48PM -0700, John Stultz wrote:
>> Also, assuming we someday will merge the x86 sched_clock logic into
>> the generic sched_clock code, we'll have to handle cases where they
>> aren't the same.
> I prefer that to not happen. I spend quite a bit of time and effort to
> make the x86 code go fast, and that generic code doesn't look like fast
> at all.

A stretch goal then :)

But yes, the generic sched_clock logic has really just started w/ ARM
and is hopefully moving out to pick up more architectures. I suspect it
will need to adapt many of your tricks from (if not a whole migration to
some of) the x86 code. And even if the x86 code stays separate for
optimization reasons, thats fine.

But as folks try to align things like perf timestamps with time domains
we expose to userspace, we'll have to keep some of the semantics in sync
between the various implementations, and having lots of separate
implementations will be a burden.

But yea, I don't have any plans to try to do a grand unification myself,
so don't fret.

thanks
-john

