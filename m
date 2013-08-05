Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab3HEI2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 04:28:17 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:54436 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab3HEI2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 04:28:16 -0400
X-AuditID: 9c93016f-b7b05ae000002bbd-b7-51ff621ec556
From: Namhyung Kim <namhyung@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, eranian@google.com, jolsa@redhat.com,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/5] tools, perf: Add support to evsel for enabling counters
References: <1375490473-1503-1-git-send-email-andi@firstfloor.org>
	<1375490473-1503-3-git-send-email-andi@firstfloor.org>
Date: Mon, 05 Aug 2013 17:28:14 +0900
In-Reply-To: <1375490473-1503-3-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Fri, 2 Aug 2013 17:41:10 -0700")
Message-ID: <87eha81qzl.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Fri,  2 Aug 2013 17:41:10 -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> Add support for enabling already set up counters by using an
> ioctl. I share some code with the filter setup.
>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  tools/perf/util/evsel.c | 21 ++++++++++++++++++---
>  tools/perf/util/evsel.h |  1 +
>  2 files changed, 19 insertions(+), 3 deletions(-)
>
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index c9c7494..60e0d84 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -605,16 +605,16 @@ int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
>  	return evsel->fd != NULL ? 0 : -ENOMEM;
>  }
>  
> -int perf_evsel__set_filter(struct perf_evsel *evsel, int ncpus, int nthreads,
> -			   const char *filter)
> +static int perf_evsel__run_ioctl(struct perf_evsel *evsel, int ncpus, int nthreads,
> +			  int ioc,  void *arg)
>  {
>  	int cpu, thread;
>  
>  	for (cpu = 0; cpu < ncpus; cpu++) {
>  		for (thread = 0; thread < nthreads; thread++) {
>  			int fd = FD(evsel, cpu, thread),
> -			    err = ioctl(fd, PERF_EVENT_IOC_SET_FILTER, filter);
>  
> +			err = ioctl(fd, ioc, arg);

Looks very strange to have a blank line between variable declarations.
You'd better separating declarations on the other lines like:

			int fd, err;

			fd = FD(evsel, cpu, thread);
			err = ioctl(fd, ioc, arg);

Thanks,
Namhyung


>  			if (err)
>  				return err;
>  		}
