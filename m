Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbaJPNO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 09:14:26 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:37632 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbaJPNOY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 09:14:24 -0400
MIME-Version: 1.0
In-Reply-To: <20141015200630.GT3198@kernel.org>
References: <1412556363-26229-1-git-send-email-namhyung@kernel.org>
 <20141013181158.GA28191@krava.redhat.com> <20141015192441.GR3198@kernel.org> <20141015200630.GT3198@kernel.org>
From: Namhyung Kim <namhyung@kernel.org>
Date: Thu, 16 Oct 2014 22:14:03 +0900
X-Google-Sender-Auth: 0S1o9gV3xDuFPX_ywDHmAGo_J4c
Message-ID: <CAM9d7cg-i8AVrO_OJ2qhSUyToLb8XSHjvi31LErdd5bXTm4QSg@mail.gmail.com>
Subject: Re: [PATCHSET 0/5] perf tools: Speed up dwarf callchain
 post-unwinding for libunwind (v4)
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Thu, Oct 16, 2014 at 5:06 AM, Arnaldo Carvalho de Melo
<acme@kernel.org> wrote:
> Em Wed, Oct 15, 2014 at 04:24:41PM -0300, Arnaldo Carvalho de Melo escreveu:
>> Em Mon, Oct 13, 2014 at 08:11:58PM +0200, Jiri Olsa escreveu:
>> > On Mon, Oct 06, 2014 at 09:45:58AM +0900, Namhyung Kim wrote:
>> > > Hello,
>> > >
>> > > This is v4 for libunwind callchain post processing speed up.  It was
>> > > able to reduce 50% of processing time by using global cache provided
>> > > in libunwind.  In this version, I decided to use the existing
>> > > callchain_param.record_mode instead of adding a new field in the
>> > > symbol_conf.
>> > >
>> > > The patch 4 and 5 are just cleanups so that we can easily find out
>> > > that which part of code uses the thread->priv.
>> > >
>> > > You can also get it from 'perf/callchain-unwind-v4' branch on my tree:
>> > >
>> > >   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
>> > >
>> > > Thanks,
>> > > Namhyung
>> > >
>> > >
>> > > Namhyung Kim (5):
>> > >   perf report: Set callchain_param.record_mode for future use
>> > >   perf callchain: Create an address space per thread
>> > >   perf callchain: Use global caching provided by libunwind
>> > >   perf kvm: Use thread_{,_set}_priv helpers
>> > >   perf trace: Use thread_{,_set}_priv helpers
>> >
>> > Acked-by: Jiri Olsa <jolsa@kernel.org>
>>
>> Thanks, applied.
>
> Next time please run: (I'm fixing this up this time)

Sorry about that.  I'll check it next time.

Thanks,
Namhyung


>
> [acme@zoo linux]$ time make -C tools/perf build-test
> make: Entering directory `/home/git/linux/tools/perf'
> - make_pure: cd . && make -f Makefile DESTDIR=/tmp/tmp.RXWD6DlpLb
> - make_clean_all: cd . && make -f Makefile DESTDIR=/tmp/tmp.Xb83Au0dtp
>   clean all
> - make_python_perf_so: cd . && make -f Makefile
>   DESTDIR=/tmp/tmp.JjiHtvNXGP python/perf.so
> - make_debug: cd . && make -f Makefile DESTDIR=/tmp/tmp.4mbBkoB1Jz
>   DEBUG=1
> - make_no_libperl: cd . && make -f Makefile DESTDIR=/tmp/tmp.2I0aglyOsB
>   NO_LIBPERL=1
> - make_no_libpython: cd . && make -f Makefile
>   DESTDIR=/tmp/tmp.NDG6pNk8J0 NO_LIBPYTHON=1
> - make_no_scripts: cd . && make -f Makefile DESTDIR=/tmp/tmp.00jcSmJ2uP
>   NO_LIBPYTHON=1 NO_LIBPERL=1
> - make_no_newt: cd . && make -f Makefile DESTDIR=/tmp/tmp.rpiHSaU8sm
>   NO_NEWT=1
> - make_no_slang: cd . && make -f Makefile DESTDIR=/tmp/tmp.eq62JNazPt
>   NO_SLANG=1
> - make_no_gtk2: cd . && make -f Makefile DESTDIR=/tmp/tmp.D3uwXogwqj
>   NO_GTK2=1
> - make_no_ui: cd . && make -f Makefile DESTDIR=/tmp/tmp.0Dw4cAw1RZ
>   NO_NEWT=1 NO_SLANG=1 NO_GTK2=1
> - make_no_demangle: cd . && make -f Makefile DESTDIR=/tmp/tmp.6kFBIeDeSB
>   NO_DEMANGLE=1
> - make_no_libelf: cd . && make -f Makefile DESTDIR=/tmp/tmp.KTyAsiNqK5
>   NO_LIBELF=1
> cd . && make -f Makefile DESTDIR=/tmp/tmp.KTyAsiNqK5 NO_LIBELF=1
>   BUILD:   Doing 'make -j4' parallel build
> config/Makefile:396: Disabling post unwind, no support found.
>
> Auto-detecting system features:
> ...                         dwarf: [ on  ]
> ...                         glibc: [ on  ]
> ...                          gtk2: [ on  ]
> ...                      libaudit: [ on  ]
> ...                        libbfd: [ on  ]
> ...                        libelf: [ on  ]
> ...                       libnuma: [ on  ]
> ...                       libperl: [ on  ]
> ...                     libpython: [ on  ]
> ...                      libslang: [ on  ]
> ...                     libunwind: [ on  ]
> ...            libdw-dwarf-unwind: [ on  ]
>
>   GEN      common-cmds.h
>   BISON    util/pmu-bison.c
>   FLAGS:   * new build flags or prefix
>   BISON    util/parse-events-bison.c
>   CC       util/path.o
>   CC       util/rbtree.o
>   CC       util/bitmap.o
>   CC       util/hweight.o
>   CC       util/run-command.o
>   CC       util/quote.o
>   CC       util/strbuf.o
>   CC       util/strlist.o
>   CC       util/string.o
>   CC       util/strfilter.o
>   CC       util/top.o
>   CC       util/usage.o
>   CC       util/wrapper.o
>   CC       util/sigchain.o
>   CC       util/dso.o
>   CC       util/symbol.o
>   CC       util/color.o
>   CC       util/pager.o
>   CC       util/header.o
>   CC       util/callchain.o
>   CC       util/values.o
>   CC       util/debug.o
>   CC       util/machine.o
>   PERF_VERSION = 3.17.ga3a146
>   CC       util/map.o
> In file included from util/machine.c:14:0:
> util/unwind.h: In function ‘unwind__prepare_access’:
> util/unwind.h:47:57: error: unused parameter ‘thread’
> [-Werror=unused-parameter]
>  static inline int unwind__prepare_access(struct thread *thread)
>                                                          ^
> util/unwind.h: In function ‘unwind__finish_access’:
> util/unwind.h:52:57: error: unused parameter ‘thread’
> [-Werror=unused-parameter]
>  static inline void unwind__finish_access(struct thread *thread) {}
>                                                          ^
> cc1: all warnings being treated as errors
> make[3]: *** [util/machine.o] Error 1
> make[3]: *** Waiting for unfinished jobs....
> make[2]: *** [all] Error 2
>   test: test -x ./perf
> make[1]: *** [make_no_libelf] Error 1
> make: *** [build-test] Error 2
> make: Leaving directory `/home/git/linux/tools/perf'
>
> real    4m40.869s
> user    8m57.124s
> sys     1m12.853s
> [acme@zoo linux]$
>



-- 
Thanks,
Namhyung
