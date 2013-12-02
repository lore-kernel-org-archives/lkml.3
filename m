Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab3LBSaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 13:30:05 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:47372 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab3LBSaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 13:30:03 -0500
Message-ID: <529CD1A8.7080408@gmail.com>
Date: Mon, 02 Dec 2013 11:30:00 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
CC: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf tools: Make trace command to follow -m option
References: <1385657842-8914-1-git-send-email-jolsa@redhat.com>
In-Reply-To: <1385657842-8914-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/13, 9:57 AM, Jiri Olsa wrote:
> Currently trace command supports '-m' option, but
> does not follow its value and keeps the default.
>
> Changing the perf_evlist__mmap function call to use
> the '-m' configured value.
>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: David Ahern <dsahern@gmail.com>
> ---
>   tools/perf/builtin-trace.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
> index e9f345e2..9f2a242 100644
> --- a/tools/perf/builtin-trace.c
> +++ b/tools/perf/builtin-trace.c
> @@ -1890,7 +1890,7 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
>   	if (err < 0)
>   		goto out_error_open;
>
> -	err = perf_evlist__mmap(evlist, UINT_MAX, false);
> +	err = perf_evlist__mmap(evlist, trace->opts.mmap_pages, false);
>   	if (err < 0) {
>   		fprintf(trace->output, "Couldn't mmap the events: %s\n", strerror(errno));
>   		goto out_close_evlist;
>

Acked-by: David Ahern <dsahern@gmail.com>

