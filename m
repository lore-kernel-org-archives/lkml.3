Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759845Ab3GaO6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 10:58:33 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:56650 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab3GaO6b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 10:58:31 -0400
Date: Wed, 31 Jul 2013 11:58:20 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V2 1/9] perf tools: add test for reading object code
Message-ID: <20130731145820.GF3614@ghostprotocols.net>
References: <1375218838-31042-1-git-send-email-adrian.hunter@intel.com>
 <1375218838-31042-2-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1375218838-31042-2-git-send-email-adrian.hunter@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jul 31, 2013 at 12:13:50AM +0300, Adrian Hunter escreveu:
> Using the information in mmap events, perf tools can read object
> code associated with sampled addresses.  A test is added that
> compares bytes read by perf with the same bytes read using
> objdump.

investigating...

[root@zoo ~]# gdb perf
GNU gdb (GDB) Fedora (7.5.1-38.fc18)
Copyright (C) 2012 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-redhat-linux-gnu".
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>...
Reading symbols from /root/bin/perf...done.
(gdb) run test 21
Starting program: /root/bin/perf test 21
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib64/libthread_db.so.1".
21: Test object code reading                               :
Program received signal SIGSEGV, Segmentation fault.
0x000000000045a2d3 in xyarray__entry (xy=0x0, x=0, y=0) at util/xyarray.h:17
17		return &xy->contents[x * xy->row_size + y * xy->entry_size];
Missing separate debuginfos, use: debuginfo-install atk-2.6.0-1.fc18.x86_64 audit-libs-2.3.1-2.fc18.x86_64 bzip2-libs-1.0.6-7.fc18.x86_64 cairo-1.12.14-2.fc18.x86_64 elfutils-libelf-0.155-1.fc18.x86_64 elfutils-libs-0.155-1.fc18.x86_64 expat-2.1.0-4.fc18.x86_64 fontconfig-2.10.2-2.fc18.x86_64 freetype-2.4.10-4.fc18.x86_64 gdk-pixbuf2-2.26.5-1.fc18.x86_64 glib2-2.34.2-2.fc18.x86_64 graphite2-1.1.1-4.fc18.x86_64 gtk2-2.24.19-1.fc18.x86_64 harfbuzz-0.9.12-2.fc18.x86_64 libX11-1.5.99.901-3.20130524gita3bdd2b09.fc18.x86_64 libXau-1.0.6-4.fc18.x86_64 libXcomposite-0.4.3-4.fc18.x86_64 libXcursor-1.1.13-5.20130524git8f677eaea.fc18.x86_64 libXdamage-1.1.3-4.fc18.x86_64 libXext-1.3.1-3.20130524gitdfe6e1f3b.fc18.x86_64 libXfixes-5.0-6.20130524gitc480fe327.fc18.x86_64 libXi-1.6.2.901-1.fc18.x86_64 libXinerama-1.1.2-5.20130524git99c644fc8.fc18.x86_64 libXrandr-1.4.0-4.20130524gitc90f74497.fc18.x86_64 libXrender-0.9.7-5.20130524git786f78fd8.fc18.x86_64 libXxf86vm-1.1.2-5.20130524git4c4123441.fc18.x86_64 libdrm-2.4.45-1.fc18.x86_64 libffi-3.0.10-3.fc18.x86_64 libgcc-4.7.2-8.fc18.x86_64 libicu-49.1.1-8.fc18.x86_64 libpng-1.5.13-1.fc18.x86_64 libselinux-2.1.12-7.3.fc18.x86_64 libstdc++-4.7.2-8.fc18.x86_64 libunwind-1.0.1-5.fc18.x86_64 libwayland-client-1.0.5-1.fc18.x86_64 libwayland-server-1.0.5-1.fc18.x86_64 libxcb-1.9-3.fc18.x86_64 mesa-libEGL-9.2-0.7.20130528.fc18.x86_64 mesa-libGL-9.2-0.7.20130528.fc18.x86_64 mesa-libgbm-9.2-0.7.20130528.fc18.x86_64 mesa-libglapi-9.2-0.7.20130528.fc18.x86_64 nss-softokn-freebl-3.14.3-1.fc18.x86_64 numactl-libs-2.0.7-7.fc18.x86_64 pango-1.32.3-2.fc18.x86_64 pcre-8.31-5.fc18.x86_64 perl-libs-5.16.3-244.fc18.x86_64 pixman-0.28.0-1.fc18.x86_64 python-libs-2.7.3-13.fc18.x86_64 slang-2.2.4-5.fc18.x86_64 systemd-libs-201-2.fc18.7.x86_64 zlib-1.2.7-9.fc18.x86_64
(gdb) bt
#0  0x000000000045a2d3 in xyarray__entry (xy=0x0, x=0, y=0) at util/xyarray.h:17
#1  0x000000000045ade8 in perf_evlist__disable (evlist=0xcd3ad0) at util/evlist.c:238
#2  0x00000000004c1d06 in do_test_code_reading () at tests/code-reading.c:467
#3  0x00000000004c1dca in test__code_reading () at tests/code-reading.c:487
#4  0x0000000000447fb5 in __cmd_test (argc=1, argv=0x7fffffffe4d0, skiplist=0x0) at tests/builtin-test.c:163
#5  0x00000000004482ff in cmd_test (argc=1, argv=0x7fffffffe4d0, prefix=0x0) at tests/builtin-test.c:228
#6  0x000000000041a711 in run_builtin (p=0x7fc140 <commands+480>, argc=2, argv=0x7fffffffe4d0) at perf.c:319
#7  0x000000000041a949 in handle_internal_command (argc=2, argv=0x7fffffffe4d0) at perf.c:376
#8  0x000000000041aa95 in run_argv (argcp=0x7fffffffe3ac, argv=0x7fffffffe3a0) at perf.c:420
#9  0x000000000041ad37 in main (argc=2, argv=0x7fffffffe4d0) at perf.c:521
(gdb)
