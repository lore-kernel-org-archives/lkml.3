Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab3I3RMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 13:12:35 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:59710 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566Ab3I3RMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 13:12:33 -0400
Date: Mon, 30 Sep 2013 14:12:20 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH] perf auto-dep: Speed up feature tests by building them
 in parallel
Message-ID: <20130930171220.GC10293@ghostprotocols.net>
References: <20130912133855.GA23780@gmail.com>
 <CA+55aFwgyjqRHxLaWGxxsg_v07FrxbVTeLdHTGp7MfeSRjrKsQ@mail.gmail.com>
 <CA+55aFyCeXXr=57em8CC_Uzfk5PvOw0RHyA309wuOP-oDL7VxA@mail.gmail.com>
 <20130912184341.GA11400@ghostprotocols.net>
 <52321CE4.1080804@gmail.com>
 <20130912200236.GC11400@ghostprotocols.net>
 <20130912203116.GD32644@gmail.com>
 <20130912204313.GA3259@gmail.com>
 <20130915091029.GA21465@gmail.com>
 <20130930164210.GA22342@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130930164210.GA22342@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Sep 30, 2013 at 06:42:10PM +0200, Ingo Molnar escreveu:
> 
> This series (with combo patch attached) implements (much) faster 
> perf-tools feature-auto-detection.

Cool stuff!

Testing:

[acme@zoo linux]$ cat /etc/fedora-release 
Fedora release 18 (Spherical Cow)
[acme@zoo linux]$ time make -j4 -C tools/perf O=/tmp/build/perf install-bin

Auto-detecting system features:

...            stackprotector-all: [ on  ]
...         volatile-register-var: [ on  ]
...                fortify-source: [ on  ]
...                        libelf: [ on  ]
...                   libelf-mmap: [ on  ]
...                         glibc: [ on  ]
...                         dwarf: [ on  ]
...             libelf-getphdrnum: [ on  ]
...                     libunwind: [ on  ]
...                      libaudit: [ on  ]
...                      libslang: [ on  ]
...                          gtk2: [ on  ]
...                  gtk2-infobar: [ on  ]
...                       libperl: [ on  ]
...                     libpython: [ on  ]
...             libpython-version: [ on  ]
...                        libbfd: [ on  ]
...                       strlcpy: [ OFF ]
...                       on-exit: [ on  ]
...                     backtrace: [ on  ]
...                       libnuma: [ on  ]

make: Entering directory `/home/git/linux/tools/perf'
    MKDIR /tmp/build/perf/arch/

Checking why that strlcpy failed...

- Arnaldo
