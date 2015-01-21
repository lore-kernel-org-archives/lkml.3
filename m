Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbbAURzB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 12:55:01 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:40389 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbbAURyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 12:54:53 -0500
Message-ID: <1421862883.14076.99.camel@arm.com>
Subject: Re: [PATCH v4 3/3] perf: Sample additional clock value
From: Pawel Moll <pawel.moll@arm.com>
To: John Stultz <john.stultz@linaro.org>
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
Date: Wed, 21 Jan 2015 17:54:43 +0000
In-Reply-To: <CALAqxLV6ggCO81ntWuYuDjrqNeMePkZBpq92G9-iwMHm7ONuFg@mail.gmail.com>
References: <1415292718-19785-1-git-send-email-pawel.moll@arm.com>
	 <1415292718-19785-4-git-send-email-pawel.moll@arm.com>
	 <20150105134514.GS30905@twins.programming.kicks-ass.net>
	 <1421860365.14076.91.camel@arm.com>
	 <CALAqxLV6ggCO81ntWuYuDjrqNeMePkZBpq92G9-iwMHm7ONuFg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.10-0ubuntu1~14.10.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-21 at 17:44 +0000, John Stultz wrote:
> That said, there is the dynamic posix clockids. I'm not sure if it
> would make sense, but even if we don't bump MAX_CLOCKS, might there
> be some case where someone wants to use a dynamic posix clock for the
> perf reference?

If I remember correctly, last time I tried to use dynamic posix clocks
in the perf context, one needed to open a ptp character device in order
to get a file descriptor, than translated into a clockid_t value -
correct me if I'm wrong. But here you get the fd from the
sys_perf_open() and clock_*() doesn't know anything about such
descriptor.

I was looking into a way of associating a random clock with a random fd,
so that perf could "attach" itself to the clock API at will, but it
turned out not to be trivial (I'd have to dig through old threads to
remember all the nasty details).

The good thing is that it looks like the immediate need for this was no
more, with perf using monotonic clock as the clock source. It will come
back when we get into hardware trace correlation, but one step at a
time...

Pawel

