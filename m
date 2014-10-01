Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682AbaJAWNO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 18:13:14 -0400
Received: from mail.kernel.org ([198.145.19.201]:53098 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160AbaJAWNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 18:13:12 -0400
Date: Wed, 1 Oct 2014 19:13:06 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, jolsa@redhat.com,
        linux-kernel@vger.kernel.org, namhyung@kernel.org,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Adding a filter to events (instead of replacing one) was Re:
 [PATCH 1/2] perf, tools: Add PERF_PID
Message-ID: <20141001221306.GJ2799@kernel.org>
References: <1411591869-325-1-git-send-email-andi@firstfloor.org>
 <20141001180316.GI2799@kernel.org>
 <20141001220218.GC3264@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141001220218.GC3264@tassilo.jf.intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 01, 2014 at 03:02:18PM -0700, Andi Kleen escreveu:
> On Wed, Oct 01, 2014 at 03:03:16PM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Wed, Sep 24, 2014 at 01:51:08PM -0700, Andi Kleen escreveu:

> > > It's currently difficult to filter out perf itself using a filter.
> > > This can give cascading effects during IO tracing when the IO perf
> > > does itself causes more trace output.

> > > The best way to filter is to use the pid. But it's difficult to get the pid
> > > of perf without using hacks.

> > > Add a PERF_PID meta variable to the perf filter that contains the current pid.

> > > With this patch the following works

> > > % perf record -e syscalls:sys_enter_write -a --filter 'common_pid != PERF_PID' ...

> > So I tried this one now and saw the other patch, that applies the
> > --filter to all events, while trying I got:

> Patch seems reasonable to me.

> However adding PERF_PID and sanitizing --filter are really two
> different things and should probably not be mixed in a patch.

Yes, there are two things, but what seems to be wanted first is a way to
exclude 'perf record' samples, for all events.

Being able to specify PERF_PID on a filter so that some events can
include 'perf record' samples and some not seems to be something not
really needed at this point, i.e. just doing:

  perf record --filter-self -e syscalls:sys_enter_write -a ...

Is shorter and doesn't breaks the current --filter semantic (apply just
to the last tracepoint informed in the cmdline, not to all tracepoints)
like in your second patch.

So probably what is best to do is to finish the patch I sent here, which
will cover the filter-out-perf-tooling-samples usecase, and then, if
people still think it is needed, introduce the PERF_PID meta filter
variable.

- Arnaldo
