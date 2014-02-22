Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbaBVQeq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 11:34:46 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:64675 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbaBVQeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 11:34:44 -0500
Date: Sat, 22 Feb 2014 17:34:40 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>, Jean Pihet <jean.pihet@linaro.org>
Subject: Re: [PATCH 1/6] perf tools: Factor features display code
Message-ID: <20140222163439.GC24048@gmail.com>
References: <1392825179-5228-1-git-send-email-jolsa@redhat.com>
 <1392825179-5228-2-git-send-email-jolsa@redhat.com>
 <20140219215936.GA5982@ghostprotocols.net>
 <20140220083020.GA2725@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140220083020.GA2725@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> On Wed, Feb 19, 2014 at 06:59:36PM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Wed, Feb 19, 2014 at 04:52:54PM +0100, Jiri Olsa escreveu:
> > > Currently the we display all detected features/libraries
> > > by following rules:
> > >  - if one of the features is missing
> > >  - if it's build from clean tree
> > > 
> > > This patch changes changes this behavior in several ways.
> > > 
> > > - We no longer display all detected features, only detected
> > >   libraries are displayed by default:
> > > 
> > >   $ make
> > >     BUILD:   Doing 'make -j4' parallel build
> > > 
> > >   Auto-detecting system features:
> > >   ...                         dwarf: [ on  ]
> > >   ...                         glibc: [ on  ]
> > >   ...                          gtk2: [ on  ]
> > >   ...                      libaudit: [ on  ]
> > >   ...                        libbfd: [ on  ]
> > >   ...                        libelf: [ on  ]
> > >   ...                       libnuma: [ on  ]
> > >   ...                       libperl: [ on  ]
> > >   ...                     libpython: [ on  ]
> > >   ...                      libslang: [ on  ]
> > >   ...                     libunwind: [ on  ]
> > 
> > I like it, testing now, one suggestion: Since this is just about
> > libraries, ditch the "lib' prefix, and make the header more
> > informative, making it look like this:
> > 
> >    Auto-detecting system libraries that enables features:
> >    ...                         dwarf: [ on  ]
> >    ...                             c: [ on  ]
> >    ...                          gtk2: [ on  ]
> >    ...                         audit: [ on  ]
> >    ...                           bfd: [ on  ]
> >    ...                           elf: [ on  ]
> >    ...                          numa: [ on  ]
> >    ...                          perl: [ on  ]
> >    ...                        python: [ on  ]
> >    ...                         slang: [ on  ]
> >    ...                        unwind: [ on  ]
> 
> yep, we could prettify it somehow.. but those names are tightly
> bound to tests in config/feature-checks/Makefile .. so it'd
> mean bigger change ;-)

The naming is also generally related to the feature test and the 
component library being tested, so it could be misleading/confusing to 
strip it?

Thanks,

	Ingo
