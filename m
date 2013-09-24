Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab3IXAWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 20:22:42 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:49795 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab3IXAWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 20:22:41 -0400
Message-ID: <5240DB4D.100@gmail.com>
Date: Mon, 23 Sep 2013 18:22:37 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: acme@ghostprotocols.net
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] perf trace: Add mmap2 handler
References: <1379900700-5186-1-git-send-email-dsahern@gmail.com> <1379900700-5186-4-git-send-email-dsahern@gmail.com>
In-Reply-To: <1379900700-5186-4-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo:

I see this is you perf core tree; the problem exists in Linus' tree so 
it is needed in your urgent tree as well.

David

On 9/22/13 7:44 PM, David Ahern wrote:
> 5c5e854b changed perf_event__synthesize_mmap_events to generate MMAP2
> events. Since perf-trace does not have a handler for it it dies with a
> segfault when trying to process files:
>
> perf trace -i /tmp/perf.data
> Segmentation fault
>
> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---
>   tools/perf/builtin-trace.c |    1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
> index 9c7f017..f61c968 100644
> --- a/tools/perf/builtin-trace.c
> +++ b/tools/perf/builtin-trace.c
> @@ -1383,6 +1383,7 @@ static int trace__replay(struct trace *trace)
>
>   	trace->tool.sample	  = trace__process_sample;
>   	trace->tool.mmap	  = perf_event__process_mmap;
> +	trace->tool.mmap2	  = perf_event__process_mmap2;
>   	trace->tool.comm	  = perf_event__process_comm;
>   	trace->tool.exit	  = perf_event__process_exit;
>   	trace->tool.fork	  = perf_event__process_fork;
>

