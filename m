Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760960AbaGYTT0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 15:19:26 -0400
Received: from mail-oi0-f47.google.com ([209.85.218.47]:48787 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758776AbaGYTTY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 15:19:24 -0400
MIME-Version: 1.0
Date: Fri, 25 Jul 2014 12:13:38 -0700
Message-ID: <CAK3+h2wRJj8xs10JwQ6=7-oQDVC9WM_qGuW52Otd9s2rxDf5QA@mail.gmail.com>
Subject: Build perf statically with all libunwind+dwaf for profiling userland
 process on constrained Linux box
From: Vincent Li <vincent.mc.li@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am on Fedora 20 and trying to build a static perf with  needed
library support, but it failed to detect the needed library, here is
the output

1, build dynamically detected the library ok

 [vincent@localhost perf]$ make
  BUILD:   Doing 'make -j4' parallel build
config/Makefile:422: GTK2 not found, disables GTK2 support. Please
install gtk2-devel or libgtk2.0-dev
config/Makefile:586: No numa.h found, disables 'perf bench numa mem'
benchmark, please install numactl-devel/libnuma-devel/libnuma-dev

Auto-detecting system features:
...                         dwarf: [ on  ]
...                         glibc: [ on  ]
...                          gtk2: [ OFF ]
...                      libaudit: [ on  ]
...                        libbfd: [ on  ]
...                        libelf: [ on  ]
...                       libnuma: [ OFF ]
...                       libperl: [ on  ]
...                     libpython: [ on  ]
...                      libslang: [ on  ]
...                     libunwind: [ on  ]
...            libdw-dwarf-unwind: [ on  ]
...     DWARF post unwind library: libunwind

2, build statically failed to detect the library

[vincent@localhost perf]$ make LDFLAGS=-static
  BUILD:   Doing 'make -j4' parallel build
config/Makefile:294: No libelf found, disables 'probe' tool, please
install elfutils-libelf-devel/libelf-dev
config/Makefile:357: Disabling post unwind, no support found.
config/Makefile:395: No libaudit.h found, disables 'trace' tool,
please install audit-libs-devel or libaudit-dev
config/Makefile:409: slang not found, disables TUI support. Please
install slang-devel or libslang-dev
config/Makefile:422: GTK2 not found, disables GTK2 support. Please
install gtk2-devel or libgtk2.0-dev
config/Makefile:499: No Python.h (for Python 2.x) was found
config/Makefile:499: Python support will not be built
config/Makefile:586: No numa.h found, disables 'perf bench numa mem'
benchmark, please install numactl-devel/libnuma-devel/libnuma-dev

Auto-detecting system features:
...                         dwarf: [ OFF ]
...                         glibc: [ on  ]
...                          gtk2: [ OFF ]
...                      libaudit: [ OFF ]
...                        libbfd: [ OFF ]
...                        libelf: [ OFF ]
...                       libnuma: [ OFF ]
...                       libperl: [ OFF ]
...                     libpython: [ OFF ]
...                      libslang: [ OFF ]
...                     libunwind: [ OFF ]
...            libdw-dwarf-unwind: [ OFF ]

I have a constrained centos-like Linux system (not centos)  that I
need to profile the userland process that is not compiled with GCC
option “-fno-omit-frame-pointer –ggdb”
https://bugzilla.redhat.com/show_bug.cgi?id=1025603.

it would be nice to be able to compile perf statically with needed
library support, could anyone share an idea how to resolve this?

sorry if this is not the right place to ask

Regards,

Vincent
