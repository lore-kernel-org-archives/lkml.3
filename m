Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550AbbAPOtL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 09:49:11 -0500
Received: from usevmg21.ericsson.net ([198.24.6.65]:50886 "EHLO
	usevmg21.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbbAPOtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 09:49:07 -0500
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Jan 2015 09:49:07 EST
X-AuditID: c6180641-f79916d00000623a-74-54b8c2dec636
Message-ID: <54B9213A.2080104@ericsson.com>
Date: Fri, 16 Jan 2015 09:33:30 -0500
From: Matthew Khouzam <matthew.khouzam@ericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@kernel.org>, <linux-kernel@vger.kernel.org>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Dominique Toupin <dominique.toupin@ericsson.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCHv3 0/8] perf tools: Add perf data CTF conversion
References: <1421338556-20498-1-git-send-email-jolsa@kernel.org>
In-Reply-To: <1421338556-20498-1-git-send-email-jolsa@kernel.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [147.117.188.8]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsUyuXRPgu69QztCDD6sNrY42H2dzWLaxUnM
	Flv3vmGxmPm6m8niYcNfFosjU2YxW1zeNYfNYvPZM8wWN1YtZLdYc2Qxu8Xx3gNMFp+fH2F0
	4PFYevoNm8fOWXfZPTav0PLYtKqTzePduXPsHu/3XWXzmLurj9Hj8ya5AI4oLpuU1JzMstQi
	fbsEroxD6yewFUyzqHh1OLCBcYN2FyMHh4SAicSrhZ5djJxAppjEhXvr2boYuTiEBI4wSsyY
	tIAdwtnGKLGndRIbSBWvgLbEv9mrmUFsFgFVibt3HoHZbECDzk5ewgQyVFQgTOJ8MyNEuaDE
	yZlPWEBsEQEHidnt15lBZjILXGOWWDD1IytIQljAWeLdmR1g84WAijp7OthBbE4BR4ltl6aB
	2cwCBhJHFs1hhbDlJba/ncMMsktIQFPi8iFOiAcUJV4c/8k0gVFoFpLVs5B0z0LSvYCReRUj
	R2lxalluupHhJkZgFB2TYHPcwbjgk+UhRgEORiUe3g11O0KEWBPLiitzDzFKc7AoifNGPFof
	IiSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFxxrkDbftqGMxY11+rY2DXs492FNSdIlXw/OVH
	V57VsTkTPiU8UNq40zXQSfbO48VsNbmN8eF1FoolSa//THAR8igQNE2aZr2sXFNJp4Vv6xuf
	WSuOSN+483eGz7louaqge9I/K9LLW07v2nqPZ2m7qgSHr57WHwt7ngrPazcMTGUVHooePKjE
	UpyRaKjFXFScCABE1ttPgwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a Trace Compass developper, this opens a lot of possibilities for us,
like correlating PCAP, Perf and LTTng traces...

I hope it gets in soon as we already support it. :)
On 15-01-15 11:15 AM, Jiri Olsa wrote:
> hi,
> this is follow up on original RFC patchset:
>   http://marc.info/?t=140732735600004&r=1&w=2
>
> Basically we are adding 'perf data convert' command to
> allow conversion of perf data file into CTF [1] data.
>
> v3 changes:
>   - rebased to latest acme's perf/core
>
> v2 changes:
>   - addressed comments from Namhyung
>   - rebased to latest acme's perf/core
>
> Changes from RFC:
>   - able to generate CTF data, that are possible to be displayed under
>     tracecompas GUI [3], please check several screenshots in here [4]
>   - storing CTF data streams per cpu
>   - several cleanups
>
> Examples:
> - Catch default perf data (cycles event):
>   $ perf record ls
>   [ perf record: Woken up 1 times to write data ]
>   [ perf record: Captured and wrote 0.012 MB perf.data (~546 samples) ]
>
> - To display converted CTF data run [2]:
>   $ babeltrace ./ctf-data/
>   [03:19:13.962125533] (+?.?????????) cycles: { }, { ip = 0xFFFFFFFF8105443A, tid = 20714, pid = 20714, period = 1 }
>   [03:19:13.962130001] (+0.000004468) cycles: { }, { ip = 0xFFFFFFFF8105443A, tid = 20714, pid = 20714, period = 1 }
>   [03:19:13.962131936] (+0.000001935) cycles: { }, { ip = 0xFFFFFFFF8105443A, tid = 20714, pid = 20714, period = 8 }
>   [03:19:13.962133732] (+0.000001796) cycles: { }, { ip = 0xFFFFFFFF8105443A, tid = 20714, pid = 20714, period = 114 }
>   [03:19:13.962135557] (+0.000001825) cycles: { }, { ip = 0xFFFFFFFF8105443A, tid = 20714, pid = 20714, period = 2087 }
>   [03:19:13.962137627] (+0.000002070) cycles: { }, { ip = 0xFFFFFFFF81361938, tid = 20714, pid = 20714, period = 37582 }
>   [03:19:13.962161091] (+0.000023464) cycles: { }, { ip = 0xFFFFFFFF8124218F, tid = 20714, pid = 20714, period = 600246 }
>   [03:19:13.962517569] (+0.000356478) cycles: { }, { ip = 0xFFFFFFFF811A75DB, tid = 20714, pid = 20714, period = 1325731 }
>   [03:19:13.969518008] (+0.007000439) cycles: { }, { ip = 0x34080917B2, tid = 20714, pid = 20714, period = 1144298 }
>
> - To get some nice output in tracecompas GUI [3], please capture sched:*
>   and syscall tracepoints like:
>   # perf record -e 'sched:*,raw_syscalls:*' -a
>   ^C[ perf record: Woken up 0 times to write data ]
>   [ perf record: Captured and wrote 412.347 MB perf.data (~18015721 samples) ]
>
> - To convert perf data file run:
>   # perf data convert --to-ctf=./ctf 
>   [ perf data convert: Converted 'perf.data' into CTF data './ctf' ]
>   [ perf data convert: Converted and wrote 408.421 MB (3964792 samples) ]
>
> - To display converted CTF data run [2]:
>   # babeltrace ./ctf-data/
>   [23:32:20.165354855] (+0.000000507) sched:sched_wakeup: { cpu_id = 0 }, { perf_ip = 0xFFFFFFFF810BCA72, perf_tid = 0, perf_pid = 0, perf_id = 462554, perf_period = 1, common_type = 265, ...
>   [23:32:20.165359078] (+0.000001181) sched:sched_switch: { cpu_id = 0 }, { perf_ip = 0xFFFFFFFF8172A110, perf_tid = 0, perf_pid = 0, perf_id = 462562, perf_period = 1, common_type = 263, ...
>   [23:32:20.165364686] (+0.000000328) sched:sched_stat_runtime: { cpu_id = 0 }, { perf_ip = 0xFFFFFFFF810C8AE5, perf_tid = 5326, perf_pid = 5326, perf_id = 462610, perf_period = 11380, ...
>   [23:32:20.165366067] (+0.000001205) sched:sched_switch: { cpu_id = 0 }, { perf_ip = 0xFFFFFFFF8172A110, perf_tid = 5326, perf_pid = 5326, perf_id = 462562, perf_period = 1, common_type  ...
>   [23:32:20.165723312] (+0.000001479) sched:sched_stat_runtime: { cpu_id = 2 }, { perf_ip = 0xFFFFFFFF810C8AE5, perf_tid = 11821, perf_pid = 11821, perf_id = 462612, perf_period = 1000265, ...
>   [23:32:20.065282391] (+?.?????????) raw_syscalls:sys_enter: { cpu_id = 1 }, { perf_ip = 0xFFFFFFFF810230AF, perf_tid = 26155, perf_pid = 26155, perf_id = 462635, perf_period = 1, ...
>   [23:32:20.065286422] (+0.000004031) raw_syscalls:sys_exit: { cpu_id = 1 }, { perf_ip = 0xFFFFFFFF810231D8, perf_tid = 26155, perf_pid = 26155, perf_id = 462639, perf_period = 1, ...
>
> - Or run tracecompass and open the CTF data ;-)
>
> Changes are also reachable in here:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
>   perf/core_ctf_convert
>
> thanks,
> jirka
>
> [1] Common Trace Format - http://www.efficios.com/ctf
> [2] babeltrace - http://www.efficios.com/babeltrace
> [3] Trace compass - http://projects.eclipse.org/projects/tools.tracecompass
> [4] screenshots - http://people.redhat.com/~jolsa/tracecompass-perf/
>
>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Dominique Toupin <dominique.toupin@ericsson.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Jeremie Galarneau <jgalar@efficios.com>
> Cc: Jiri Olsa <jolsa@kernel.org>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Namhyung Kim <namhyung@gmail.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Tom Zanussi <tzanussi@gmail.com>
> ---
> Jiri Olsa (5):
>       perf tools: Add feature check for libbabeltrace
>       perf tools: Add new perf data command
>       perf data: Add perf data to CTF conversion support
>       perf data: Enable stream flush within processing
>       perf data: Add support for setting ordered_events queue size
>
> Sebastian Andrzej Siewior (3):
>       perf data: Add a 'perf' prefix to the generic fields
>       perf data: Add tracepoint events fields CTF conversion support
>       perf data: Switch to multiple cpu stream files
>
>  tools/perf/Documentation/perf-data.txt                |   40 ++
>  tools/perf/Documentation/perf.txt                     |    7 +-
>  tools/perf/Makefile.perf                              |    9 +-
>  tools/perf/builtin-data.c                             |  119 ++++++
>  tools/perf/builtin.h                                  |    1 +
>  tools/perf/command-list.txt                           |    1 +
>  tools/perf/config/Makefile                            |   24 ++
>  tools/perf/config/feature-checks/Makefile             |    8 +-
>  tools/perf/config/feature-checks/test-all.c           |    5 +
>  tools/perf/config/feature-checks/test-libbabeltrace.c |    8 +
>  tools/perf/perf.c                                     |    1 +
>  tools/perf/util/data-convert-bt.c                     | 1057 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tools/perf/util/data-convert-bt.h                     |    8 +
>  tools/perf/util/debug.c                               |    2 +
>  tools/perf/util/debug.h                               |    1 +
>  15 files changed, 1287 insertions(+), 4 deletions(-)
>  create mode 100644 tools/perf/Documentation/perf-data.txt
>  create mode 100644 tools/perf/builtin-data.c
>  create mode 100644 tools/perf/config/feature-checks/test-libbabeltrace.c
>  create mode 100644 tools/perf/util/data-convert-bt.c
>  create mode 100644 tools/perf/util/data-convert-bt.h

