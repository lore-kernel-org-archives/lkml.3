Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272AbaHMFem (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:34:42 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:53914 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaHMFel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:34:41 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/4] perf tools: Fix one of the probe events to exclude kernel
References: <1407855871-15024-1-git-send-email-adrian.hunter@intel.com>
	<1407855871-15024-3-git-send-email-adrian.hunter@intel.com>
Date: Wed, 13 Aug 2014 14:34:33 +0900
In-Reply-To: <1407855871-15024-3-git-send-email-adrian.hunter@intel.com>
	(Adrian Hunter's message of "Tue, 12 Aug 2014 18:04:29 +0300")
Message-ID: <87iolxdkba.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2014 18:04:29 +0300, Adrian Hunter wrote:
> When probing the kernel API the kernel should be excluded
> otherwise the probe will fail for users with insufficient
> privilege to profile the kernel.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


> ---
>  tools/perf/util/record.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
> index 787b882..68ad2d0 100644
> --- a/tools/perf/util/record.c
> +++ b/tools/perf/util/record.c
> @@ -47,7 +47,7 @@ out_delete:
>  
>  static bool perf_probe_api(setup_probe_fn_t fn)
>  {
> -	const char *try[] = {"cycles:u", "instructions:u", "cpu-clock", NULL};
> +	const char *try[] = {"cycles:u", "instructions:u", "cpu-clock:u", NULL};
>  	struct cpu_map *cpus;
>  	int cpu, ret, i = 0;
