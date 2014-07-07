Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbaGGUsA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 16:48:00 -0400
Received: from mail.kernel.org ([198.145.19.201]:56199 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbaGGUr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 16:47:58 -0400
Date: Mon, 7 Jul 2014 17:47:52 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Jean Pihet <jean.pihet@linaro.org>
Subject: Re: [PATCH] perf tool: Carve out ctype.h et al
Message-ID: <20140707204752.GA11917@kernel.org>
References: <1403688184-6917-1-git-send-email-bp@alien8.de>
 <20140625192547.GF1153@krava.brq.redhat.com>
 <20140625203836.GD13845@pd.tnic>
 <20140625211757.GD18773@kernel.org>
 <20140626073802.GC1177@krava.brq.redhat.com>
 <20140626103223.GB1284@pd.tnic>
 <20140626121433.GA2600@krava.brq.redhat.com>
 <20140627232819.GB21418@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140627232819.GB21418@pd.tnic>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Jun 28, 2014 at 01:28:19AM +0200, Borislav Petkov escreveu:
> On Thu, Jun 26, 2014 at 02:14:33PM +0200, Jiri Olsa wrote:
> > this one compiles ok for me
 
> Ok, cool. So guys, can we apply this one so that I can continue with the
> next round?

Sorry, but not yet, tried to build it (the version that Jiri said worked
for him), after fixing up minor issues with blank lines being added to
the end of two of the files and then:

[acme@ssdandy linux]$ date ;time make -C tools/perf O=~/git/build/perf install-bin
Seg Jul  7 17:44:20 BRT 2014
make: Entering directory `/home/acme/git/linux/tools/perf'
  BUILD:   Doing 'make -j8' parallel build
config/Makefile:316: No libdw DWARF unwind found, Please install
elfutils-devel/libdw-dev >= 0.158 and/or set LIBDW_DIR

Auto-detecting system features:
...                         dwarf: [ on  ]
...                         glibc: [ on  ]
...                          gtk2: [ on  ]
...                      libaudit: [ on  ]
...                        libbfd: [ on  ]
...                        libelf: [ on  ]
...                       libnuma: [ on  ]
...                       libperl: [ on  ]
...                     libpython: [ on  ]
...                      libslang: [ on  ]
...                     libunwind: [ on  ]
...            libdw-dwarf-unwind: [ OFF ]
...     DWARF post unwind library: libunwind

make[1]: *** No rule to make target
`/home/acme/git/linux/tools/lib/symbol/kallsyms.o', needed by
`/home/acme/git/build/perf/libperf.a'.  Stop.
make[1]: *** Waiting for unfinished jobs....
make: *** [install-bin] Error 2
make: Leaving directory `/home/acme/git/linux/tools/perf'

real	0m3.407s
user	0m2.434s
sys	0m0.819s
[acme@ssdandy linux]$

It builds ok if you do a build when CWD is tools/perf/, but who does
that apart from Jiri? :-)

I'll try to fix this up later today, if you haven't done it by then.

Thanks,

- Arnaldo
