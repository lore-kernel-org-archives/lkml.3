Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747Ab3DYGGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 02:06:40 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:62407 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928Ab3DYGGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 02:06:39 -0400
X-AuditID: 9c93016f-b7b70ae0000038d5-b2-5178c7ed0278
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
Subject: Re: [PATCH 05/14] perf tools: Introduce new 'ftrace' tool
References: <1366705872-12132-1-git-send-email-namhyung@kernel.org>
	<1366705872-12132-6-git-send-email-namhyung@kernel.org>
	<20130424140918.GF971@krava.brq.redhat.com>
Date: Thu, 25 Apr 2013 15:06:37 +0900
In-Reply-To: <20130424140918.GF971@krava.brq.redhat.com> (Jiri Olsa's message
	of "Wed, 24 Apr 2013 16:09:18 +0200")
Message-ID: <87fvyf9maa.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Apr 2013 16:09:18 +0200, Jiri Olsa wrote:
> On Tue, Apr 23, 2013 at 05:31:03PM +0900, Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> +out:
>> +	put_tracing_file(file);
>> +	return ret;
>> +}
>> +
>> +static int reset_tracing_files(struct perf_ftrace *ftrace __maybe_unused)
>> +{
>> +	if (write_tracing_file("tracing_on", "0") < 0)
>> +		return -1;
>> +
>> +	if (write_tracing_file("current_tracer", "nop") < 0)
>> +		return -1;
>> +
>> +	if (write_tracing_file("set_ftrace_pid", " ") < 0)
>> +		return -1;
>
> I think we want to reset set_ftrace_pid file as well
> probably to -1..
>
> if I'm tracing command with this file having wrong CPU(s)
> I dont get any data..

Not sure I understood what you mean exactly.

Do you mean it should be changed to

	if (write_tracing_file("set_ftrace_pid", "-1") < 0)

?  It seems it's the right thing to do for compatibility.

Thanks,
Namhyung
