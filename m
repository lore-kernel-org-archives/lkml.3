Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861Ab3GKIKT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 04:10:19 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:64950 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755644Ab3GKIKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 04:10:14 -0400
X-AuditID: 9c93016f-b7c29ae00000722e-a4-51de68646b69
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 11/19] perf ftrace: Add 'report' sub-command
References: <1372230862-15861-1-git-send-email-namhyung@kernel.org>
	<1372230862-15861-12-git-send-email-namhyung@kernel.org>
	<20130710144539.GE5931@krava.brq.redhat.com>
Date: Thu, 11 Jul 2013 17:10:12 +0900
In-Reply-To: <20130710144539.GE5931@krava.brq.redhat.com> (Jiri Olsa's message
	of "Wed, 10 Jul 2013 16:45:39 +0200")
Message-ID: <8738rly0t7.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Jul 2013 16:45:39 +0200, Jiri Olsa wrote:
> On Wed, Jun 26, 2013 at 04:14:14PM +0900, Namhyung Kim wrote:
>
> SNIP
>
>>  
>> +static int
>> +__cmd_ftrace_report(struct perf_ftrace *ftrace, int argc, const char **argv)
>> +{
>> +	int ret = -1;
>> +	const char * const report_usage[] = {
>> +		"perf ftrace report [<options>]",
>> +		NULL
>> +	};
>> +	const struct option report_options[] = {
>> +	OPT_STRING('i', "input", &ftrace->dirname, "dirname",
>> +		   "input directory name to use (default: perf.data)"),
>> +	OPT_INCR('v', "verbose", &verbose,
>> +		 "be more verbose"),
>> +	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
>> +		    "dump raw trace in ASCII"),
>
> not sure dump_trace is useful here, it's just the first cpu-x samples
> and then following 2 lines repeated MANY times:
>
>  ... thread: ls:30064
>  ...... dso: [kernel.kallsyms]
>
> I guess you need this to verify first SAMPLEs?

I can't remember why exactly. ;-)

Probably I was thinking about adding more info like raw ftrace data.

Thanks,
Namhyung
