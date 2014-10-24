Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbaJXAU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 20:20:26 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:58323 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670AbaJXAUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 20:20:20 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: byungchul.park@lge.com
Cc: rostedt@goodmis.org, mingo@redhat.com, jolsa@redhat.com,
        vanilla@blackduck.lge.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tracing, function_graph: fix micro seconds notation in comment
References: <1414052242-9828-1-git-send-email-byungchul.park@lge.com>
	<1414052242-9828-2-git-send-email-byungchul.park@lge.com>
Date: Fri, 24 Oct 2014 09:20:11 +0900
In-Reply-To: <1414052242-9828-2-git-send-email-byungchul.park@lge.com>
	(byungchul park's message of "Thu, 23 Oct 2014 17:17:21 +0900")
Message-ID: <87fveee2tg.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Byungchul,

On Thu, 23 Oct 2014 17:17:21 +0900, byungchul park wrote:
> From: Byungchul Park <byungchul.park@lge.com>
>
> Usually, "msecs" notation means milli-seconds, and "usecs" notation
> means micro-seconds. Since the unit used in the code is
> micro-seconds, the notation should be replaced from msecs to usecs.
> This confusing notation prevents us from understanding the code
> correctly.
>
> Signed-off-by: Byungchul Park <byungchul.park@lge.com>
> ---
>  kernel/trace/trace_functions_graph.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index f0a0c98..c18a1e3 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -822,10 +822,10 @@ print_graph_duration(unsigned long long duration, struct trace_seq *s,
>  
>  	/* Signal a overhead of time execution to the output */
>  	if (flags & TRACE_GRAPH_PRINT_OVERHEAD) {
> -		/* Duration exceeded 100 msecs */
> +		/* Duration exceeded 100 usecs */
>  		if (duration > 100000ULL)
>  			ret = trace_seq_puts(s, "! ");
> -		/* Duration exceeded 10 msecs */
> +		/* Duration exceeded 10 usecs */
>  		else if (duration > 10000ULL)

I thought the duration was in usec, but it seems not, it's in nsec, hmm.
Then this exceeding 10/100 usec is not meaningful - what about increaing
numbers in the conditional so that it can match to the comment?  That
will eliminate the need of the patch 2.

Also I think msecs_str in trace_print_graph_duration() should be renamed
to usecs_str.

Thanks,
Namhyung


>  			ret = trace_seq_puts(s, "+ ");
>  	}
