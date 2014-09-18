Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbaIRPH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:07:27 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:34236 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351AbaIRPHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:07:25 -0400
Message-ID: <1411052837.8965.6.camel@hornet>
Subject: Re: [PATCH 0/2] perf: User/kernel time correlation and event
 generation
From: Pawel Moll <pawel.moll@arm.com>
To: Christopher Covington <cov@codeaurora.org>
Cc: Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Date: Thu, 18 Sep 2014 16:07:17 +0100
In-Reply-To: <541AF40B.7070604@codeaurora.org>
References: <1411050873-9310-1-git-send-email-pawel.moll@arm.com>
	 <541AF40B.7070604@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-18 at 16:02 +0100, Christopher Covington wrote:
> Hi Pawel,
> 
> On 09/18/2014 10:34 AM, Pawel Moll wrote:
> > Greetings,
> > 
> > This is a second spin of the short series posted last week:
> > 
> > http://www.spinics.net/lists/kernel/msg1824419.html
> > 
> > The first patch adds an additional timestamp field in the perf
> > sample data, which can be requested for any perf event along
> > with normal PERF_SAMPLE_TIME. Events with both values appearing
> > periodically in the perf data allow user code to translate
> > raw monotonic time (obtained via POSIX clock API) to sched_clock
> > domain. Although any perf event can be used, the natural choice
> > would be a sched_switch trace event (for processes with root
> > permissions) or a hrtimer-based PERF_COUNT_SW_CPU_CLOCK.
> > 
> > It didn't attract any comments previously, so is just re-posted
> > without any changes.
> > 
> > The second patch, functionally orthogonal but complementing
> > the first one, builds on the ftrace "trace_maker" idea. It adds
> > a ioctl that can be used to inject a userspace-generated data
> > into the perf buffer. It provides base for printf-like
> > functionality in perf world. If used with the previous patch,
> > it can be also used to provide synchronisation points for sched
> > vs. raw monotonic time stamps correlation.
> > 
> > First version of the patch was taking a zero-terminated string
> > as an argument. Now it is taking a custom structure with "type"
> > and "size" integer fields followed by data. Type value "0"
> > is defined as a zero-terminated string (although size, including
> > the NULL character, must still be provided), but meaning of data
> > for other types is of no interest for the kernel. The intention
> > is to host a list of "well known" types (with reference parsers
> > for them) in the user perf tool code.
> 
> Would it be possible for you to also update the corresponding man pages?
> 
> https://www.kernel.org/doc/man-pages/

I must admit I haven't thought of that, but of course - if the changes
are accepted I'll send patches to the perf_event_open(2) man page. Any
others you had in mind?

Pawel

