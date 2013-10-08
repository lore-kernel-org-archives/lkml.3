Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab3JHIqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 04:46:18 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:50395 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab3JHIqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 04:46:14 -0400
Date: Tue, 8 Oct 2013 10:46:10 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 37/50] tools/perf/build: Improve printout-of
 auto-detected features
Message-ID: <20131008084610.GB3295@gmail.com>
References: <1381147003-2574-1-git-send-email-mingo@kernel.org>
 <1381147003-2574-38-git-send-email-mingo@kernel.org>
 <20131007221233.GF2900@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131007221233.GF2900@krava.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> On Mon, Oct 07, 2013 at 01:56:30PM +0200, Ingo Molnar wrote:
> 
> SNIP
> 
> > +#
> > +# Only print out our features if we rebuilt the testcases or if a test failed:
> > +#
> > +ifeq ($(test-all-failed), 1)
> > +  $(foreach feat,$(CORE_FEATURE_TESTS) DUMMY,$(call feature_print,$(feat)))
> > +  $(info )
> > +endif
> 
> found the DUMMY! what do I win? ;-)

:-)

So, this is a bit of a GNU Make mystery to me. If I have a failure for at 
least one of the features, and if I leave out that DUMMY then I get this 
printout:

...                       libperl: [ OFF ]
...                     libpython: [ on  ]
...             libpython-version: [ on  ]
...                      libslang: [ on  ]
...                     libunwind: [ on  ]
...                       on-exit: [ on  ]
...                stackprotector: [ on  ]
...            stackprotector-all: [ on  ]

    GEN python/perf.so

Note how the last entry is missing: volatile-register-var.

If I add the DUMMY I get the full printout:

...                       libperl: [ OFF ]
...                     libpython: [ on  ]
...             libpython-version: [ on  ]
...                      libslang: [ on  ]
...                     libunwind: [ on  ]
...                       on-exit: [ on  ]
...                stackprotector: [ on  ]
...            stackprotector-all: [ on  ]
...         volatile-register-var: [ on  ]

    GEN python/perf.so

Somehow GNU Make appears to be eating terminal ouput - or I might have 
misunderstood something.

I hope it's the latter - but if it's the former then the DUMMY entry is 
needed :-/

Thanks,

	Ingo
