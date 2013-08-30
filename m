Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab3H3O2h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 10:28:37 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:38552 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019Ab3H3O2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 10:28:36 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUWNrZQgjuXX+7JFgRKfCjYR_fSkfeRxHot_=xpLSaNaxg@mail.gmail.com>
References: <CA+icZUWNrZQgjuXX+7JFgRKfCjYR_fSkfeRxHot_=xpLSaNaxg@mail.gmail.com>
Date: Fri, 30 Aug 2013 16:28:34 +0200
Message-ID: <CA+icZUWNoq2+y511Mk8j_Vmo1_CdTmaG=2nLDz8oh6QPDqr_+A@mail.gmail.com>
Subject: Re: [3.11-rc7] Building perf-only the "official" way seems to be BROKEN?
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]

> [ BUILD PERF-ONLY ]
>
> So, I have finished a Linux-kernel build and wanted to build perf
> (from tools-dir) ONLY!
>
> I followed the advices (I am a "good" guy) seen for example in the
> "tools/Makefile" file.
>
> [ tools/Makefile ]
> ...
>         @echo 'You can do:'
>         @echo ' $$ make -C tools/ <tool>_install' <--- NOTE THIS ONE!
>         @echo ''
>         @echo '  from the kernel command line to build and install one of'
>         @echo '  the tools above'
>         @echo ''
>         @echo '  $$ make tools/install'
>         @echo ''
>         @echo '  installs all tools.'
> ...
>
> OK, so I did this for a perf-only build...
>
>
>    $ LANG=C LC_ALL=C make -C tools/ perf_install 2>&1 | tee ../build-perf.txt
>
> ...this breaks like this...
>
> ...
> make[2]: Entering directory
> `/home/wearefam/src/linux-kernel/linux/tools/lib/traceevent'
> make[2]: Leaving directory
> `/home/wearefam/src/linux-kernel/linux/tools/lib/traceevent'
>     LINK perf
> gcc: error: /home/wearefam/src/linux-kernel/linux/tools/lib/lk/liblk.a:
> No such file or directory
> make[1]: *** [perf] Error 1
> make[1]: Leaving directory `/home/wearefam/src/linux-kernel/linux/tools/perf'
> make: *** [perf_install] Error 2
>

[ From #linux-rt (OFTC) ]

[16:17] <acme> dileks_webchat, there are many, many ways to build the tools
[16:17] <acme> the one I use is:
[16:17] <acme> make O=/tmp/build/perf -C tools/perf install
[16:19] <dileks_webchat> acme:  make -C tools/perf install works as
expected. interesting :-)

- Sedat (dileks on IRC) -
