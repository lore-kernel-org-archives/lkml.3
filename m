Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471Ab3JJT01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 15:26:27 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:51989 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723Ab3JJT0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 15:26:25 -0400
Date: Thu, 10 Oct 2013 16:26:08 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [GIT PULL] tools/perf/build: Speed up the perf build system
Message-ID: <20131010192608.GI28369@ghostprotocols.net>
References: <20131009070149.GA32023@gmail.com>
 <20131009143830.GA28369@ghostprotocols.net>
 <20131009145157.GA27139@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009145157.GA27139@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two problems:

the message:

  BUILD:   Doing 'make -j1' parallel build

Looks funny: 'parallel' && -j1? :-)

This is on fedora12, on a kvm guest, nfs mounting /home/acme/git, all works
well up to the liblk.a part, cloning it to do it without NFS to continue
testing the integration of acme/perf/core with the build speedup patches.

- Arnaldo

----------------------

[acme@fedora12 linux]$ make O=/tmp/build/perf/ -C tools/perf install
make: Entering directory `/home/acme/git/linux/tools/perf'
  BUILD:   Doing 'make -j1' parallel build

Auto-detecting system features:
...                     backtrace: [ on  ]
...                         dwarf: [ OFF ]
...                fortify-source: [ on  ]
...                         glibc: [ on  ]
...                          gtk2: [ on  ]
...                  gtk2-infobar: [ on  ]
...                      libaudit: [ OFF ]
...                        libbfd: [ on  ]
...                        libelf: [ on  ]
...             libelf-getphdrnum: [ OFF ]
...                   libelf-mmap: [ on  ]
...                       libnuma: [ OFF ]
...                       libperl: [ OFF ]
...                     libpython: [ on  ]
...             libpython-version: [ on  ]
...                      libslang: [ on  ]
...                     libunwind: [ OFF ]
...                       on-exit: [ on  ]
...                stackprotector: [ on  ]
...            stackprotector-all: [ on  ]
...         volatile-register-var: [ on  ]

config/Makefile:278: No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev
config/Makefile:335: No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 0.99
config/Makefile:349: No libaudit.h found, disables 'trace' tool, please install audit-libs-devel or libaudit-dev
config/Makefile:519: No numa.h found, disables 'perf bench numa mem' benchmark, please install numa-libs-devel or libnuma-dev
  SUBDIR   /home/acme/git/linux/tools/lib/lk/
  AR       liblk.a
rm: cannot remove `liblk.a': Permission denied
make[2]: *** [liblk.a] Error 1
make[1]: *** [/tmp/build/perf/liblk.a] Error 2
make: *** [install] Error 2
make: Leaving directory `/home/acme/git/linux/tools/perf'
[acme@fedora12 linux]$ fg
-bash: fg: current: no such job
[acme@fedora12 linux]$ vim tools/perf/Makefile.perf 
[acme@fedora
