Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab3EPCra (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 22:47:30 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:42925 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181Ab3EPCr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 22:47:29 -0400
X-AuditID: 9c930179-b7b92ae0000035f7-52-519448bfdb38
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
Subject: Re: [PATCH 10/15] perf ftrace: Add 'show' sub-command
References: <1368526439-31966-1-git-send-email-namhyung@kernel.org>
	<1368526439-31966-11-git-send-email-namhyung@kernel.org>
	<20130515212108.GB5814@krava.redhat.com>
Date: Thu, 16 May 2013 11:47:27 +0900
In-Reply-To: <20130515212108.GB5814@krava.redhat.com> (Jiri Olsa's message of
	"Wed, 15 May 2013 23:21:08 +0200")
Message-ID: <87bo8b4p4w.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 May 2013 23:21:08 +0200, Jiri Olsa wrote:
> On Tue, May 14, 2013 at 07:13:54PM +0900, Namhyung Kim wrote:
>> +static int process_sample_show(struct perf_tool *tool,
>> +			       union perf_event * event __maybe_unused,
>> +			       struct perf_sample *sample,
>> +			       struct perf_evsel *evsel __maybe_unused,
>> +			       struct machine *machine __maybe_unused)
>> +{
>> +	struct perf_ftrace *ftrace;
>> +	struct perf_ftrace_report *show;
>> +	struct ftrace_report_arg *fra;
>> +	struct stat statbuf;
>> +	enum kbuffer_long_size long_size;
>> +	enum kbuffer_endian endian;
>> +	char buf[PATH_MAX];
>> +
>> +	show = container_of(tool, struct perf_ftrace_report, tool);
>> +	ftrace = show->ftrace;
>
> this seems to be exactly same routine as process_sample_report
> with exception of above 2 lines.. maybe the rest of it could be
> common function?

Hmm.. indeed.  I'd rather use just one of them as only thing they do is
to get the ftrace pointer.

Thanks for pointing this out,
Namhyung
