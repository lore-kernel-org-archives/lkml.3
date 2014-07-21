Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933487AbaGUSgD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 14:36:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933219AbaGUSgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 14:36:02 -0400
Date: Mon, 21 Jul 2014 20:35:30 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, acme@kernel.org,
        namhyung.kim@lge.com, tzanussi@gmail.com
Subject: Re: [RFC] perf to ctf converter
Message-ID: <20140721183530.GA28673@krava.redhat.com>
References: <20140603163640.GA16279@linutronix.de>
 <20140714141533.GD17761@krava.redhat.com>
 <20140721171151.GA12969@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140721171151.GA12969@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 07:11:51PM +0200, Sebastian Andrzej Siewior wrote:

SNIP

> I have the following now:
> 
> |$ ../perf data convert -i perf.data.backup --to-ctf ctf-out-backup && babeltrace ctf-out-backup
> |[11:01:45.468071953] (+?.?????????) raw_syscalls:sys_enter: { cpu_id = 0 }, { pid = 2906, comm = "sshd", id = 0xE, args = [ [0] = 0x0, [1] = 0x7FFF18EB71F0, [2] = 0x7FFF18EB7170, [3] = 0x8, [4] = 0x0, [5] = 0x0 ] }
> |[11:01:45.468074246] (+0.000002293) raw_syscalls:sys_enter: { cpu_id = 0 }, { pid = 2906, comm = "sshd", id = 0xE, args = [ [0] = 0x2, [1] = 0x7FFF18EB7170, [2] = 0x0, [3] = 0x8, [4] = 0x0, [5] = 0x0 ] }
> |[11:01:45.468076200] (+0.000001954) raw_syscalls:sys_enter: { cpu_id = 0 }, { pid = 2906, comm = "sshd", id = 0x0, args = [ [0] = 0xE, [1] = 0x7FFF18EB3140, [2] = 0x4000, [3] = 0x0, [4] = 0x8CF9, [5] = 0x0 ] }
> |[11:01:45.468097941] (+0.000021741) raw_syscalls:sys_enter: { cpu_id = 0 }, { pid = 2906, comm = "sshd", id = 0x17, args = [ [0] = 0x18, [1] = 0x7F9E804FBBB0, [2] = 0x7F9E804FBB90, [3] = 0x0, [4] = 0x0, [5] = 0x0 ] }
> |[11:01:45.468100727] (+0.000002786) raw_syscalls:sys_enter: { cpu_id = 0 }, { pid = 2906, comm = "sshd", id = 0xE, args = [ [0] = 0x0, [1] = 0x7FFF18EB71F0, [2] = 0x7FFF18EB7170, [3] = 0x8, [4] = 0x0, [5] = 0x0 ] }
> |[11:01:45.468101797] (+0.000001070) raw_syscalls:sys_enter: { cpu_id = 0 }, { pid = 2906, comm = "sshd", id = 0xE, args = [ [0] = 0x2, [1] = 0x7FFF18EB7170, [2] = 0x0, [3] = 0x8, [4] = 0x0, [5] = 0x0 ] }
> |[11:01:45.468103615] (+0.000001818) raw_syscalls:sys_enter: { cpu_id = 0 }, { pid = 2906, comm = "sshd", id = 0x1, args = [ [0] = 0x3, [1] = 0x7F9E805472E0, [2] = 0x30, [3] = 0x0, [4] = 0x8CF9, [5] = 0x0 ] }
> |[11:01:45.468126271] (+0.000022656) raw_syscalls:sys_enter: { cpu_id = 0 }, { pid = 2906, comm = "sshd", id = 0x17, args = [ [0] = 0x18, [1] = 0x7F9E804FBBB0, [2] = 0x7F9E804FBB90, [3] = 0x0, [4] = 0x0, [5] = 0x0 ] }
> |[11:01:45.468140058] (+0.000013787) raw_syscalls:sys_enter: { cpu_id = 0 }, { pid = 7121, comm = "perf_3.14", id = 0x10, args = [ [0] = 0x10, [1] = 0x2400, [2] = 0x0, [3] = 0x7FFFCCDED220, [4] = 0x2505110, [5] = 0x7FB588E31780 ] }
> |[11:01:45.468141518] (+0.000001460) raw_syscalls:sys_enter: { cpu_id = 0 }, { pid = 7121, comm = "perf_3.14", id = 0x10, args = [ [0] = 0x18, [1] = 0x2400, [2] = 0x0, [3] = 0x7FFFCCDED220, [4] = 0x2505110, [5] = 0x7FB588E31780 ] }
> …
> |[11:01:45.468208465] (+0.000000062) irq:softirq_raise: { cpu_id = 0 }, { pid = 0, comm = "swapper", vec = 3 }
> |[11:01:45.468209788] (+0.000001323) irq:softirq_entry: { cpu_id = 0 }, { pid = 0, comm = "swapper", vec = 3 }

heya,
I've  got following build error:

  CC       util/data-bt.o
util/data-bt.c: In function ‘add_event_tracepoint_value’:
util/data-bt.c:293:3: error: implicit declaration of function ‘bt_ctf_event_class_get_field_by_name’ [-Werror=implicit-function-declaration]
   type = bt_ctf_event_class_get_field_by_name(
   ^
util/data-bt.c:293:3: error: nested extern declaration of ‘bt_ctf_event_class_get_field_by_name’ [-Werror=nested-externs]
util/data-bt.c:293:8: error: assignment makes pointer from integer without a cast [-Werror]
   type = bt_ctf_event_class_get_field_by_name(
        ^
cc1: all warnings being treated as errors
make[1]: *** [util/data-bt.o] Error 1
make: *** [all] Error 2


but I might be missing some of the babeltrace changes, my branch:
  5805251d8079 Fix: mmap trace read the stream_id from the first packet

> …
> 
> In brief:
> - added support for PERF_TYPE_TRACEPOINT, broked everything else. Fixing
>   this on todo :)
> - added support for multiple type of arguments (pid & comm is "generic",
>   id, args, vec is based on tp_format which I don't fully understand but
>   it seems to work (the python script writes NR instead id or adds
>   "[action=NET_RX]" behind vec=3 and I haven't figured out what kind of
>   magic that is)).
> 
> I pushed my current state to:
>     http://git.breakpoint.cc/cgit/bigeasy/linux.git/log/?h=perf_ctf_3
>     git://git.breakpoint.cc/bigeasy/linux.git perf_ctf_3
> 
> It is based on TIP tree from last friday and I fixed up some of your
> cows :)
> 
> Some of your patches lack a sign-off by line. If I am allowed to add them
> then I would post the complete thing for a public review. Otherwiese I am
> open to suggestions how we could proceed here.

feel free to use/change my commits as you wish ;-)

I think the best would be to merge your changes with mine
into some meaningful patchset, before it goes to review

I'll check your changes

thanks,
jirka
