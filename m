Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab3IMHcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 03:32:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39844 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278Ab3IMHcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 03:32:19 -0400
Date: Fri, 13 Sep 2013 09:31:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org
Subject: Re: [RFC PATCH] Introduce timekeeper latch synchronization
Message-ID: <20130913073156.GF31370@twins.programming.kicks-ass.net>
References: <20130913025253.GA17218@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130913025253.GA17218@Krystal>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 10:52:53PM -0400, Mathieu Desnoyers wrote:
> OK! Here is the full implementation of the idea against Linux
> timekeeper, ntp, and PPS. It appears that ntp and PPS were relying on
> the timekeeper seqlock too. And guess what, after booting my laptop with
> this kernel there still no smoke coming out of it after a good 5 minutes
> of testing. ;-)
> 
> Comments are welcome.

I think that moving stuff into structures is a worthwhile change on its
own, but I'll leave John and Thomas to decide on all that.

The latch thing does make the update side slightly more expensive due to
having to do that copy every time, but ideally that wouldn't happen all
that often.
