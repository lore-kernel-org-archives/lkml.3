Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab3GJOp7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 10:45:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131Ab3GJOp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 10:45:58 -0400
Date: Wed, 10 Jul 2013 16:45:39 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 11/19] perf ftrace: Add 'report' sub-command
Message-ID: <20130710144539.GE5931@krava.brq.redhat.com>
References: <1372230862-15861-1-git-send-email-namhyung@kernel.org>
 <1372230862-15861-12-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372230862-15861-12-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 04:14:14PM +0900, Namhyung Kim wrote:

SNIP

>  
> +static int
> +__cmd_ftrace_report(struct perf_ftrace *ftrace, int argc, const char **argv)
> +{
> +	int ret = -1;
> +	const char * const report_usage[] = {
> +		"perf ftrace report [<options>]",
> +		NULL
> +	};
> +	const struct option report_options[] = {
> +	OPT_STRING('i', "input", &ftrace->dirname, "dirname",
> +		   "input directory name to use (default: perf.data)"),
> +	OPT_INCR('v', "verbose", &verbose,
> +		 "be more verbose"),
> +	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
> +		    "dump raw trace in ASCII"),

not sure dump_trace is useful here, it's just the first cpu-x samples
and then following 2 lines repeated MANY times:

 ... thread: ls:30064
 ...... dso: [kernel.kallsyms]

I guess you need this to verify first SAMPLEs?

jirka
