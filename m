Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbaDXLnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:43:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717AbaDXLnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 07:43:46 -0400
Date: Thu, 24 Apr 2014 13:43:26 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Masanari Iida <standby24x7@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [GIT PULL 0/4] perf/urgent fixes
Message-ID: <20140424114326.GD1110@krava.brq.redhat.com>
References: <1398252682-17185-1-git-send-email-jolsa@redhat.com>
 <20140423131433.GB23224@gmail.com>
 <20140423145325.GB27585@krava.brq.redhat.com>
 <20140424064718.GD1104@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140424064718.GD1104@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 08:47:18AM +0200, Ingo Molnar wrote:

SNIP

> 
> In any case, your patch fixes the bug. With VF=1 I get this output:
> 
> Auto-detecting system features:
> ...                         dwarf: [ on  ]
> ...                         glibc: [ on  ]
> ...                          gtk2: [ on  ]
> ...                      libaudit: [ on  ]
> ...                        libbfd: [ on  ]
> ...                        libelf: [ on  ]
> ...                       libnuma: [ on  ]
> ...                       libperl: [ on  ]
> ...                     libpython: [ on  ]
> ...                      libslang: [ on  ]
> ...                     libunwind: [ on  ]
> ...            libdw-dwarf-unwind: [ on  ]
> ...     DWARF post unwind library: libunwind
> ...                     backtrace: [ on  ]
> ...                fortify-source: [ on  ]
> ...                  gtk2-infobar: [ on  ]
> ...             libelf-getphdrnum: [ on  ]
> ...                   libelf-mmap: [ on  ]
> ...             libpython-version: [ on  ]
> ...                       on-exit: [ on  ]
> ...            stackprotector-all: [ on  ]
> ...                       timerfd: [ on  ]
> ...         libunwind-debug-frame: [ OFF ]
> ...                        bionic: [ OFF ]
> ...                       liberty: [ OFF ]
> ...                     liberty-z: [ OFF ]
> ...                cplus-demangle: [ OFF ]
> 
> So yes, your obervation that it's the -liberty +libbfd combination is 
> correct.
> 
> Tested-by: Ingo Molnar <mingo@kernel.org>
> 
> Btw., when reading the patch and the Makefile it was not obvious to me 
> what 'VF' stood for. It's pretty clear what CORE_FEATURE_TESTS and 

VF - Verbose for Features ;-)

> LIB_FEATURE_TESTS means, but there's no comment for VF_FEATURE_TESTS 
> and the name is not self-explanatory.
> 
> I figured it out from a bit of git log digging that its purpose is to 
> generate the 'verbose feature check' output. But the variable is not 
> commented and the features it lists overlaps CORE_FEATURE_TESTS and 
> LIB_FEATURE_TESTS - so perhaps a bit more explanation (and possible 
> reduction in duplication) might be useful?
> 
> If it said ALL_FEATURE_TESTS and used $(CORE_FEATURE_TESTS) as a 
> baseline then that would be self-explanatory.
> 
> (In a separate patch from the fix.)

ok, will add something along those lines ;-)

thanks,
jirka
