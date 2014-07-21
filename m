Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933149AbaGURLz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 13:11:55 -0400
Received: from www.linutronix.de ([62.245.132.108]:60811 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932883AbaGURLy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 13:11:54 -0400
Date: Mon, 21 Jul 2014 19:11:51 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, acme@kernel.org,
        namhyung.kim@lge.com, tzanussi@gmail.com
Subject: Re: [RFC] perf to ctf converter
Message-ID: <20140721171151.GA12969@linutronix.de>
References: <20140603163640.GA16279@linutronix.de>
 <20140714141533.GD17761@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20140714141533.GD17761@krava.redhat.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jiri Olsa | 2014-07-14 16:15:33 [+0200]:

>I made similar effort in C:
>
>---
>I made some *VERY* early perf convert example, mostly to try the ctf-writer
>interface.. you can check in here:
>  https://git.kernel.org/cgit/linux/kernel/git/jolsa/perf.git/log/?h=perf/ctf_2
>
>It's able to convert single event (HW type) perf.data file into CTF data,
>by adding just one integer field "period" and single stream, like:
>
>  [jolsa@krava perf]$ LD_LIBRARY_PATH=/opt/libbabeltrace/lib/ ./perf data convert --to-ctf=./ctf-data
>  ...
>  [jolsa@krava babeltrace]$ /opt/libbabeltrace/bin/babeltrace /home/jolsa/kernel.org/linux-perf/tools/perf/ctf-data
>  [08:14:45.814456098] (+?.?????????) cycles: { }, { period = 1 }
>  [08:14:45.814459237] (+0.000003139) cycles: { }, { period = 1 }
>  [08:14:45.814460684] (+0.000001447) cycles: { }, { period = 9 }
>  [08:14:45.814462073] (+0.000001389) cycles: { }, { period = 182 }
>  [08:14:45.814463491] (+0.000001418) cycles: { }, { period = 4263 }
>  [08:14:45.814465874] (+0.000002383) cycles: { }, { period = 97878 }
>  [08:14:45.814506385] (+0.000040511) cycles: { }, { period = 1365965 }
>  [08:14:45.815056528] (+0.000550143) cycles: { }, { period = 2250012 }
>---
>
>the goals for me is to have a convert tool, like in above example
>perf data command and support in perf record/report to directl
>write/read ctf data

I have the following now:

|$ ../perf data convert -i perf.data.backup --to-ctf ctf-out-backup && babeltrace ctf-out-backup
|[11:01:45.468071953] (+?.?????????) raw_syscalls:sys_enter: { cpu_id = 0 }, { pid = 2906, comm = "sshd", id = 0xE, args = [ [0] = 0x0, [1] = 0x7FFF18EB71F0, [2] = 0x7FFF18EB7170, [3] = 0x8, [4] = 0x0, [5] = 0x0 ] }
|[11:01:45.468074246] (+0.000002293) raw_syscalls:sys_enter: { cpu_id = 0 }, { pid = 2906, comm = "sshd", id = 0xE, args = [ [0] = 0x2, [1] = 0x7FFF18EB7170, [2] = 0x0, [3] = 0x8, [4] = 0x0, [5] = 0x0 ] }
|[11:01:45.468076200] (+0.000001954) raw_syscalls:sys_enter: { cpu_id = 0 }, { pid = 2906, comm = "sshd", id = 0x0, args = [ [0] = 0xE, [1] = 0x7FFF18EB3140, [2] = 0x4000, [3] = 0x0, [4] = 0x8CF9, [5] = 0x0 ] }
|[11:01:45.468097941] (+0.000021741) raw_syscalls:sys_enter: { cpu_id = 0 }, { pid = 2906, comm = "sshd", id = 0x17, args = [ [0] = 0x18, [1] = 0x7F9E804FBBB0, [2] = 0x7F9E804FBB90, [3] = 0x0, [4] = 0x0, [5] = 0x0 ] }
|[11:01:45.468100727] (+0.000002786) raw_syscalls:sys_enter: { cpu_id = 0 }, { pid = 2906, comm = "sshd", id = 0xE, args = [ [0] = 0x0, [1] = 0x7FFF18EB71F0, [2] = 0x7FFF18EB7170, [3] = 0x8, [4] = 0x0, [5] = 0x0 ] }
|[11:01:45.468101797] (+0.000001070) raw_syscalls:sys_enter: { cpu_id = 0 }, { pid = 2906, comm = "sshd", id = 0xE, args = [ [0] = 0x2, [1] = 0x7FFF18EB7170, [2] = 0x0, [3] = 0x8, [4] = 0x0, [5] = 0x0 ] }
|[11:01:45.468103615] (+0.000001818) raw_syscalls:sys_enter: { cpu_id = 0 }, { pid = 2906, comm = "sshd", id = 0x1, args = [ [0] = 0x3, [1] = 0x7F9E805472E0, [2] = 0x30, [3] = 0x0, [4] = 0x8CF9, [5] = 0x0 ] }
|[11:01:45.468126271] (+0.000022656) raw_syscalls:sys_enter: { cpu_id = 0 }, { pid = 2906, comm = "sshd", id = 0x17, args = [ [0] = 0x18, [1] = 0x7F9E804FBBB0, [2] = 0x7F9E804FBB90, [3] = 0x0, [4] = 0x0, [5] = 0x0 ] }
|[11:01:45.468140058] (+0.000013787) raw_syscalls:sys_enter: { cpu_id = 0 }, { pid = 7121, comm = "perf_3.14", id = 0x10, args = [ [0] = 0x10, [1] = 0x2400, [2] = 0x0, [3] = 0x7FFFCCDED220, [4] = 0x2505110, [5] = 0x7FB588E31780 ] }
|[11:01:45.468141518] (+0.000001460) raw_syscalls:sys_enter: { cpu_id = 0 }, { pid = 7121, comm = "perf_3.14", id = 0x10, args = [ [0] = 0x18, [1] = 0x2400, [2] = 0x0, [3] = 0x7FFFCCDED220, [4] = 0x2505110, [5] = 0x7FB588E31780 ] }
…
|[11:01:45.468208465] (+0.000000062) irq:softirq_raise: { cpu_id = 0 }, { pid = 0, comm = "swapper", vec = 3 }
|[11:01:45.468209788] (+0.000001323) irq:softirq_entry: { cpu_id = 0 }, { pid = 0, comm = "swapper", vec = 3 }
…

In brief:
- added support for PERF_TYPE_TRACEPOINT, broked everything else. Fixing
  this on todo :)
- added support for multiple type of arguments (pid & comm is "generic",
  id, args, vec is based on tp_format which I don't fully understand but
  it seems to work (the python script writes NR instead id or adds
  "[action=NET_RX]" behind vec=3 and I haven't figured out what kind of
  magic that is)).

I pushed my current state to:
    http://git.breakpoint.cc/cgit/bigeasy/linux.git/log/?h=perf_ctf_3
    git://git.breakpoint.cc/bigeasy/linux.git perf_ctf_3

It is based on TIP tree from last friday and I fixed up some of your
cows :)

Some of your patches lack a sign-off by line. If I am allowed to add them
then I would post the complete thing for a public review. Otherwiese I am
open to suggestions how we could proceed here.

>thanks,
>jirka

Sebastian
