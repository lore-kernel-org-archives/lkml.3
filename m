Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbaB0Mlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:41:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200AbaB0Mld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:41:33 -0500
Date: Thu, 27 Feb 2014 13:40:47 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/12] perf/core improvements and fixes
Message-ID: <20140227124047.GF9614@krava.brq.redhat.com>
References: <1393271800-17505-1-git-send-email-acme@infradead.org>
 <20140227114658.GA26449@gmail.com>
 <20140227120227.GC9614@krava.brq.redhat.com>
 <20140227123052.GA11475@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140227123052.GA11475@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 01:30:52PM +0100, Ingo Molnar wrote:
> 
> * Jiri Olsa <jolsa@redhat.com> wrote:
> 
> > On Thu, Feb 27, 2014 at 12:46:58PM +0100, Ingo Molnar wrote:
> > > 
> > > * Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
> > > 
> > > > From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> > > > 

SNIP

> > > Pulled, thanks a lot Arnaldo!
> > > 
> > > Btw., the build output looks weird now - on a system that used to pass 
> > > all feature tests there's this output:
> > > 
> > >   BUILD:   Doing 'make -j12' parallel build
> > > config/Makefile:288: No libdw DWARF unwind found, Please install 
> > > elfutils-devel/libdw-dev >= 0.158 and/or set LIBDW_DIR
> > > 
> > > Auto-detecting system features:
> > > ...                         dwarf: [ on  ]
> > > ...                         glibc: [ on  ]
> > > ...                          gtk2: [ on  ]
> > > ...                      libaudit: [ on  ]
> > > ...                        libbfd: [ on  ]
> > > ...                        libelf: [ on  ]
> > > ...                       libnuma: [ on  ]
> > > ...                       libperl: [ on  ]
> > > ...                     libpython: [ on  ]
> > > ...                      libslang: [ on  ]
> > > ...                     libunwind: [ on  ]
> > > ...            libdw-dwarf-unwind: [ OFF ]
> > > ...     DWARF post unwind library: libunwind
> > > 
> > > but:
> > > 
> > >    Package elfutils-devel-0.156-5.fc19.x86_64 already installed and latest version
> > > 
> > > Also, the information content of this line is unclear to me:
> > > 
> > > ...     DWARF post unwind library: libunwind
> > > 
> > > 
> > > what does that line want to tell?
> > 
> > this tells what DWARF unwind library is compiled
> > in.. 'libunwind' in this case
> 
> So my (stylistic) complaint is that it's really reading weird in a 
> table generated with the following purpose:
> 
>       Auto-detecting system features:
> 
> Also, we already know that libunwind is present, because just in the 
> line before it, it says:
> 
>     ...                     libunwind: [ on  ]
> 
> So it's doubly confusing. How about not displaying that line at all? 
> Is there a strong reason to not keep 'OFF' messages on a single line?

well, on/OFF lines are only about detecting libs

this line:
'DWARF post unwind library: libunwind'

is about telling which one goes in.. could be you have both
libraries detected and need to choose one or keep default

> 
> > the other choice is 'libdw', which was not detected in your case 
> > (and thats what the 1st message tells you)
> > 
> > we discussed with Arnaldo, that we would not display warnings for 
> > missing features by default.. only tell that there are missing 
> > features and display them for verbose (VF=1) output
> 
> That's probably a good plan. I'd suggest the following 'short log' for 
> failures:
> 
>      # Auto-detecting system features: 2 libraries are missing. Try 'make VF=1' for a verbose list.
> 
> I.e. that way people can notice if the count goes up or down after an 
> update. Also, that too should be a single line, so that it does not 
> spam people.

ook

jirka
