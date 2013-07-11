Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812Ab3GKIBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 04:01:43 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:44184 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562Ab3GKIBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 04:01:42 -0400
X-AuditID: 9c93017d-b7b45ae000000e34-a2-51de66652e33
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
Subject: Re: [PATCH 10/19] perf ftrace: Add 'show' sub-command
References: <1372230862-15861-1-git-send-email-namhyung@kernel.org>
	<1372230862-15861-11-git-send-email-namhyung@kernel.org>
	<20130710144147.GD5931@krava.brq.redhat.com>
Date: Thu, 11 Jul 2013 17:01:40 +0900
In-Reply-To: <20130710144147.GD5931@krava.brq.redhat.com> (Jiri Olsa's message
	of "Wed, 10 Jul 2013 16:41:48 +0200")
Message-ID: <877ggxy17f.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Jul 2013 16:41:48 +0200, Jiri Olsa wrote:
> On Wed, Jun 26, 2013 at 04:14:13PM +0900, Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> The ftrace show subcommand is for viewing recorded ftrace files.  It
>> enters perf.data.dir directory and open perf.header file to find out
>> necessary information.  And then read out per-cpu trace records using
>> kbuffer helper and print them to stdout in time order.
>> 
>> It only shows its basic form so function graph doesn't show duration/
>> overhead and no leaf entry handling is provided yet.  Maybe it can be
>> handled by a proper plugin in the libtraceevent.
>> 
>
> [jolsa@krava perf]$ sudo ./perf ftrace show -i perf.data.dir/
> failed to open perf.data.dir/.dir/perf.header: No such file or directory
>
> I'd expect any directory name is possible

Oops, right!  I should handle the case.

Thanks,
Namhyung
