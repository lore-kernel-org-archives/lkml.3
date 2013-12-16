Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab3LPNhr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 08:37:47 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:64462 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab3LPNhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 08:37:45 -0500
Date: Mon, 16 Dec 2013 10:37:35 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Pekka Enberg <penberg@kernel.org>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 2/2] perf: Move fs.* to lib/api/fs/
Message-ID: <20131216133735.GB3598@ghostprotocols.net>
References: <1386605664-24041-1-git-send-email-bp@alien8.de>
 <1386605664-24041-3-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386605664-24041-3-git-send-email-bp@alien8.de>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 09, 2013 at 05:14:24PM +0100, Borislav Petkov escreveu:
> From: Borislav Petkov <bp@suse.de>
> 
> Move to generic library and kill magic.h as it is needed only in fs.h.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>

Investigating...

[acme@ssdandy linux]$ am /wb/1
Applying: perf: Move fs.* to lib/api/fs/
[perf/core 5da46742cf76] perf tools: Move fs.* to lib/api/fs/
 Author: Borislav Petkov <bp@suse.de>
 10 files changed, 20 insertions(+), 25 deletions(-)
 rename tools/{perf/util => lib/api/fs}/fs.c (91%)
 rename tools/{perf/util/include/linux/magic.h => lib/api/fs/fs.h} (50%)
 delete mode 100644 tools/perf/util/fs.h
[acme@ssdandy linux]$ fg
bash: fg: current: no such job
[acme@ssdandy linux]$ time make O=/tmp/build/perf -C tools/perf/ install-bin
make: Entering directory `/home/acme/git/linux/tools/perf'
  BUILD:   Doing 'make -j8' parallel build
  GEN      perf-archive
  CC       /tmp/build/perf/util/pmu.o
  CC       /tmp/build/perf/util/cpumap.o
  CC       /tmp/build/perf/util/record.o
  CC       /tmp/build/perf/tests/parse-events.o
  GEN      /tmp/build/perf/python/perf.so
  AR       /tmp/build/perf/libperf.a
  LINK     /tmp/build/perf/libperf-gtk.so
  LINK     /tmp/build/perf/perf
  INSTALL  GTK UI
/tmp/build/perf/libperf.a(pmu.o): In function `pmu_type':
/home/acme/git/linux/tools/perf/util/pmu.c:314: undefined reference to `sysfs__mountpoint'
/tmp/build/perf/libperf.a(pmu.o): In function `pmu_cpumask':
/home/acme/git/linux/tools/perf/util/pmu.c:370: undefined reference to `sysfs__mountpoint'
/tmp/build/perf/libperf.a(pmu.o): In function `pmu_aliases':
/home/acme/git/linux/tools/perf/util/pmu.c:267: undefined reference to `sysfs__mountpoint'
/tmp/build/perf/libperf.a(pmu.o): In function `pmu_format':
/home/acme/git/linux/tools/perf/util/pmu.c:84: undefined reference to `sysfs__mountpoint'
/tmp/build/perf/libperf.a(pmu.o): In function `pmu_read_sysfs':
/home/acme/git/linux/tools/perf/util/pmu.c:342: undefined reference to `sysfs__mountpoint'
/tmp/build/perf/libperf.a(util.o): In function `perf_event_paranoid':
/home/acme/git/linux/tools/perf/util/util.c:506: undefined reference to `procfs__mountpoint'
/tmp/build/perf/libperf.a(cpumap.o): In function `cpu_map__get_socket':
/home/acme/git/linux/tools/perf/util/cpumap.c:219: undefined reference to `sysfs__mountpoint'
/tmp/build/perf/libperf.a(cpumap.o): In function `cpu_map__get_core':
/home/acme/git/linux/tools/perf/util/cpumap.c:282: undefined reference to `sysfs__mountpoint'
/tmp/build/perf/libperf.a(cpumap.o): In function `cpu_map__get_socket':
/home/acme/git/linux/tools/perf/util/cpumap.c:219: undefined reference to `sysfs__mountpoint'
/tmp/build/perf/libperf.a(record.o): In function `get_max_rate':
/home/acme/git/linux/tools/perf/util/record.c:115: undefined reference to `procfs__mountpoint'
/tmp/build/perf/libperf.a(parse-events.o): In function `test_pmu':
/home/acme/git/linux/tools/perf/tests/parse-events.c:1457: undefined reference to `sysfs__mountpoint'
/tmp/build/perf/libperf.a(parse-events.o): In function `test_pmu_events':
/home/acme/git/linux/tools/perf/tests/parse-events.c:1474: undefined reference to `sysfs__mountpoint'
collect2: error: ld returned 1 exit status
make[1]: *** [/tmp/build/perf/perf] Error 1
make[1]: *** Waiting for unfinished jobs....
util/util.c:3:16: fatal error: fs.h: No such file or directory
compilation terminated.
error: command 'gcc' failed with exit status 1
make: *** [install-bin] Error 2
make: Leaving directory `/home/acme/git/linux/tools/perf'

real	0m2.891s
user	0m5.030s
sys	0m0.668s
[acme@ssdandy linux]$ 

