Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbaJWX0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 19:26:17 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:61079 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbaJWX0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 19:26:14 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Wang Nan <wangnan0@huawei.com>
Cc: <acme@kernel.org>, <a.p.zijlstra@chello.nl>, <paulus@samba.org>,
        <mingo@redhat.com>, <jolsa@redhat.com>, <adrian.hunter@intel.com>,
        <Waiman.Long@hp.com>, <linux-kernel@vger.kernel.org>,
        <lizefan@huawei.com>
Subject: Re: [PATCH v2 RESEND] perf tools: makes CPUINFO_PROC to array for different kernel version
References: <1413963614-7251-1-git-send-email-wangnan0@huawei.com>
Date: Fri, 24 Oct 2014 08:26:13 +0900
In-Reply-To: <1413963614-7251-1-git-send-email-wangnan0@huawei.com> (Wang
	Nan's message of "Wed, 22 Oct 2014 15:40:14 +0800")
Message-ID: <87k33qe5be.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2014 15:40:14 +0800, Wang Nan wrote:
> After kernel 3.7 (commit b4b8f770eb10a1bccaf8aa0ec1956e2dd7ed1e0a),
> /proc/cpuinfo replaces 'Processor' to 'model name'. This patch makes
> CPUINFO_PROC to an array and provides two choices for ARM, makes it
> compatible for different kernel version.
>
> v1 -> v2: minor changes as suggested by Namhyung Kim:
>
>  - Doesn't pass @h and @evlist to __write_cpudesc;
>  - Coding style fix.
>
> Signed-off-by: Wang Nan <wangnan0@huawei.com>

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


> ---
>  tools/perf/perf.h        | 24 ++++++++++++------------
>  tools/perf/util/header.c | 27 +++++++++++++++++++++------
>  2 files changed, 33 insertions(+), 18 deletions(-)
>
> diff --git a/tools/perf/perf.h b/tools/perf/perf.h
> index 32bd102..1a23392 100644
> --- a/tools/perf/perf.h
> +++ b/tools/perf/perf.h
> @@ -6,7 +6,7 @@
>  #if defined(__i386__)
>  #define rmb()		asm volatile("lock; addl $0,0(%%esp)" ::: "memory")
>  #define cpu_relax()	asm volatile("rep; nop" ::: "memory");
> -#define CPUINFO_PROC	"model name"
> +#define CPUINFO_PROC	{"model name"}
>  #ifndef __NR_perf_event_open
>  # define __NR_perf_event_open 336
>  #endif
> @@ -15,7 +15,7 @@
>  #if defined(__x86_64__)
>  #define rmb()		asm volatile("lfence" ::: "memory")
>  #define cpu_relax()	asm volatile("rep; nop" ::: "memory");
> -#define CPUINFO_PROC	"model name"
> +#define CPUINFO_PROC	{"model name"}
>  #ifndef __NR_perf_event_open
>  # define __NR_perf_event_open 298
>  #endif
> @@ -25,7 +25,7 @@
>  #include "../../arch/powerpc/include/uapi/asm/unistd.h"
>  #define rmb()		asm volatile ("sync" ::: "memory")
>  #define cpu_relax()	asm volatile ("" ::: "memory");
> -#define CPUINFO_PROC	"cpu"
> +#define CPUINFO_PROC	{"cpu"}
>  #endif
>  
>  #ifdef __s390__
> @@ -40,31 +40,31 @@
>  # define rmb()		asm volatile("" ::: "memory")
>  #endif
>  #define cpu_relax()	asm volatile("" ::: "memory")
> -#define CPUINFO_PROC	"cpu type"
> +#define CPUINFO_PROC	{"cpu type"}
>  #endif
>  
>  #ifdef __hppa__
>  #define rmb()		asm volatile("" ::: "memory")
>  #define cpu_relax()	asm volatile("" ::: "memory");
> -#define CPUINFO_PROC	"cpu"
> +#define CPUINFO_PROC	{"cpu"}
>  #endif
>  
>  #ifdef __sparc__
>  #define rmb()		asm volatile("":::"memory")
>  #define cpu_relax()	asm volatile("":::"memory")
> -#define CPUINFO_PROC	"cpu"
> +#define CPUINFO_PROC	{"cpu"}
>  #endif
>  
>  #ifdef __alpha__
>  #define rmb()		asm volatile("mb" ::: "memory")
>  #define cpu_relax()	asm volatile("" ::: "memory")
> -#define CPUINFO_PROC	"cpu model"
> +#define CPUINFO_PROC	{"cpu model"}
>  #endif
>  
>  #ifdef __ia64__
>  #define rmb()		asm volatile ("mf" ::: "memory")
>  #define cpu_relax()	asm volatile ("hint @pause" ::: "memory")
> -#define CPUINFO_PROC	"model name"
> +#define CPUINFO_PROC	{"model name"}
>  #endif
>  
>  #ifdef __arm__
> @@ -74,7 +74,7 @@
>   */
>  #define rmb()		((void(*)(void))0xffff0fa0)()
>  #define cpu_relax()	asm volatile("":::"memory")
> -#define CPUINFO_PROC	"Processor"
> +#define CPUINFO_PROC	{"model name", "Processor"}
>  #endif
>  
>  #ifdef __aarch64__
> @@ -91,19 +91,19 @@
>  				: /* no input */			\
>  				: "memory")
>  #define cpu_relax()	asm volatile("" ::: "memory")
> -#define CPUINFO_PROC	"cpu model"
> +#define CPUINFO_PROC	{"cpu model"}
>  #endif
>  
>  #ifdef __arc__
>  #define rmb()		asm volatile("" ::: "memory")
>  #define cpu_relax()	rmb()
> -#define CPUINFO_PROC	"Processor"
> +#define CPUINFO_PROC	{"Processor"}
>  #endif
>  
>  #ifdef __metag__
>  #define rmb()		asm volatile("" ::: "memory")
>  #define cpu_relax()	asm volatile("" ::: "memory")
> -#define CPUINFO_PROC	"CPU"
> +#define CPUINFO_PROC	{"CPU"}
>  #endif
>  
>  #include <time.h>
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index b59350f..d48f571 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -550,16 +550,12 @@ static int write_version(int fd, struct perf_header *h __maybe_unused,
>  	return do_write_string(fd, perf_version_string);
>  }
>  
> -static int write_cpudesc(int fd, struct perf_header *h __maybe_unused,
> -		       struct perf_evlist *evlist __maybe_unused)
> +static int __write_cpudesc(int fd, const char *cpuinfo_proc)
>  {
> -#ifndef CPUINFO_PROC
> -#define CPUINFO_PROC NULL
> -#endif
>  	FILE *file;
>  	char *buf = NULL;
>  	char *s, *p;
> -	const char *search = CPUINFO_PROC;
> +	const char *search = cpuinfo_proc;
>  	size_t len = 0;
>  	int ret = -1;
>  
> @@ -611,6 +607,25 @@ done:
>  	return ret;
>  }
>  
> +static int write_cpudesc(int fd, struct perf_header *h __maybe_unused,
> +		       struct perf_evlist *evlist __maybe_unused)
> +{
> +#ifndef CPUINFO_PROC
> +#define CPUINFO_PROC {"model name", }
> +#endif
> +	const char *cpuinfo_procs[] = CPUINFO_PROC;
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(cpuinfo_procs); i++) {
> +		int ret;
> +		ret = __write_cpudesc(fd, cpuinfo_procs[i]);
> +		if (ret >= 0)
> +			return ret;
> +	}
> +	return -1;
> +}
> +
> +
>  static int write_nrcpus(int fd, struct perf_header *h __maybe_unused,
>  			struct perf_evlist *evlist __maybe_unused)
>  {
