Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbaCZT1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 15:27:41 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:65160 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbaCZT1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 15:27:40 -0400
Message-ID: <53332A28.70306@gmail.com>
Date: Wed, 26 Mar 2014 13:27:36 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, mingo@redhat.com, acme@ghostprotocols.net
Subject: Re: [PATCH] perf: make perf script actually spit out backtraces for
 events
References: <1395860245-12418-1-git-send-email-jbacik@fb.com>
In-Reply-To: <1395860245-12418-1-git-send-email-jbacik@fb.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/26/14, 12:57 PM, Josef Bacik wrote:
> We are trying to debug a problem internally and noticed that if we use perf
> record -g -e <tracepoint> and then try to use perf script to get the events and
> their backtraces that we weren't getting the backtraces, even though they were
> collected and would show up with perf report.  For some reason the tracepoint
> print stuff didn't have the right things set in order to print out backtraces.
> I have no idea why this is as adding them in there makes the backtraces come out
> properly, and if we don't use the -g option perf script still acts properly with
> those options set.  Hopefully this is the correct fix, it has fixed the problem
> for us.  Thanks,

You can manually request fields using the -f option.

That said ...

>
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
> NOTE: I looked at MAINTAINERS to see if there was a perf list and it didn't look
> like there was one, sorry if this is the wrong place to send patches to.
>
>   tools/perf/builtin-script.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
> index baf1798..6d14c06 100644
> --- a/tools/perf/builtin-script.c
> +++ b/tools/perf/builtin-script.c
> @@ -99,7 +99,9 @@ static struct {
>
>   		.fields = PERF_OUTPUT_COMM | PERF_OUTPUT_TID |
>   				  PERF_OUTPUT_CPU | PERF_OUTPUT_TIME |
> -				  PERF_OUTPUT_EVNAME | PERF_OUTPUT_TRACE,
> +				  PERF_OUTPUT_EVNAME | PERF_OUTPUT_TRACE |
> +				  PERF_OUTPUT_IP | PERF_OUTPUT_SYM |
> +				  PERF_OUTPUT_DSO,

A change has been applied to upstream:
https://lkml.org/lkml/2013/11/30/63


David

