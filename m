Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582Ab3F0FXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 01:23:49 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:56371 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab3F0FXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 01:23:48 -0400
X-AuditID: 9c93017d-b7c09ae000006fa0-03-51cbcc62cf0e
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 06/19] perf ftrace: Add support for --pid option
References: <1372230862-15861-1-git-send-email-namhyung@kernel.org>
	<1372230862-15861-7-git-send-email-namhyung@kernel.org>
	<51CB20F3.8000805@gmail.com>
Date: Thu, 27 Jun 2013 14:23:46 +0900
In-Reply-To: <51CB20F3.8000805@gmail.com> (David Ahern's message of "Wed, 26
	Jun 2013 11:12:19 -0600")
Message-ID: <87ehbo15zx.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jun 2013 11:12:19 -0600, David Ahern wrote:
> On 6/26/13 1:14 AM, Namhyung Kim wrote:
>> @@ -196,6 +222,8 @@ int cmd_ftrace(int argc, const char **argv, const char *prefix __maybe_unused)
>>   	const struct option ftrace_options[] = {
>>   	OPT_STRING('t', "tracer", &ftrace.tracer, "tracer",
>>   		   "tracer to use"),
>> +	OPT_STRING('p', "pid", &ftrace.target.tid, "pid",
>> +		   "trace on existing process id"),
>>   	OPT_INCR('v', "verbose", &verbose,
>>   		 "be more verbose"),
>>   	OPT_END()
>
> You are calling it pid but assigning it as a tid which is inconsistent
> with other perf commands. e.g., perf-record allows a list of pids (-p)
> or tids (-t). Why not support that in perf-ftrace? And that leads to
> the comment about consistency of options across perf commands: -t is
> used here for tracer type to use.

Sorry, I should've mentioned it.

The pid filtering in ftrace is done via set_ftrace_pid file under the
tracing debugfs directory.  IIRC It only supports process filtering not
thread filtering by iterating all threads in the kernel code.  So --tid
option cannot be implemented as other perf commands.

So I chose not to and assigned -t option to --tracer.

Thanks,
Namhyung
