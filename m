Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab3EPCnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 22:43:16 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:59092 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab3EPCnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 22:43:15 -0400
X-AuditID: 9c93016f-b7b9bae000002df2-df-519447c239cb
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
Subject: Re: [PATCH 09/15] perf ftrace: Add 'record' sub-command
References: <1368526439-31966-1-git-send-email-namhyung@kernel.org>
	<1368526439-31966-10-git-send-email-namhyung@kernel.org>
	<20130515212139.GD5814@krava.redhat.com>
Date: Thu, 16 May 2013 11:43:13 +0900
In-Reply-To: <20130515212139.GD5814@krava.redhat.com> (Jiri Olsa's message of
	"Wed, 15 May 2013 23:21:39 +0200")
Message-ID: <87fvxn4pby.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 May 2013 23:21:39 +0200, Jiri Olsa wrote:
> On Tue, May 14, 2013 at 07:13:53PM +0900, Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> The ftrace record command is for saving raw ftrace buffer contents
>> which can be get from per_cpu/cpuX/trace_pipe_raw.
>> 
>> Since ftrace events are generated very frequently so single thread for
>> recording mostly resulted in buffer overruns.  Thus it uses per-cpu
>> recorder thread to prevent such cases and they save the contents to
>> their own files.
>> 
>> These per-cpu data files are saved in a directory so that they can be
>> easily found when needed.  I chose the default directory name as
>> "perf.data.dir" and the first two (i.e. "perf.data") can be changed
>> with -o option.  The structure of the directory looks like:
>> 
>>   $ tree perf.data.dir
>>   perf.data.dir/
>>   |-- perf.header
>>   |-- trace-cpu0.buf
>>   |-- trace-cpu1.buf
>>   |-- trace-cpu2.buf
>>   `-- trace-cpu3.buf
>> 
>> In addition to trace-cpuX.buf files, it has perf.header file also.
>> The perf.header file is compatible with existing perf.data format and
>> contains usual event information, feature mask and sample data.  The
>> sample data is synthesized to indicate given cpu has a record file.
>
> so AFAICS we store sample event for each cpu we recorded (in record
> command) and by processing those samples (show/report) we get data
> files names for each cpu

Correct.

>
> hum, I might have missed some discussion about this, but seems
> like header feature fits better for this, as long as we store
> only cpus.. FTRACE_CPUS or something like thius with simple array

Well, there's no discussion on this side so far. :)

I wanted not to add a new header feature only for this but use existing
method (sample event) so that it also can be recognized - at least to
have very rough idea - by an incompatible version of the perf tool.
Maybe the event has more information like total number of samples as a
period.

>
> or if we are going to use event, maybe user event via
> enum perf_user_event_type fits better

IIRC some people don't want to add more user event types.

Thanks,
Namhyung
