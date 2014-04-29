Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358AbaD2Go5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 02:44:57 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:65497 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125AbaD2Goz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 02:44:55 -0400
Date: Tue, 29 Apr 2014 08:44:51 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@kernel.org>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] perf tools: Fix bfd dependency libraries detection
Message-ID: <20140429064451.GA27951@gmail.com>
References: <1398676935-6615-1-git-send-email-jolsa@kernel.org>
 <535E6D65.80909@gmail.com>
 <20140428151740.GF18628@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140428151740.GF18628@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> On Mon, Apr 28, 2014 at 09:01:57AM -0600, David Ahern wrote:
> > On 4/28/14, 3:22 AM, Jiri Olsa wrote:
> > >From: Jiri Olsa <jolsa@redhat.com>
> > >
> > >There's false assumption in the library detection code
> > >assuming -liberty and -lz are always present once bfd
> > >is detected. The fails on Ubuntu (14.04) as reported
> > >by Ingo.
> > >
> > >Forcing the bdf dependency libraries detection any
> > >time bfd library is detected.
> > 
> > Have you tried static builds? I need to do those occasionally and I
> > always have to muck around with the Makefiles to get it to succeed
> > -- something with the -liberty and bfd checks.
> 
> hm, I just tried and even without of the fix I wasn't able
> to do static build.. so far I ended up with:
> 
> ---
>   $ make LDFLAGS=-static NO_LIBUNWIND=1 NO_GTK2=1 JOBS=1
>   ...
> 
>   SUBDIR   /home/jolsa/kernel.org/linux-perf/tools/lib/traceevent/
>   LINK     perf
> /bin/ld: cannot find -lelf
> /home/jolsa/kernel.org/linux-perf/tools/lib/traceevent/libtraceevent.a(event-plugin.o): In function `load_plugin':
> /home/jolsa/kernel.org/linux-perf/tools/lib/traceevent/event-plugin.c:60: warning: Using 'dlopen' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
> /bin/ld: cannot find -lelf
> /bin/ld: cannot find -ldw
> /bin/ld: cannot find -laudit
> /bin/ld: cannot find -lslang
> /bin/ld: cannot find -lperl
> libperf.a(target.o): In function `target__parse_uid':
> /home/jolsa/kernel.org/linux-perf/tools/perf/util/target.c:79: warning: Using 'getpwnam_r' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
> /home/jolsa/kernel.org/linux-perf/tools/perf/util/target.c:91: warning: Using 'getpwuid_r' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
> /usr/lib/gcc/x86_64-redhat-linux/4.8.2/../../../../lib64/libpthread.a(libpthread.o): In function `sem_open':
> (.text+0x67eb): warning: the use of `mktemp' is dangerous, better use `mkstemp'
> /bin/ld: cannot find -lpython2.7
> /bin/ld: cannot find -lz
> /bin/ld: cannot find -lnuma
> collect2: error: ld returned 1 exit status
> make[1]: *** [perf] Error 1
> make: *** [all] Error 2
> ---
> 
> Any hints what you did to make it pass?
> Let's fix it and put test for this in tests/make suite ;-)

/me agrees violently.

I try static builds every now and then, to be able to test perf on 
ancient systems with userspace that doesn't build perf anymore.

Thanks,

	Ingo
