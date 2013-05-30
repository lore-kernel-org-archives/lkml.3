Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030589Ab3E3LDE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 07:03:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44771 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030459Ab3E3LDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 07:03:00 -0400
Date: Thu, 30 May 2013 13:02:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/2] perf: Enable wakeup_events logic for all events
Message-ID: <20130530110239.GN12193@twins.programming.kicks-ass.net>
References: <1369907587-8963-1-git-send-email-jolsa@redhat.com>
 <1369907587-8963-2-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369907587-8963-2-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 11:53:06AM +0200, Jiri Olsa wrote:
> Currently the perf_events_attr::wakeup_events logic is
> checked only for regular samples.
> 
> If we have an event that produce only auxiliary events
> (MMAP|COMM|EXIT|FORK), the poll call does not follow
> the perf_events_attr wakeup_events setup and reports
> no data.
> 
> Fixing this by moving the perf_events_attr::wakeup_events
> checking logic into the function and calling it from
> perf_output_end. This way any output event is checked
> properly.
> 

So something like this came up before and ISTR doing a patch similar to
what you propose but ended up not going with it because... uhm...

I have vague memories about people (possibly me) wanting wake_events to
mean samples. Like get me a wakeup every 20 samples. With your patch the
side-band events now also count towards 'events'.

I think the most common use of wake_events is people setting it to 1 and
have perf generate a SIGfoo for every sample so they can do magic in
their userspace signal handler. This is popular for interpreters.

It would be unfortunate to get SIGfoos for side-band chatter.


Makes sense?
