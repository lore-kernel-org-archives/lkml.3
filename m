Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbaJXB50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 21:57:26 -0400
Received: from mail.kernel.org ([198.145.19.201]:59418 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbaJXB5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 21:57:22 -0400
Date: Thu, 23 Oct 2014 22:57:17 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Wang Nan <wangnan0@huawei.com>
Cc: namhyung@kernel.org, linux-kernel@vger.kernel.org, lizefan@huawei.com
Subject: Re: [PATCH v3] perf tools: makes CPUINFO_PROC to array for different
 kernel version
Message-ID: <20141024015717.GW14687@kernel.org>
References: <1414115126-7479-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414115126-7479-1-git-send-email-wangnan0@huawei.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Oct 24, 2014 at 09:45:26AM +0800, Wang Nan escreveu:
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
> v2 -> v3:
>   - Rebase:
>     git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git perf/core

Thanks a lot, applying now.

- Arnaldo
 
> Signed-off-by: Wang Nan <wangnan0@huawei.com>
> Acked-by: Namhyung Kim <namhyung@kernel.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/perf-sys.h    | 30 +++++++++++++++---------------
>  tools/perf/util/header.c | 27 +++++++++++++++++++++------
>  2 files changed, 36 insertions(+), 21 deletions(-)
> 
> diff --git a/tools/perf/perf-sys.h b/tools/perf/perf-sys.h
> index 937e432..a3b13d7 100644
> --- a/tools/perf/perf-sys.h
> +++ b/tools/perf/perf-sys.h
> @@ -13,7 +13,7 @@
>  #define wmb()		asm volatile("lock; addl $0,0(%%esp)" ::: "memory")
>  #define rmb()		asm volatile("lock; addl $0,0(%%esp)" ::: "memory")
>  #define cpu_relax()	asm volatile("rep; nop" ::: "memory");
> -#define CPUINFO_PROC	"model name"
> +#define CPUINFO_PROC	{"model name"}
>  #ifndef __NR_perf_event_open
>  # define __NR_perf_event_open 336
>  #endif
> @@ -30,7 +30,7 @@
>  #define wmb()		asm volatile("sfence" ::: "memory")
>  #define rmb()		asm volatile("lfence" ::: "memory")
>  #define cpu_relax()	asm volatile("rep; nop" ::: "memory");
> -#define CPUINFO_PROC	"model name"
> +#define CPUINFO_PROC	{"model name"}
>  #ifndef __NR_perf_event_open
>  # define __NR_perf_event_open 298
>  #endif
> @@ -47,14 +47,14 @@
>  #define mb()		asm volatile ("sync" ::: "memory")
>  #define wmb()		asm volatile ("sync" ::: "memory")
>  #define rmb()		asm volatile ("sync" ::: "memory")
> -#define CPUINFO_PROC	"cpu"
> +#define CPUINFO_PROC	{"cpu"}
>  #endif
>  
>  #ifdef __s390__
>  #define mb()		asm volatile("bcr 15,0" ::: "memory")
>  #define wmb()		asm volatile("bcr 15,0" ::: "memory")
>  #define rmb()		asm volatile("bcr 15,0" ::: "memory")
> -#define CPUINFO_PROC	"vendor_id"
> +#define CPUINFO_PROC	{"vendor_id"}
>  #endif
>  
>  #ifdef __sh__
> @@ -67,14 +67,14 @@
>  # define wmb()		asm volatile("" ::: "memory")
>  # define rmb()		asm volatile("" ::: "memory")
>  #endif
> -#define CPUINFO_PROC	"cpu type"
> +#define CPUINFO_PROC	{"cpu type"}
>  #endif
>  
>  #ifdef __hppa__
>  #define mb()		asm volatile("" ::: "memory")
>  #define wmb()		asm volatile("" ::: "memory")
>  #define rmb()		asm volatile("" ::: "memory")
> -#define CPUINFO_PROC	"cpu"
> +#define CPUINFO_PROC	{"cpu"}
>  #endif
>  
>  #ifdef __sparc__
> @@ -87,14 +87,14 @@
>  #endif
>  #define wmb()		asm volatile("":::"memory")
>  #define rmb()		asm volatile("":::"memory")
> -#define CPUINFO_PROC	"cpu"
> +#define CPUINFO_PROC	{"cpu"}
>  #endif
>  
>  #ifdef __alpha__
>  #define mb()		asm volatile("mb" ::: "memory")
>  #define wmb()		asm volatile("wmb" ::: "memory")
>  #define rmb()		asm volatile("mb" ::: "memory")
> -#define CPUINFO_PROC	"cpu model"
> +#define CPUINFO_PROC	{"cpu model"}
>  #endif
>  
>  #ifdef __ia64__
> @@ -102,7 +102,7 @@
>  #define wmb()		asm volatile ("mf" ::: "memory")
>  #define rmb()		asm volatile ("mf" ::: "memory")
>  #define cpu_relax()	asm volatile ("hint @pause" ::: "memory")
> -#define CPUINFO_PROC	"model name"
> +#define CPUINFO_PROC	{"model name"}
>  #endif
>  
>  #ifdef __arm__
> @@ -113,7 +113,7 @@
>  #define mb()		((void(*)(void))0xffff0fa0)()
>  #define wmb()		((void(*)(void))0xffff0fa0)()
>  #define rmb()		((void(*)(void))0xffff0fa0)()
> -#define CPUINFO_PROC	"Processor"
> +#define CPUINFO_PROC	{"model name", "Processor"}
>  #endif
>  
>  #ifdef __aarch64__
> @@ -133,28 +133,28 @@
>  				: "memory")
>  #define wmb()	mb()
>  #define rmb()	mb()
> -#define CPUINFO_PROC	"cpu model"
> +#define CPUINFO_PROC	{"cpu model"}
>  #endif
>  
>  #ifdef __arc__
>  #define mb()		asm volatile("" ::: "memory")
>  #define wmb()		asm volatile("" ::: "memory")
>  #define rmb()		asm volatile("" ::: "memory")
> -#define CPUINFO_PROC	"Processor"
> +#define CPUINFO_PROC	{"Processor"}
>  #endif
>  
>  #ifdef __metag__
>  #define mb()		asm volatile("" ::: "memory")
>  #define wmb()		asm volatile("" ::: "memory")
>  #define rmb()		asm volatile("" ::: "memory")
> -#define CPUINFO_PROC	"CPU"
> +#define CPUINFO_PROC	{"CPU"}
>  #endif
>  
>  #ifdef __xtensa__
>  #define mb()		asm volatile("memw" ::: "memory")
>  #define wmb()		asm volatile("memw" ::: "memory")
>  #define rmb()		asm volatile("" ::: "memory")
> -#define CPUINFO_PROC	"core ID"
> +#define CPUINFO_PROC	{"core ID"}
>  #endif
>  
>  #ifdef __tile__
> @@ -162,7 +162,7 @@
>  #define wmb()		asm volatile ("mf" ::: "memory")
>  #define rmb()		asm volatile ("mf" ::: "memory")
>  #define cpu_relax()	asm volatile ("mfspr zero, PASS" ::: "memory")
> -#define CPUINFO_PROC    "model name"
> +#define CPUINFO_PROC    {"model name"}
>  #endif
>  
>  #define barrier() asm volatile ("" ::: "memory")
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index 39b80ac..0ecf4a3 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -579,16 +579,12 @@ static int write_version(int fd, struct perf_header *h __maybe_unused,
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
> @@ -640,6 +636,25 @@ done:
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
> -- 
> 1.8.4
