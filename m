Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab3JRSUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 14:20:32 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:43018 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976Ab3JRSUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 14:20:30 -0400
Message-ID: <52617BEB.8010808@gmail.com>
Date: Fri, 18 Oct 2013 12:20:27 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 17/19] perf script: print addr by default for BTS
References: <1382099356-4918-1-git-send-email-adrian.hunter@intel.com> <1382099356-4918-18-git-send-email-adrian.hunter@intel.com>
In-Reply-To: <1382099356-4918-18-git-send-email-adrian.hunter@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/13 6:29 AM, Adrian Hunter wrote:
> addr is not displayed by default for hardware events,
> however for branch events it is the target of the branch
> so for BTS display it by default if it was recorded.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>   tools/perf/builtin-script.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
> index 3f9a9bf..1a91621 100644
> --- a/tools/perf/builtin-script.c
> +++ b/tools/perf/builtin-script.c
> @@ -413,7 +413,9 @@ static void print_sample_bts(union perf_event *event,
>   	printf(" => ");
>
>   	/* print branch_to information */
> -	if (PRINT_FIELD(ADDR))
> +	if (PRINT_FIELD(ADDR) ||
> +	    ((evsel->attr.sample_type & PERF_SAMPLE_ADDR) &&
> +	     !output[attr->type].user_set))
>   		print_sample_addr(event, sample, machine, thread, attr);
>
>   	printf("\n");
>

Looks ok to me. Acked-by: David Ahern <dsahern@gmail.com>
