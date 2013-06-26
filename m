Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab3FZRMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 13:12:31 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:33426 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab3FZRM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 13:12:28 -0400
Message-ID: <51CB20F3.8000805@gmail.com>
Date: Wed, 26 Jun 2013 11:12:19 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 06/19] perf ftrace: Add support for --pid option
References: <1372230862-15861-1-git-send-email-namhyung@kernel.org> <1372230862-15861-7-git-send-email-namhyung@kernel.org>
In-Reply-To: <1372230862-15861-7-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/26/13 1:14 AM, Namhyung Kim wrote:
> @@ -196,6 +222,8 @@ int cmd_ftrace(int argc, const char **argv, const char *prefix __maybe_unused)
>   	const struct option ftrace_options[] = {
>   	OPT_STRING('t', "tracer", &ftrace.tracer, "tracer",
>   		   "tracer to use"),
> +	OPT_STRING('p', "pid", &ftrace.target.tid, "pid",
> +		   "trace on existing process id"),
>   	OPT_INCR('v', "verbose", &verbose,
>   		 "be more verbose"),
>   	OPT_END()

You are calling it pid but assigning it as a tid which is inconsistent 
with other perf commands. e.g., perf-record allows a list of pids (-p) 
or tids (-t). Why not support that in perf-ftrace? And that leads to the 
comment about consistency of options across perf commands: -t is used 
here for tracer type to use.

David

