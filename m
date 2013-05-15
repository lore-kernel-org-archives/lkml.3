Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933162Ab3EOVV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 17:21:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932698Ab3EOVV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 17:21:56 -0400
Date: Wed, 15 May 2013 23:21:39 +0200
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
Subject: Re: [PATCH 09/15] perf ftrace: Add 'record' sub-command
Message-ID: <20130515212139.GD5814@krava.redhat.com>
References: <1368526439-31966-1-git-send-email-namhyung@kernel.org>
 <1368526439-31966-10-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368526439-31966-10-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 07:13:53PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> The ftrace record command is for saving raw ftrace buffer contents
> which can be get from per_cpu/cpuX/trace_pipe_raw.
> 
> Since ftrace events are generated very frequently so single thread for
> recording mostly resulted in buffer overruns.  Thus it uses per-cpu
> recorder thread to prevent such cases and they save the contents to
> their own files.
> 
> These per-cpu data files are saved in a directory so that they can be
> easily found when needed.  I chose the default directory name as
> "perf.data.dir" and the first two (i.e. "perf.data") can be changed
> with -o option.  The structure of the directory looks like:
> 
>   $ tree perf.data.dir
>   perf.data.dir/
>   |-- perf.header
>   |-- trace-cpu0.buf
>   |-- trace-cpu1.buf
>   |-- trace-cpu2.buf
>   `-- trace-cpu3.buf
> 
> In addition to trace-cpuX.buf files, it has perf.header file also.
> The perf.header file is compatible with existing perf.data format and
> contains usual event information, feature mask and sample data.  The
> sample data is synthesized to indicate given cpu has a record file.

so AFAICS we store sample event for each cpu we recorded (in record
command) and by processing those samples (show/report) we get data
files names for each cpu

hum, I might have missed some discussion about this, but seems
like header feature fits better for this, as long as we store
only cpus.. FTRACE_CPUS or something like thius with simple array

or if we are going to use event, maybe user event via
enum perf_user_event_type fits better

jirka
