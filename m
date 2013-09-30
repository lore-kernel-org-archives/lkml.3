Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab3I3Nrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:47:31 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35742 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab3I3Nr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:47:29 -0400
Message-ID: <524980ED.2000507@gmail.com>
Date: Mon, 30 Sep 2013 07:47:25 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf stat: Set child_pid after perf_evlist__prepare_workload()
References: <1380531671-28076-1-git-send-email-namhyung@kernel.org>
In-Reply-To: <1380531671-28076-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/30/13 3:01 AM, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
>
> The commit acf2892270dc ("perf stat: Use perf_evlist__prepare/
> start_workload()") converted to use the function but forgot to update
> child_pid.  Fix it.
>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Stephane Eranian <eranian@google.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>   tools/perf/builtin-stat.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index f686d5ff594e..5098f144b92d 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -457,6 +457,7 @@ static int __run_perf_stat(int argc, const char **argv)
>   			perror("failed to prepare workload");
>   			return -1;
>   		}
> +		child_pid = evsel_list->workload.pid;
>   	}
>
>   	if (group)
>

Interesting. I can't find a test case where is matters ... perhaps a 
convenience of waitpid taking -1.

David
