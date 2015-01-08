Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbbAHHRa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 02:17:30 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:54250 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbbAHHR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 02:17:29 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
Date: Thu, 8 Jan 2015 16:15:27 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 29/30] perf tools: Add support to configure builtin
 commands inclusion
Message-ID: <20150108071527.GE7268@sejong>
References: <1420212972-21595-1-git-send-email-jolsa@kernel.org>
 <1420212972-21595-30-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1420212972-21595-30-git-send-email-jolsa@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2015 at 04:36:11PM +0100, Jiri Olsa wrote:
> NOTE: hack
> 
> Adding support to configure builtin commands inclusion
> in the build, so we could later disable particular
> builtin command.
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> Cc: Alexis Berlemont <alexis.berlemont@gmail.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephane Eranian <eranian@google.com>
> ---
>  tools/perf/Build                    | 53 ++++++++++++++++++++-----------------
>  tools/perf/Makefile.build           |  3 +++
>  tools/perf/Makefile.perf            |  7 +++--
>  tools/perf/builtin-cmds.h           | 29 ++++++++++++++++++++
>  tools/perf/builtin-help.c           |  1 +
>  tools/perf/config.default           | 23 ++++++++++++++++
>  tools/perf/perf.c                   |  1 +
>  tools/perf/util/generate-cmdlist.sh | 10 +++++++
>  8 files changed, 101 insertions(+), 26 deletions(-)
>  create mode 100644 tools/perf/builtin-cmds.h
>  create mode 100644 tools/perf/config.default
> 
> diff --git a/tools/perf/Build b/tools/perf/Build
> index c95d6378ad65..8e8f2c58f2b0 100644
> --- a/tools/perf/Build
> +++ b/tools/perf/Build
> @@ -1,29 +1,34 @@
> -perf-y += builtin-bench.o
> -perf-y += builtin-annotate.o
> -perf-y += builtin-diff.o
> -perf-y += builtin-evlist.o
> -perf-y += builtin-help.o
> -perf-y += builtin-sched.o
> -perf-y += builtin-buildid-list.o
> -perf-y += builtin-buildid-cache.o
> -perf-y += builtin-list.o
> -perf-y += builtin-record.o
> -perf-y += builtin-report.o
> -perf-y += builtin-stat.o
> -perf-y += builtin-timechart.o
> -perf-y += builtin-top.o
> -perf-y += builtin-script.o
> -perf-y += builtin-kmem.o
> -perf-y += builtin-lock.o
> -perf-y += builtin-kvm.o
> -perf-y += builtin-inject.o
> -perf-y += builtin-mem.o
> -
> -perf-$(CONFIG_AUDIT) += builtin-trace.o
> -perf-$(CONFIG_LIBELF) += builtin-probe.o
> +perf-$(CONFIG_BUILTIN_BENCH)         += builtin-bench.o
> +perf-$(CONFIG_BUILTIN_ANNOTATE)      += builtin-annotate.o
> +perf-$(CONFIG_BUILTIN_DIFF)          += builtin-diff.o
> +perf-$(CONFIG_BUILTIN_EVLIST)        += builtin-evlist.o
> +perf-$(CONFIG_BUILTIN_HELP)          += builtin-help.o
> +perf-$(CONFIG_BUILTIN_SCHED)         += builtin-sched.o
> +perf-$(CONFIG_BUILTIN_BUILDID_LIST)  += builtin-buildid-list.o
> +perf-$(CONFIG_BUILTIN_BUILDID_CACHE) += builtin-buildid-cache.o
> +perf-$(CONFIG_BUILTIN_LIST)          += builtin-list.o
> +perf-$(CONFIG_BUILTIN_RECORD)        += builtin-record.o
> +perf-$(CONFIG_BUILTIN_REPORT)        += builtin-report.o
> +perf-$(CONFIG_BUILTIN_STAT)          += builtin-stat.o
> +perf-$(CONFIG_BUILTIN_TIMECHART)     += builtin-timechart.o
> +perf-$(CONFIG_BUILTIN_TOP)           += builtin-top.o
> +perf-$(CONFIG_BUILTIN_SCRIPT)        += builtin-script.o
> +perf-$(CONFIG_BUILTIN_KMEM)          += builtin-kmem.o
> +perf-$(CONFIG_BUILTIN_LOCK)          += builtin-lock.o
> +perf-$(CONFIG_BUILTIN_KVM)           += builtin-kvm.o
> +perf-$(CONFIG_BUILTIN_INJECT)        += builtin-inject.o
> +perf-$(CONFIG_BUILTIN_MEM)           += builtin-mem.o
> +
> +ifeq ($(CONFIG_AUDIT),y)
> +perf-$(CONFIG_BUILTIN_TRACE)         += builtin-trace.o
> +endif
> +
> +ifeq ($(CONFIG_LIBELF),y)
> +perf-$(CONFIG_BUILTIN_PROBE)         += builtin-probe.o
> +endif
>  
>  perf-y += bench/

I guess it also needs to be changed like below?

   perf-$(CONFIG_BUILTIN_BENCH) += bench/

Thanks,
Namhyung


> -perf-y += tests/
> +perf-$(CONFIG_BUILTIN_TEST) += tests/
>  
>  perf-y += perf.o
