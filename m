Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbaAKTXx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 14:23:53 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53004 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbaAKTXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 14:23:50 -0500
Date: Sat, 11 Jan 2014 16:16:57 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        namhyung@kernel.org, eranian@google.com, fweisbec@gmail.com,
        mingo@kernel.org, adrian.hunter@intel.com, dsahern@gmail.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/4] perf, tools: Add support for prepending LBRs to the
 callstack
Message-ID: <20140111191657.GB17659@ghostprotocols.net>
References: <1389357126-3003-1-git-send-email-andi@firstfloor.org>
 <20140111153614.GC1131@krava.brq.redhat.com>
 <20140111175816.GK20765@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140111175816.GK20765@two.firstfloor.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Jan 11, 2014 at 06:58:16PM +0100, Andi Kleen escreveu:
> On Sat, Jan 11, 2014 at 04:36:14PM +0100, Jiri Olsa wrote:
> > On Fri, Jan 10, 2014 at 04:32:03AM -0800, Andi Kleen wrote:
> > > From: Andi Kleen <ak@linux.intel.com>
> > > 
> > > I never found the default LBR display mode which generates histograms
> > > of individual branches particularly useful.
> > > 
> > > This implements an alternative mode that creates histograms over complete
> > > branch traces, instead of individual branches, similar to how normal
> > > callgraphs are handled. This is done by putting it in
> > > front of the normal callgraph and then using the normal callgraph
> > > histogram infrastructure to unify them.
> > > 
> > > This way in complex functions we can understand the control flow
> > > that lead to a particular sample.
> > > 
> > > The default output is unchanged.
> > > 
> > > This is only implemented in perf report, no change to record
> > > or anywhere else.
> > > 
> > > This adds the basic code to report:
> > > - add a new "branch" option to the -g option parser to enable this mode
> > > - when the flag is set include the LBR into the callstack in machine.c.
> > > The rest of the history code is unchanged and doesn't know the difference
> > > between LBR entry and normal call entry.
> > 
> > sounds like nice idea, but I could not get the patchset applied
> > on acme's perf/core
> 
> It was on Linus master.
> 
> I tried to rebase on perf/core, but it seems to be totally broken by
> itself. All the config tests fail on my opensuse system.
> 
> Arnaldo?

Oops, checking on some systems...
 
> Auto-detecting system features:
> ...                     backtrace: [ OFF ]
> ...                         dwarf: [ OFF ]
> ...                fortify-source: [ OFF ]
> ...                         glibc: [ OFF ]
> ...                          gtk2: [ OFF ]
> ...                  gtk2-infobar: [ OFF ]
> ...                      libaudit: [ OFF ]
> ...                        libbfd: [ OFF ]
> ...                        libelf: [ OFF ]
> ...             libelf-getphdrnum: [ OFF ]
> ...                   libelf-mmap: [ OFF ]
> ...                       libnuma: [ OFF ]
> ...                       libperl: [ OFF ]
> ...                     libpython: [ OFF ]
> ...             libpython-version: [ OFF ]
> ...                      libslang: [ OFF ]
> ...                     libunwind: [ OFF ]
> ...                       on-exit: [ OFF ]
> ...            stackprotector-all: [ OFF ]
> ...                       timerfd: [ OFF ]
> 
> config/Makefile:282: *** No gnu/libc-version.h found, please install
> glibc-dev[el]/glibc-static.  Stop.
> make: *** [all] Error 2
> 
> -Andi
