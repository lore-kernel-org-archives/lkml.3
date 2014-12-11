Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933775AbaLKNje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 08:39:34 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:48196 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbaLKNjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 08:39:32 -0500
Message-ID: <1418305153.4037.1.camel@arm.com>
Subject: Re: [PATCH v4 1/3] perf: Use monotonic clock as a source for
 timestamps
From: Pawel Moll <pawel.moll@arm.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christopher Covington <cov@codeaurora.org>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Date: Thu, 11 Dec 2014 13:39:13 +0000
In-Reply-To: <1417100750.4371.1.camel@arm.com>
References: <1415292718-19785-1-git-send-email-pawel.moll@arm.com>
	 <1415292718-19785-2-git-send-email-pawel.moll@arm.com>
	 <1417100750.4371.1.camel@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-27 at 15:05 +0000, Pawel Moll wrote:
> On Thu, 2014-11-06 at 16:51 +0000, Pawel Moll wrote:
> > Until now, perf framework never defined the meaning of the timestamps
> > captured as PERF_SAMPLE_TIME sample type. The values were obtaining
> > from local (sched) clock, which is unavailable in userspace. This made
> > it impossible to correlate perf data with any other events. Other
> > tracing solutions have the source configurable (ftrace) or just share
> > a common time domain between kernel and userspace (LTTng).
> > 
> > Follow the trend by using monotonic clock, which is readily available
> > as POSIX CLOCK_MONOTONIC.
> > 
> > Also add a sysctl "perf_sample_time_clk_id" attribute which can be used
> > by the user to obtain the clk_id to be used with POSIX clock API (eg.
> > clock_gettime()) to obtain a time value comparable with perf samples.
> > 
> > Old behaviour can be restored by using "perf_use_local_clock" kernel
> > parameter.
> > 
> > Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> 
> It's been 3 weeks without any negative feedback (no feedback at all, but
> I take the optimistic view :-)...
> 
> How about queuing at least this patch alone for the incoming merge
> window? Or at least getting it into -next, with the view at 3.20?

It's been another two weeks... How about getting it queued for v3.20
then?

Pawel

