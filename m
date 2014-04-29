Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344AbaD2IMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:12:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754937AbaD2IMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:12:39 -0400
Date: Tue, 29 Apr 2014 10:12:27 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] perf tools: Fix bfd dependency libraries detection
Message-ID: <20140429081227.GA1148@krava.brq.redhat.com>
References: <1398676935-6615-1-git-send-email-jolsa@kernel.org>
 <535E6D65.80909@gmail.com>
 <20140428151740.GF18628@krava.brq.redhat.com>
 <535E7258.4000408@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535E7258.4000408@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 09:23:04AM -0600, David Ahern wrote:
> On 4/28/14, 9:17 AM, Jiri Olsa wrote:
> >On Mon, Apr 28, 2014 at 09:01:57AM -0600, David Ahern wrote:
> >>On 4/28/14, 3:22 AM, Jiri Olsa wrote:
> >>>From: Jiri Olsa <jolsa@redhat.com>
> >>>
> >>>There's false assumption in the library detection code
> >>>assuming -liberty and -lz are always present once bfd
> >>>is detected. The fails on Ubuntu (14.04) as reported
> >>>by Ingo.
> >>>
> >>>Forcing the bdf dependency libraries detection any
> >>>time bfd library is detected.
> >>
> >>Have you tried static builds? I need to do those occasionally and I
> >>always have to muck around with the Makefiles to get it to succeed
> >>-- something with the -liberty and bfd checks.
> >
> >hm, I just tried and even without of the fix I wasn't able
> >to do static build.. so far I ended up with:
> >
> >---
> >   $ make LDFLAGS=-static NO_LIBUNWIND=1 NO_GTK2=1 JOBS=1
> >   ...
> >
> >   SUBDIR   /home/jolsa/kernel.org/linux-perf/tools/lib/traceevent/
> >   LINK     perf
> >/bin/ld: cannot find -lelf
> >/home/jolsa/kernel.org/linux-perf/tools/lib/traceevent/libtraceevent.a(event-plugin.o): In function `load_plugin':
> >/home/jolsa/kernel.org/linux-perf/tools/lib/traceevent/event-plugin.c:60: warning: Using 'dlopen' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
> >/bin/ld: cannot find -lelf
> >/bin/ld: cannot find -ldw
> >/bin/ld: cannot find -laudit
> >/bin/ld: cannot find -lslang
> >/bin/ld: cannot find -lperl
> >libperf.a(target.o): In function `target__parse_uid':
> >/home/jolsa/kernel.org/linux-perf/tools/perf/util/target.c:79: warning: Using 'getpwnam_r' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
> >/home/jolsa/kernel.org/linux-perf/tools/perf/util/target.c:91: warning: Using 'getpwuid_r' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
> >/usr/lib/gcc/x86_64-redhat-linux/4.8.2/../../../../lib64/libpthread.a(libpthread.o): In function `sem_open':
> >(.text+0x67eb): warning: the use of `mktemp' is dangerous, better use `mkstemp'
> >/bin/ld: cannot find -lpython2.7
> >/bin/ld: cannot find -lz
> >/bin/ld: cannot find -lnuma
> >collect2: error: ld returned 1 exit status
> >make[1]: *** [perf] Error 1
> >make: *** [all] Error 2
> >---
> >
> >Any hints what you did to make it pass?
> >Let's fix it and put test for this in tests/make suite ;-)
> 
> # rpm -qa | grep static
> glibc-static-2.14.90-24.fc16.9.x86_64
> audit-libs-static-2.2.1-1.fc16.x86_64
> elfutils-libelf-devel-static-0.154-2.fc16.x86_64
> zlib-static-1.2.5-7.fc16.x86_64
> 
> # make O=/tmp/junk LDFLAGS=-static

hum.. I must have some bad tree state ;-) I can do it now jsut with:
  $ make LDFLAGS=-static

only with glibc-static package

thanks,
jirka
