Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbaAKR6V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 12:58:21 -0500
Received: from one.firstfloor.org ([193.170.194.197]:51075 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbaAKR6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 12:58:19 -0500
Date: Sat, 11 Jan 2014 18:58:16 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, acme@infradead.org,
        linux-kernel@vger.kernel.org, namhyung@kernel.org, eranian@google.com,
        fweisbec@gmail.com, mingo@kernel.org, adrian.hunter@intel.com,
        dsahern@gmail.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/4] perf, tools: Add support for prepending LBRs to
 the callstack
Message-ID: <20140111175816.GK20765@two.firstfloor.org>
References: <1389357126-3003-1-git-send-email-andi@firstfloor.org>
 <20140111153614.GC1131@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140111153614.GC1131@krava.brq.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 11, 2014 at 04:36:14PM +0100, Jiri Olsa wrote:
> On Fri, Jan 10, 2014 at 04:32:03AM -0800, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > I never found the default LBR display mode which generates histograms
> > of individual branches particularly useful.
> > 
> > This implements an alternative mode that creates histograms over complete
> > branch traces, instead of individual branches, similar to how normal
> > callgraphs are handled. This is done by putting it in
> > front of the normal callgraph and then using the normal callgraph
> > histogram infrastructure to unify them.
> > 
> > This way in complex functions we can understand the control flow
> > that lead to a particular sample.
> > 
> > The default output is unchanged.
> > 
> > This is only implemented in perf report, no change to record
> > or anywhere else.
> > 
> > This adds the basic code to report:
> > - add a new "branch" option to the -g option parser to enable this mode
> > - when the flag is set include the LBR into the callstack in machine.c.
> > The rest of the history code is unchanged and doesn't know the difference
> > between LBR entry and normal call entry.
> 
> sounds like nice idea, but I could not get the patchset applied
> on acme's perf/core

It was on Linus master.

I tried to rebase on perf/core, but it seems to be totally broken by
itself. All the config tests fail on my opensuse system.

Arnaldo?

Auto-detecting system features:
...                     backtrace: [ OFF ]
...                         dwarf: [ OFF ]
...                fortify-source: [ OFF ]
...                         glibc: [ OFF ]
...                          gtk2: [ OFF ]
...                  gtk2-infobar: [ OFF ]
...                      libaudit: [ OFF ]
...                        libbfd: [ OFF ]
...                        libelf: [ OFF ]
...             libelf-getphdrnum: [ OFF ]
...                   libelf-mmap: [ OFF ]
...                       libnuma: [ OFF ]
...                       libperl: [ OFF ]
...                     libpython: [ OFF ]
...             libpython-version: [ OFF ]
...                      libslang: [ OFF ]
...                     libunwind: [ OFF ]
...                       on-exit: [ OFF ]
...            stackprotector-all: [ OFF ]
...                       timerfd: [ OFF ]

config/Makefile:282: *** No gnu/libc-version.h found, please install
glibc-dev[el]/glibc-static.  Stop.
make: *** [all] Error 2

-Andi
