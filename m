Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063AbaJ2IRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 04:17:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071AbaJ2IRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 04:17:44 -0400
Date: Wed, 29 Oct 2014 09:16:03 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Alexis Berlemont <alexis.berlemont@gmail.com>
Cc: linux-kernel@vger.kernel.org, dsahern@gmail.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, paulus@samba.org, acme@kernel.org,
        namhyung@kernel.org, mmarek@suse.cz,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Borislav Petkov <bp@alien8.de>, linux-kbuild@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v4 04/14] perf tools: Add kbuild support into
 Makefile.kbuild
Message-ID: <20141029081603.GC3538@krava.brq.redhat.com>
References: <20141024124601.GX14687@kernel.org>
 <1414275639-1053-5-git-send-email-alexis.berlemont@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414275639-1053-5-git-send-email-alexis.berlemont@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2014 at 12:20:29AM +0200, Alexis Berlemont wrote:
> From: Jiri Olsa <jolsa@redhat.com>

SNIP

> ---
>  tools/perf/Kbuild                                  |  47 +++
>  tools/perf/Kconfig                                 | 284 ++++++++++++++
>  tools/perf/Makefile.kbuild                         | 431 +++++++++++++++++++++
>  tools/perf/Makefile.perf                           |   2 +-
>  tools/perf/arch/Kbuild                             |   3 +
>  tools/perf/arch/arm/Kbuild                         |   2 +
>  tools/perf/arch/arm/Makefile                       |  14 -
>  tools/perf/arch/arm/tests/Kbuild                   |   2 +
>  tools/perf/arch/arm/util/Kbuild                    |   3 +
>  tools/perf/arch/arm64/Kbuild                       |   1 +
>  tools/perf/arch/arm64/Makefile                     |   7 -
>  tools/perf/arch/arm64/util/Kbuild                  |   2 +
>  tools/perf/arch/powerpc/Kbuild                     |   1 +
>  tools/perf/arch/powerpc/Makefile                   |   6 -
>  tools/perf/arch/powerpc/util/Kbuild                |   3 +
>  tools/perf/arch/s390/Kbuild                        |   1 +
>  tools/perf/arch/s390/Makefile                      |   7 -
>  tools/perf/arch/s390/util/Kbuild                   |   2 +
>  tools/perf/arch/sh/Kbuild                          |   1 +
>  tools/perf/arch/sh/Makefile                        |   4 -
>  tools/perf/arch/sh/util/Kbuild                     |   1 +
>  tools/perf/arch/sparc/Kbuild                       |   1 +
>  tools/perf/arch/sparc/Makefile                     |   4 -
>  tools/perf/arch/sparc/util/Kbuild                  |   1 +
>  tools/perf/arch/x86/Kbuild                         |   1 +
>  tools/perf/arch/x86/tests/Kbuild                   |   3 +
>  tools/perf/{ => arch/x86}/tests/perf-time-to-tsc.c |   0
>  tools/perf/arch/x86/util/Kbuild                    |   5 +
>  tools/perf/bench/Kbuild                            |  12 +
>  tools/perf/builtin-cmds.h                          |   4 +
>  tools/perf/config/Makefile                         |  55 ++-
>  tools/perf/config/Makefile.fix-config              | 104 +++++
>  tools/perf/config/Makefile.fix-legacy              |  46 +++
>  tools/perf/config/defconfig                        |  54 +++
>  tools/perf/perf-sys.h                              |   4 +-
>  tools/perf/scripts/perl/Perf-Trace-Util/Kbuild     |   6 +
>  tools/perf/scripts/python/Perf-Trace-Util/Kbuild   |   5 +
>  tools/perf/tests/Kbuild                            |  38 ++
>  tools/perf/ui/Kbuild                               |  15 +
>  tools/perf/ui/browsers/Kbuild                      |   9 +
>  tools/perf/ui/gtk/Kbuild                           |   9 +
>  tools/perf/ui/stdio/Kbuild                         |   1 +
>  tools/perf/ui/tui/Kbuild                           |   4 +
>  tools/perf/util/Kbuild                             | 126 ++++++
>  tools/perf/util/PERF-VERSION-GEN                   |   4 +
>  tools/perf/util/generate-cmdlist.sh                |   8 +-
>  tools/perf/util/scripting-engines/Kbuild           |  11 +
>  tools/perf/util/setup.py                           |   8 +-

so this patch took the perf Makefile (at that time) and changed it to
use the kbuild.. but since that time the Makefile.perf came and many
other changes, which need to be reflected in Makefile.kbuild

I need to revisit the logic and split the change into more incremental
patches (the patchset is too big)

I can redo patches 2,3,4 and get back to you, sounds ok?

thanks,
jirka
