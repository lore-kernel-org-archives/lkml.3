Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbaHUQ6r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 12:58:47 -0400
Received: from mail.kernel.org ([198.145.19.201]:45268 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170AbaHUQ6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 12:58:46 -0400
Date: Thu, 21 Aug 2014 13:58:40 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 01/24] perf tools: Add a test for tracking with
 sched_switch
Message-ID: <20140821165840.GQ2892@kernel.org>
References: <1408129739-17368-1-git-send-email-adrian.hunter@intel.com>
 <1408129739-17368-2-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1408129739-17368-2-git-send-email-adrian.hunter@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Aug 15, 2014 at 10:08:36PM +0300, Adrian Hunter escreveu:
> + * test__switch_tracking - test using sched_switch and tracking events.
> + *
> + * This function implements a test that checks that sched_switch events and
> + * tracking events can be recorded for a workload (current process) using the
> + * evsel->system_wide and evsel->tracking flags (respectively) with other events
> + * sometimes enabled or disabled.
> + */
> +int test__switch_tracking(void)
> +{
> +	const char *sched_switch = "sched:sched_switch";
> +	struct switch_tracking switch_tracking = {0};
> +	struct record_opts opts = {

308 int test__switch_tracking(void)
309 {
310         const char *sched_switch = "sched:sched_switch";
311         struct switch_tracking switch_tracking = {0};
312         struct record_opts opts = {
313                 .mmap_pages          = UINT_MAX,
314                 .user_freq           = UINT_MAX,
315                 .user_interval       = ULLONG_MAX,
316                 .freq                = 4000,
317                 .target              = {
318                         .uses_mmap   = true,
319                 },
320         };
321         struct thread_map *threads = NULL;

Fails to build on f14, still building on other distros, will fix after lunch,
no need to send any fix, just FYI:

  CC       /tmp/build/perf/arch/x86/util/header.o
cc1: warnings being treated as errors
tests/switch-tracking.c: In function ‘test__switch_tracking’:
tests/switch-tracking.c:311:9: error: missing initializer
tests/switch-tracking.c:311:9: error: (near initialization for ‘switch_tracking.cycles_evsel’)
make[1]: *** [/tmp/build/perf/tests/switch-tracking.o] Error 1
make[1]: *** Waiting for unfinished jobs....
make: *** [install] Error 2
make: Leaving directory `/home/acme/git/linux/tools/perf'

real	0m19.399s
user	0m53.823s
sys	0m7.346s
[acme@fedora14 linux]$ fg
-bash: fg: current: no such job
[acme@fedora14 
