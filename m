Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758492AbaKUJfh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 04:35:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932315AbaKUJfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 04:35:33 -0500
Date: Fri, 21 Nov 2014 10:35:13 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [RFC 00/11] perf tools: Factor stat reading and CQM changes
Message-ID: <20141121093513.GA12548@krava.redhat.com>
References: <1416562275-12404-1-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416562275-12404-1-git-send-email-jolsa@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 10:31:04AM +0100, Jiri Olsa wrote:
> hi,
> this patchset factors Matt's userspace part of CQM patches:
> http://marc.info/?l=linux-kernel&m=141156746730336&w=2
> 
> I needed to put counters reading into single place, which in
> the end turned out to be simplification of the stat command
> reading side.
> 
> any comments are welcome,
> jirka

available in:
  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  perf/core_stat_cqm

jirka

> 
> 
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Stephane Eranian <eranian@google.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
> Jiri Olsa (10):
>       perf tools: Introduce perf_evsel__compute_deltas function
>       perf tools: Introduce perf_counts_values__scale function
>       perf tools: Introduce perf_evsel__read_cb function
>       perf stat: Use perf_evsel__read_cb in read_counter
>       perf stat: Make read_counter work over the thread dimension
>       perf stat: Use read_counter in read_counter_aggr
>       perf tools: Remove perf_evsel__read interface
>       perf tools: Add snapshot format file parsing
>       perf stat: Add support for per-pkg counters
>       perf stat: Add support for snapshot counters
> 
> Matt Fleming (1):
>       perf tools: Add per-pkg format file parsing
> 
>  tools/perf/builtin-stat.c      | 105 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------
>  tools/perf/util/evsel.c        | 100 +++++++++++++++++++++++++++------------------------------------------
>  tools/perf/util/evsel.h        |  45 +++++++++++--------------------
>  tools/perf/util/parse-events.c |   2 ++
>  tools/perf/util/pmu.c          |  74 +++++++++++++++++++++++++++++++++++++++++++--------
>  tools/perf/util/pmu.h          |   4 +++
>  6 files changed, 220 insertions(+), 110 deletions(-)
