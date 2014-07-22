Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbaGVQRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 12:17:19 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:47676 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755458AbaGVQRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 12:17:17 -0400
Message-ID: <1406045831.25343.69.camel@hornet>
Subject: Re: [RFC] sched_clock: Track monotonic raw clock
From: Pawel Moll <pawel.moll@arm.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Baruch Siach <baruch@tkos.co.il>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 22 Jul 2014 17:17:11 +0100
In-Reply-To: <53C95E97.2020805@linaro.org>
References: <1405705419-4194-1-git-send-email-pawel.moll@arm.com>
	 <53C95E97.2020805@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-18 at 18:51 +0100, John Stultz wrote:
> Very cool work! 

Glad that it doesn't sound too ridiculous :-)

> I've not been able to review it carefully, but one good
> stress test would be to pick a system where the hardware used for
> sched_clock is different from the hardware used for timekeeping.

Actually I've got exactly this situation on my board. I've got two
sources, and actually the worse (narrower and more expensive) one is
getting eventually used (because it's registered later - separate patch
to follow).

> Although, looking again, this looks like it only works on the "generic"
> sched_clock (so ARM/ARM64?)...

... and microblaze and xtensa right now, yes. This was just the simplest
thing for me to start with, but I appreciate it doesn't cover all
possible cases. Thus the debugfs attribute to tell userspace what can it
expect from the sched_clock. A hack it is, yes.

Pawel

