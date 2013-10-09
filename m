Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab3JITit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 15:38:49 -0400
Received: from mail-yh0-f54.google.com ([209.85.213.54]:60241 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab3JITis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 15:38:48 -0400
Date: Wed, 9 Oct 2013 16:38:39 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [GIT PULL] tools/perf/build: Speed up the perf build system
Message-ID: <20131009193839.GE28369@ghostprotocols.net>
References: <20131009070149.GA32023@gmail.com>
 <20131009143830.GA28369@ghostprotocols.net>
 <20131009145157.GA27139@gmail.com>
 <20131009191626.GD28369@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009191626.GD28369@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 09, 2013 at 04:16:26PM -0300, Arnaldo Carvalho de Melo escreveu:
> So while merging what I have in my perf/core branch I got to Vitillo's, as
> peterz called it, "inlining" of addr2line, i.e. using libbfd to do that work,
> it will look if lbfd is in EXTLIBS and if so, use it, otherwise we continue
> exec'in the addr2line tool.
> 
> Since this appears when doing the feature check:
> 
> ...                        libbfd: [ on  ]
> 
> I wanted to build just one object file that is related to this:
> 
> [acme@sandy linux]$ ls -la /tmp/build/perf/util/util/srcline.o
> ls: cannot access /tmp/build/perf/util/util/srcline.o: No such file or directory
> [acme@sandy linux]$ ls -la tools/perf/util/srcline.c 
> -rw-rw-r--. 1 acme acme 1777 Oct  9 16:06 tools/perf/util/srcline.c
> [acme@sandy linux]$ ls -la tools/perf/util/srcline.*
> -rw-rw-r--. 1 acme acme 1777 Oct  9 16:06 tools/perf/util/srcline.c
> [acme@sandy linux]$ make V=1 O=/tmp/build/perf -C tools/perf/ util/srcline.o
> make: Entering directory `/home/acme/git/linux/tools/perf'
>     BUILD: Doing 'make -j8' parallel build
>     # Redirected target util/srcline.o => /tmp/build/perf/util/util/srcline.o
> make: Leaving directory `/home/acme/git/linux/tools/perf'
> [acme@sandy linux]$ 
> [acme@sandy linux]$ ls -la /tmp/build/perf/util/util/srcline.o
> ls: cannot access /tmp/build/perf/util/util/srcline.o: No such file or directory
> [acme@sandy linux]$ make V=1 O=/tmp/build/perf -C tools/perf/ /tmp/build/perf/util/util/srcline.o
> make: Entering directory `/home/acme/git/linux/tools/perf'
>     BUILD: Doing 'make -j8' parallel build
> make[1]: *** No rule to make target `/tmp/build/perf/util/util/srcline.o'.  Stop.
> make: *** [/tmp/build/perf/util/util/srcline.o] Error 2
> make: Leaving directory `/home/acme/git/linux/tools/perf'
> [acme@sandy linux]$ ls -la tools/perf/util/srcline.*
> -rw-rw-r--. 1 acme acme 1777 Oct  9 16:06 tools/perf/util/srcline.c
> [acme@sandy linux]$
> 
> 	What am I doing wrong here while trying to build just one .o file?
> 
> 	Back to checking why it is not using the 'inline' addr2line...

For the record, it is now working, HAVE_LIBBFD_SUPPORT is set once -lbfd
is found on EXTLIBS, etc, as written by Robert in the original patch,
thinko on my part, its just the building of single .o files that doesn't
seem to work.

- Arnaldo
