Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbbAUSFM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 13:05:12 -0500
Received: from mail-qg0-f41.google.com ([209.85.192.41]:54057 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbbAUSFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 13:05:07 -0500
MIME-Version: 1.0
In-Reply-To: <1421862883.14076.99.camel@arm.com>
References: <1415292718-19785-1-git-send-email-pawel.moll@arm.com>
	<1415292718-19785-4-git-send-email-pawel.moll@arm.com>
	<20150105134514.GS30905@twins.programming.kicks-ass.net>
	<1421860365.14076.91.camel@arm.com>
	<CALAqxLV6ggCO81ntWuYuDjrqNeMePkZBpq92G9-iwMHm7ONuFg@mail.gmail.com>
	<1421862883.14076.99.camel@arm.com>
Date: Wed, 21 Jan 2015 10:05:06 -0800
Message-ID: <CALAqxLXjhpU0Q+edFkJg7RY7giqhojEy53rKQbppQmYAhJ34ZQ@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] perf: Sample additional clock value
From: John Stultz <john.stultz@linaro.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christopher Covington <cov@codeaurora.org>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 9:54 AM, Pawel Moll <pawel.moll@arm.com> wrote:
> On Wed, 2015-01-21 at 17:44 +0000, John Stultz wrote:
>> That said, there is the dynamic posix clockids. I'm not sure if it
>> would make sense, but even if we don't bump MAX_CLOCKS, might there
>> be some case where someone wants to use a dynamic posix clock for the
>> perf reference?
>
> If I remember correctly, last time I tried to use dynamic posix clocks
> in the perf context, one needed to open a ptp character device in order
> to get a file descriptor, than translated into a clockid_t value -
> correct me if I'm wrong. But here you get the fd from the
> sys_perf_open() and clock_*() doesn't know anything about such
> descriptor.

Sorry for losing context here then. Yes, the dynamic clockid has to be
exported via some other interface to userland (likely via the driver
that provides it), but once the id is known it can be used via the
clock_*() functions.   I was thinking here since the perf_event_attr
wants to associate with a clockid, including the possibility for
dynamic clockids would be wise, but I didn't read closely enough to
see how that clockid was specified.

> I was looking into a way of associating a random clock with a random fd,
> so that perf could "attach" itself to the clock API at will, but it
> turned out not to be trivial (I'd have to dig through old threads to
> remember all the nasty details).
>
> The good thing is that it looks like the immediate need for this was no
> more, with perf using monotonic clock as the clock source. It will come
> back when we get into hardware trace correlation, but one step at a
> time...

Ok. I'm eager to see this settled (and the current approach I don't
have any objections to, although I'm not paying super close attention
now that its all in the perf core).   I know this has taken far longer
then you'd have liked, so thanks for your persistence!

-john
