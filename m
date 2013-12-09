Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453Ab3LIKbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:31:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759232Ab3LIKbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:31:03 -0500
Date: Mon, 9 Dec 2013 11:30:23 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>
Subject: Re: [PATCH 0/2] perf tool: Carve out fs.* stuff
Message-ID: <20131209103023.GE1242@krava.brq.redhat.com>
References: <1386260752-16436-1-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386260752-16436-1-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 05:25:50PM +0100, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> Ok,
> 
> step one: carve out fs-related stuff into a libapikfs.a library.
> 

got similar failure as David by runnning 'make -f tests/make'

[jolsa@krava perf]$ make -f tests/make 
- make_pure: cd . && make -f Makefile DESTDIR=/tmp/tmp.nIVqbIKxHQ 

SNIP

- make_pure_O: cd . && make -f Makefile O=/tmp/tmp.CoL1PmqBBQ DESTDIR=/tmp/tmp.tpMfXhJGov 
make: *** [make_pure_O] Error 1

[jolsa@krava perf]$ cat make_pure_O 
cd . && make -f Makefile O=/tmp/tmp.CoL1PmqBBQ DESTDIR=/tmp/tmp.tpMfXhJGov
  BUILD:   Doing 'make -j4' parallel build

Auto-detecting system features:
...                     backtrace: [ on  ]
...                         dwarf: [ on  ]

SNIP

  CC       /tmp/tmp.CoL1PmqBBQ/scripts/python/Perf-Trace-Util/Context.o
  SUBDIR   /home/jolsa/kernel.org/linux-test/tools/lib/api/
  CC       /tmp/tmp.CoL1PmqBBQ/fs/debugfs.o
  SUBDIR   /home/jolsa/kernel.org/linux-test/tools/lib/traceevent/
  FLAGS:   * new build flags or cross compiler
Assembler messages:
Fatal error: can't create /tmp/tmp.CoL1PmqBBQ/fs/debugfs.o: No such file or directory
make[3]: *** [/tmp/tmp.CoL1PmqBBQ/fs/debugfs.o] Error 1
make[2]: *** [/tmp/tmp.CoL1PmqBBQ/libapikfs.a] Error 2
make[2]: *** Waiting for unfinished jobs....
  CC FPIC  event-parse.o
  CC FPIC  event-plugin.o
  CC FPIC  trace-seq.o
  CC FPIC  parse-filter.o


SNIP

  BUILD    PLUGIN plugin_cfg80211.so
  BUILD    STATIC LIB libtraceevent.a
make[3]: Nothing to be done for `plugins'.
make[1]: *** [all] Error 2


jirka
