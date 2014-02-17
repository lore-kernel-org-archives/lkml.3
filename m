Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbaBQTFP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 14:05:15 -0500
Received: from mail-yh0-f43.google.com ([209.85.213.43]:37219 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbaBQTFM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 14:05:12 -0500
Date: Mon, 17 Feb 2014 16:04:35 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, yrl.pp-manager.tt@hitachi.com,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH -tip v3 00/11] perf-probe: Updates for handling local
 functions correctly and distro debuginfo
Message-ID: <20140217190435.GC2779@ghostprotocols.net>
References: <20140206053201.29635.99095.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
 <52FDACF0.3030705@hitachi.com>
 <20140217182800.GB2779@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20140217182800.GB2779@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Feb 17, 2014 at 03:28:00PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Fri, Feb 14, 2014 at 02:43:12PM +0900, Masami Hiramatsu escreveu:
> > Ping? :)
> 
> One patch didn't apply, 10/11, and it does't passes the build tests,
> please try this before submitting patches:

Sorry, that was me trying to apply the patch that didn't pass, then when
I went to run 'make -C tools/perf build-test', it was using the sources
with the broken patch, now running after removing it, i.e. all patches
applied minus [PATCH 10/11]

- Arnaldo
 
> [acme@zoo linux]$ make -C tools/perf build-test
> make: Entering directory `/home/git/linux/tools/perf'
> - make_pure: cd . && make -f Makefile DESTDIR=/tmp/tmp.yQDeWAV994 
> make[1]: *** [make_pure] Error 1
> make: *** [build-test] Error 2
> make: Leaving directory `/home/git/linux/tools/perf'
> [acme@zoo linux]$`
> 
> Failed the first test, to check what was that failed, do this:
> 
> [acme@zoo linux]$ tail -9 tools/perf/make_pure 
> gcc -o ui/helpline.o -c  -Wbad-function-cast -Wdeclaration-after-statement -Wformat-security -Wformat-y2k -Winit-self -Wmissing-declarations -Wmissing-prototypes -Wnested-externs -Wno-system-headers -Wold-style-definition -Wpacked -Wredundant-decls -Wshadow -Wstrict-aliasing=3 -Wstrict-prototypes -Wswitch-default -Wswitch-enum -Wundef -Wwrite-strings -Wformat -DHAVE_ARCH_X86_64_SUPPORT -DHAVE_PERF_REGS_SUPPORT -Werror -O6 -fno-omit-frame-pointer -ggdb3 -funwind-tables -Wall -Wextra -std=gnu99 -fstack-protector-all -D_FORTIFY_SOURCE=2 -I/home/git/linux/tools/perf/util/include -I/home/git/linux/tools/perf/arch/x86/include -I/home/git/linux/tools/include/ -I/home/git/linux/arch/x86/include/uapi -I/home/git/linux/arch/x86/include -I/home/git/linux/include/uapi -I/home/git/linux/include -I/home/git/linux/tools/perf/util -I/home/git/linux/tools/perf -I/home/git/linux/tools/lib/ -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -DHAVE_LIBELF_SUPPORT -DHAVE_LIBELF_MMAP_SUPPORT -DHAVE_ELF_GETPHDRNUM_SUPPORT -DHAVE_DWARF_SUPPORT  -DNO_LIBUNWIND_DEBUG_FRAME -DHAVE_DWARF_UNWIND_SUPPORT -DHAVE_LIBUNWIND_SUPPORT  -DHAVE_LIBAUDIT_SUPPORT -I/usr/include/slang -DHAVE_SLANG_SUPPORT -DHAVE_GTK2_SUPPORT -DHAVE_TIMERFD_SUPPORT -DHAVE_LIBBFD_SUPPORT -DHAVE_ON_EXIT_SUPPORT -DHAVE_BACKTRACE_SUPPORT -DHAVE_LIBNUMA_SUPPORT ui/helpline.c
> util/probe-event.c: In function ‘add_exec_to_probe_trace_events’:
> util/probe-event.c:369:3: error: ‘offset’ undeclared (first use in this function)
> util/probe-event.c:369:3: note: each undeclared identifier is reported only once for each function it appears in
> util/probe-event.c:373:20: error: ‘buf’ undeclared (first use in this function)
> make[3]: *** [util/probe-event.o] Error 1
> make[3]: *** Waiting for unfinished jobs....
> make[2]: *** [all] Error 2
>   test: test -x ./perf
> [acme@zoo linux]$
> 
> So that lots of tests with multiple combos of features are performed.
> 
> Thanks,
> 
> - Arnaldo
>  
> > (2014/02/06 14:32), Masami Hiramatsu wrote:
> > > Hi,
> > > 
> > > Here is the 3rd version of the series for handling local
> > > functions correctly with perf-probe. This version also
> > > includes distro debuginfo-file support (a small
> > > enhancement, based on existing feature).
> > > 
> > > In this version, I used ref_reloc_sym based probe point
> > > instead of absolute address/"_stext", because kASLR
> > > changes the address offset randomly and the debuginfo
> > > doesn't know that offset. Recently perftools supports
> > > kASLR by introducing ref_reloc_sym (which is usually
> > > "_text" or "_stext"). Since we already ensured that
> > > the kmap->ref_reloc_sym symbol exists in the kernel,
> > > it is safe to reuse it for the reference point of
> > > probe points.
> > > 
> > > Note that this series requires a bugfix patch:
> > >   perf-probe: Do not add offset to uprobe address
> > >   https://lkml.org/lkml/2014/2/5/7
> > > 
> > > 
> > > Issue 1)
> > >  Current perf-probe can't handle probe-points for kprobes,
> > >  since it uses symbol-based probe definition. The symbol
> > >  based definition is easy to read and robust for differnt
> > >  kernel and modules. However, when user gives a local
> > >  function name which has several different instances,
> > >  it may put probes on wrong (or unexpected) address.
> > >  On the other hand, since uprobe events are based on the
> > >  actual address, it can avoid this issue.
> > > 
> > >  E.g.
> > > In the case to probe t_show local functions (which has
> > > 4 different instances.
> > >   ----
> > >   # grep " t_show\$" /proc/kallsyms
> > >   ffffffff810d9720 t t_show
> > >   ffffffff810e2e40 t t_show
> > >   ffffffff810ece30 t t_show
> > >   ffffffff810f4ad0 t t_show
> > >   # ./perf probe -fa "t_show \$vars"
> > >   Added new events:
> > >     probe:t_show         (on t_show with $vars)
> > >     probe:t_show_1       (on t_show with $vars)
> > >     probe:t_show_2       (on t_show with $vars)
> > >     probe:t_show_3       (on t_show with $vars)
> > > 
> > >   You can now use it in all perf tools, such as:
> > > 
> > >           perf record -e probe:t_show_3 -aR sleep 1
> > >   ----
> > > OK, we have 4 different t_show()s. All functions have
> > > different arguments as below;
> > >   ----
> > >   # cat /sys/kernel/debug/tracing/kprobe_events
> > >   p:probe/t_show t_show m=%di:u64 v=%si:u64
> > >   p:probe/t_show_1 t_show m=%di:u64 v=%si:u64 t=%si:u64
> > >   p:probe/t_show_2 t_show m=%di:u64 v=%si:u64 fmt=%si:u64
> > >   p:probe/t_show_3 t_show m=%di:u64 v=%si:u64 file=%si:u64
> > >   ----
> > > However, all of them have been put on the *same* address.
> > >   ----
> > >   # cat /sys/kernel/debug/kprobes/list
> > >   ffffffff810d9720  k  t_show+0x0    [DISABLED]
> > >   ffffffff810d9720  k  t_show+0x0    [DISABLED]
> > >   ffffffff810d9720  k  t_show+0x0    [DISABLED]
> > >   ffffffff810d9720  k  t_show+0x0    [DISABLED]
> > >   ----
> > >  oops...
> > > 
> > > Issue 2)
> > >  With the debuginfo, issue 1 can be solved by using
> > >  _stext-based probe definition instead of local symbol-based.
> > >  However, without debuginfo, perf-probe can only use
> > >  symbol-map in the binary (or kallsyms). The map provides
> > >  symbol find methods, but it returns only the first matched
> > >  symbol. To put probes on all functions which have given
> > >  symbol, we need a symbol-list iterator for the map.
> > > 
> > >  E.g. (built perf with NO_DWARF=1)
> > > In the case to probe t_show and identity__map_ip in perf.
> > >   ----
> > >   # ./perf probe -a t_show
> > >   Added new event:
> > >     probe:t_show         (on t_show)
> > > 
> > >   You can now use it in all perf tools, such as:
> > > 
> > >           perf record -e probe:t_show -aR sleep 1
> > > 
> > >   # ./perf probe -x perf -a identity__map_ip
> > >   no symbols found in /kbuild/ksrc/linux-3/tools/perf/perf, maybe install a debug package?
> > >   Failed to load map.
> > >     Error: Failed to add events. (-22)
> > >   ----
> > >  oops.....
> > > 
> > > 
> > > Solutions)
> > > To solve the issue 1, this series changes perf probe to
> > > use _stext-based probe definition. This means that we
> > > also need to fix the --list options to analyze actual
> > > probe address from _stext address. (and that has been
> > > done in this series).
> > > 
> > > E.g. with this series;
> > >   ----
> > >   # ./perf probe -a "t_show \$vars"
> > >   Added new events:
> > >     probe:t_show         (on t_show with $vars)
> > >     probe:t_show_1       (on t_show with $vars)
> > >     probe:t_show_2       (on t_show with $vars)
> > >     probe:t_show_3       (on t_show with $vars)
> > > 
> > >   You can now use it in all perf tools, such as:
> > > 
> > >           perf record -e probe:t_show_3 -aR sleep 1
> > > 
> > >   # cat /sys/kernel/debug/tracing/kprobe_events
> > >   p:probe/t_show _stext+889880 m=%di:u64 v=%si:u64
> > >   p:probe/t_show_1 _stext+928568 m=%di:u64 v=%si:u64 t=%si:u64
> > >   p:probe/t_show_2 _stext+969512 m=%di:u64 v=%si:u64 fmt=%si:u64
> > >   p:probe/t_show_3 _stext+1001416 m=%di:u64 v=%si:u64 file=%si:u64
> > > 
> > >   # cat /sys/kernel/debug/kprobes/list
> > >   ffffffffb50d95e0  k  t_show+0x0    [DISABLED]
> > >   ffffffffb50e2d00  k  t_show+0x0    [DISABLED]
> > >   ffffffffb50f4990  k  t_show+0x0    [DISABLED]
> > >   ffffffffb50eccf0  k  t_show+0x0    [DISABLED]
> > >   ----
> > > This time we can see the events are set in different
> > > addresses.
> > > 
> > > And for the issue 2, the last patch introduces symbol
> > > iterators for map, dso and symbols (since the symbol
> > > list is the symbols and it is included in dso, and perf
> > > probe accesses dso via map).
> > > 
> > > E.g. with this series (built perf with NO_DWARF=1);
> > >   ----
> > >   # ./perf probe -a t_show
> > >   Added new events:
> > >     probe:t_show         (on t_show)
> > >     probe:t_show_1       (on t_show)
> > >     probe:t_show_2       (on t_show)
> > >     probe:t_show_3       (on t_show)
> > > 
> > >   You can now use it in all perf tools, such as:
> > > 
> > >           perf record -e probe:t_show_3 -aR sleep 1
> > > 
> > >   # ./perf probe -x perf -a identity__map_ip
> > >   Added new events:
> > >     probe_perf:identity__map_ip (on identity__map_ip in /kbuild/ksrc/linux-3/tools/perf/perf)
> > >     probe_perf:identity__map_ip_1 (on identity__map_ip in /kbuild/ksrc/linux-3/tools/perf/perf)
> > >     probe_perf:identity__map_ip_2 (on identity__map_ip in /kbuild/ksrc/linux-3/tools/perf/perf)
> > >     probe_perf:identity__map_ip_3 (on identity__map_ip in /kbuild/ksrc/linux-3/tools/perf/perf)
> > > 
> > >   You can now use it in all perf tools, such as:
> > > 
> > >           perf record -e probe_perf:identity__map_ip_3 -aR sleep 1
> > >   ----
> > > Now, even without the debuginfo, both the kprobe and
> > > uprobe are set 4 different places correctly.
> > > 
> > > BTW, while testing above, I've found some bugs and
> > > another minor issue; perf-probe doesn't show the
> > > modules and binaries in which probes are set.
> > > I've also fixed it in this series as below.
> > > 
> > > Without the fix;
> > > 
> > >   # ./perf probe -m drm drm_av_sync_delay
> > >   # ./perf probe -x perf dso__load_vmlinux
> > > 
> > >   # ./perf probe -l
> > >     probe:drm_av_sync_delay (on drm_av_sync_delay)
> > >     probe_perf:dso__load_vmlinux (on 0x000000000006d110)
> > > 
> > > With this fix;
> > > 
> > >   # ./perf probe -l
> > >     probe:drm_av_sync_delay (on drm_av_sync_delay in drm)
> > >     probe_perf:dso__load_vmlinux (on 0x000000000006d110 in /kbuild/ksrc/linux-3/tools/perf/perf)
> > > 
> > > Changes from v2:
> > >  - Use ref_reloc_sym instead of "_stext" for reference point.
> > >    (Thanks for Namhyung Kim!)
> > >  - Add 2 cleanup patches for reducing the redundant features.
> > >  - Add distro-style debuginfo support.
> > > 
> > > TODO:
> > >  - Support local functions in modules. This requires kernel
> > >  side enhancement to allow setting probes by the relative
> > >  addresses in modules too.
> > >  - Uprobe-event MUST traces the change of given binary even
> > >  when the event is disabled. I've found that user can replace
> > >  the target binary after setting events and the events can be
> > >  enabled on the different instructions...
> > > 
> > > ---
> > > 
> > > Masami Hiramatsu (11):
> > >       [BUGFIX] perf-probe: Fix to do exit call for symbol maps
> > >       [CLEANUP] perf-probe: Remove incorrect symbol check for --list
> > >       [CLEANUP] perf-probe: Replace line_list with intlist
> > >       [CLEANUP] perf-probe: Unify show_available_functions for uprobes/kprobes
> > >       perf-probe: Show in what binaries/modules probes are set
> > >       perf-probe: Use ref_reloc_sym based address instead of the symbol name
> > >       perf-probe: Find given address from offline dwarf
> > >       perf-probe: Show appropriate symbol for ref_reloc_sym based kprobes
> > >       perf-probe: Show source-level or symbol-level info for uprobes
> > >       perf-probe: Allow to add events on the local functions
> > >       perf probe: Support distro-style debuginfo for uprobe
> > > 
> > > 
> > >  tools/perf/builtin-probe.c     |   12 -
> > >  tools/perf/util/dso.h          |   10 
> > >  tools/perf/util/map.h          |   10 
> > >  tools/perf/util/probe-event.c  |  863 ++++++++++++++++++++++------------------
> > >  tools/perf/util/probe-event.h  |   12 -
> > >  tools/perf/util/probe-finder.c |  198 ++-------
> > >  tools/perf/util/probe-finder.h |    5 
> > >  tools/perf/util/symbol.h       |   11 +
> > >  8 files changed, 566 insertions(+), 555 deletions(-)
> > > 
> > 
> > 
> > -- 
> > Masami HIRAMATSU
> > IT Management Research Dept. Linux Technology Center
> > Hitachi, Ltd., Yokohama Research Laboratory
> > E-mail: masami.hiramatsu.pt@hitachi.com
> > 
