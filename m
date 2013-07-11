Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab3GKH45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 03:56:57 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:53195 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab3GKH44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 03:56:56 -0400
X-AuditID: 9c93017d-b7b45ae000000e34-8c-51de654618e9
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
Subject: Re: [PATCH 06/19] perf ftrace: Add support for --pid option
References: <1372230862-15861-1-git-send-email-namhyung@kernel.org>
	<1372230862-15861-7-git-send-email-namhyung@kernel.org>
	<20130710141820.GA5931@krava.brq.redhat.com>
Date: Thu, 11 Jul 2013 16:56:54 +0900
In-Reply-To: <20130710141820.GA5931@krava.brq.redhat.com> (Jiri Olsa's message
	of "Wed, 10 Jul 2013 16:18:20 +0200")
Message-ID: <87fvvly1fd.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Jul 2013 16:18:20 +0200, Jiri Olsa wrote:
> On Wed, Jun 26, 2013 at 04:14:09PM +0900, Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> The -p (--pid) option enables to trace existing process by its pid.
>
> hi,
> I can't get any output from -p for live subcommand:
>
> [jolsa@krava perf]$ pgrep yes
> 6443
> [jolsa@krava perf]$ sudo ./perf ftrace live -p `pgrep yes`

Hmm... looks like it's stuck on polling the trace_pipe:

  $ sudo strace ./perf ftrace -p `pgrep yes'
  ...
  poll([{fd=3, events=POLLIN}], 1, 4294967295


Need to investigate it more.

Along with it, I found that I didn't close fd in
__write_tracing_file().  I'll fix it in the next spin too.

Thanks for the review and testing!
Namhyung
