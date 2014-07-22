Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbaGVL0B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:26:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbaGVLZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 07:25:59 -0400
Date: Tue, 22 Jul 2014 13:25:35 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, acme@kernel.org,
        namhyung.kim@lge.com, tzanussi@gmail.com
Subject: Re: [RFC] perf to ctf converter
Message-ID: <20140722112535.GA29750@krava.redhat.com>
References: <20140603163640.GA16279@linutronix.de>
 <20140714141533.GD17761@krava.redhat.com>
 <20140721171151.GA12969@linutronix.de>
 <20140721183530.GA28673@krava.redhat.com>
 <53CE0B89.7030400@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53CE0B89.7030400@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 08:58:17AM +0200, Sebastian Andrzej Siewior wrote:
> On 07/21/2014 08:35 PM, Jiri Olsa wrote:
> > On Mon, Jul 21, 2014 at 07:11:51PM +0200, Sebastian Andrzej Siewior wrote:
> >
> > heya,
> > I've  got following build error:
> > 
> >   CC       util/data-bt.o
> > util/data-bt.c: In function ‘add_event_tracepoint_value’:
> > util/data-bt.c:293:3: error: implicit declaration of function ‘bt_ctf_event_class_get_field_by_name’ [-Werror=implicit-function-declaration]
> >    type = bt_ctf_event_class_get_field_by_name(
> >    ^
> > util/data-bt.c:293:3: error: nested extern declaration of ‘bt_ctf_event_class_get_field_by_name’ [-Werror=nested-externs]
> > util/data-bt.c:293:8: error: assignment makes pointer from integer without a cast [-Werror]
> >    type = bt_ctf_event_class_get_field_by_name(
> >         ^
> > cc1: all warnings being treated as errors
> > make[1]: *** [util/data-bt.o] Error 1
> > make: *** [all] Error 2
> > 
> > 
> > but I might be missing some of the babeltrace changes, my branch:
> >   5805251d8079 Fix: mmap trace read the stream_id from the first packet
> 
> Hmm. This function should be there as of commit 2f100782231 in the
> master branch. However since my first post and now the babeltrace
> source got moved around a little and as a result you have some more
> header files.
> The function in question is defined in "babeltrace/ctf-ir/event.h" and
> included by "babeltrace/ctf-writer/event.h".

I've got it running... make LIBBABELTRACE_DIR=/opt/libbabeltrace/ ugh ;-)

[jolsa@krava perf]$ LD_LIBRARY_PATH=/opt/libbabeltrace/lib /opt/libbabeltrace/bin/babeltrace ./ctf-data/

[04:41:11.445378840] (+?.?????????) sched:sched_switch: { }, { pid = 5782, comm = "ls", prev_comm = [ [0] = "ls", [1] = "s", [2] = "", [3] = "f", [4] = "", [5] = "", [6] = "-x86_64-l", [7] = "x86_64-l", [8] = "86_64-l", [9] = "6_64-l", [10] = "_64-l", [11] = "64-l", [12] = "4-l", [13] = "-l", [14] = "l", [15] = "" ], prev_pid = 5782, prev_prio = 120, prev_state = 0x1, next_comm = [ [0] = "kworker/0:0", [1] = "worker/0:0", [2] = "orker/0:0", [3] = "rker/0:0", [4] = "ker/0:0", [5] = "er/0:0", [6] = "r/0:0", [7] = "/0:0", [8] = "0:0", [9] = ":0", [10] = "0", [11] = "", [12] = "", [13] = "", [14] = "", [15] = "" ], next_pid = 2376, next_prio = 120 }
[04:41:11.445390175] (+0.000011335) sched:sched_switch: { }, { pid = 5782, comm = "ls", prev_comm = [ [0] = "ls", [1] = "s", [2] = "", [3] = "f", [4] = "", [5] = "", [6] = "-x86_64-l", [7] = "x86_64-l", [8] = "86_64-l", [9] = "6_64-l", [10] = "_64-l", [11] = "64-l", [12] = "4-l", [13] = "-l", [14] = "l", [15] = "" ], prev_pid = 5782, prev_prio = 120, prev_state = 0x1, next_comm = [ [0] = "kworker/0:0", [1] = "worker/0:0", [2] = "orker/0:0", [3] = "rker/0:0", [4] = "ker/0:0", [5] = "er/0:0", [6] = "r/0:0", [7] = "/0:0", [8] = "0:0", [9] = ":0", [10] = "0", [11] = "", [12] = "", [13] = "", [14] = "", [15] = "" ], next_pid = 2376, next_prio = 120 }

...

looks like we need some better string arg handling,
but we'll get there soon or later

> 
> > feel free to use/change my commits as you wish ;-)
> 
> Thank you.
> 
> > 
> > I think the best would be to merge your changes with mine
> > into some meaningful patchset, before it goes to review
> 
> Yeah. I merged some of the fixups back and for the data-bt.c changes,
> dunno. Either all my changes as a single patch or merge it back into
> yours as it doesn't make sense to post each incremental change.

we'd like to have single/compact change commits.. so far I think 
we can go with following commits:

  perf tools: VF=2 code
  perf tools: Feature check for libbabeltrace
  perf tools: Add new data command

and merge your changes/fixies into:
  perf tools: Add perf data to CTF convertion support

if we could break the last one into more logical changes
it'd be nicer.. but if not, let's got from here

I'll prepare those 1st 3 patches.. and review your code while
getting familiar with ctf again ;-)

thanks,
jirka
