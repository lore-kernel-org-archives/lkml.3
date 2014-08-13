Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751180AbaHMFdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:33:41 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:52779 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaHMFdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:33:40 -0400
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
Subject: Re: [PATCH 1/4] perf tools: Fix CLOEXEC probe for perf_event_paranoid == 2
References: <1407855871-15024-1-git-send-email-adrian.hunter@intel.com>
	<1407855871-15024-2-git-send-email-adrian.hunter@intel.com>
Date: Wed, 13 Aug 2014 14:33:38 +0900
In-Reply-To: <1407855871-15024-2-git-send-email-adrian.hunter@intel.com>
	(Adrian Hunter's message of "Tue, 12 Aug 2014 18:04:28 +0300")
Message-ID: <87mwb9dkct.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

On Tue, 12 Aug 2014 18:04:28 +0300, Adrian Hunter wrote:
> With /proc/sys/kernel/perf_event_paranoid set to 2, the
> probe of PERF_FLAG_FD_CLOEXEC would fail.  Fix by excluding
> kernel profiling from the probe event.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


> ---
>  tools/perf/util/cloexec.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/perf/util/cloexec.c b/tools/perf/util/cloexec.c
> index 5073c01..000047c 100644
> --- a/tools/perf/util/cloexec.c
> +++ b/tools/perf/util/cloexec.c
> @@ -11,6 +11,7 @@ static int perf_flag_probe(void)
>  	struct perf_event_attr attr = {
>  		.type = PERF_TYPE_SOFTWARE,
>  		.config = PERF_COUNT_SW_CPU_CLOCK,
> +		.exclude_kernel = 1,
>  	};
>  	int fd;
>  	int err;
