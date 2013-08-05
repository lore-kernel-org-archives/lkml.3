Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab3HEHos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 03:44:48 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:61661 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927Ab3HEHor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 03:44:47 -0400
X-AuditID: 9c93016f-b7b05ae000002bbd-2a-51ff57ed1e62
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Jeremy Eder <jeder@redhat.com>
Subject: Re: [PATCHSET 00/17] perf tools: Introduce new 'ftrace' command (v4)
References: <1375175954-798-1-git-send-email-namhyung@kernel.org>
	<20130801120251.GB1032@krava.brq.redhat.com>
	<20130802091659.GB26693@gmail.com>
Date: Mon, 05 Aug 2013 16:44:45 +0900
In-Reply-To: <20130802091659.GB26693@gmail.com> (Ingo Molnar's message of
	"Fri, 2 Aug 2013 11:16:59 +0200")
Message-ID: <87mwow1t02.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo and Jiri,

On Fri, 2 Aug 2013 11:16:59 +0200, Ingo Molnar wrote:
> * Jiri Olsa <jolsa@redhat.com> wrote:
>
>> On Tue, Jul 30, 2013 at 06:18:57PM +0900, Namhyung Kim wrote:
>> > This patchset implements a front-end tool for kernel's ftrace.  It
>> > uses function_graph tracer by default and normal function tracer is
>> > also supported.  (Of course you need to enable those tracers in your
>> > kernel first.)
>> > 
>> > v4 changes:
>> >  * use pid instead of tid for -p option (David)
>> >  * not to poll() for reading ftrace pipes (Jiri)
>> >  * rename to create_perf_header() (Jiri)
>> >  * canonicalize directory name (Jiri)
>> >  * show more info when -D option was given (Jiri)
>> >  * update documentation (Jiri)
>> >  * and few more bug fixes
>> > 
>> > I pushed it out to 'perf/ftrace-v4' branch on my tree at:
>> > 
>> >   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
>> > 
>> > 
>> > Any comments are welcome, thanks,
>> > Namhyung
>> 
>> hi,
>> I've got following error when compiling on Fedora 16:
>> 
>>         CC builtin-ftrace.o
>>     builtin-ftrace.c: In function ???set_tracing_clock???:
>>     builtin-ftrace.c:197:14: error: declaration of ???clock??? shadows a global declaration [-Werror=shadow]
>>     builtin-ftrace.c: In function ???canonicalize_directory_name???:
>>     builtin-ftrace.c:350:53: error: declaration of ???dirname??? shadows a global declaration [-Werror=shadow]
>>     cc1: all warnings being treated as errors
>> 
>> Fedora 17 seems to be ok.. strange ;-)
>
> Might be due to:
>
>    /usr/include/time.h:extern clock_t clock (void) __THROW;
>
> which is a sad namespace land-grab by time.h, 'clock' is such a nice local 
> variable name.

Thanks for the info.  I'll change the names.

Thanks,
Namhyung
