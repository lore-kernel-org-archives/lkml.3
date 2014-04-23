Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990AbaDWNtm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:49:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536AbaDWNta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:49:30 -0400
Date: Wed, 23 Apr 2014 15:49:10 +0200
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
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL 0/4] perf/urgent fixes
Message-ID: <20140423134910.GD11124@krava.brq.redhat.com>
References: <1398252682-17185-1-git-send-email-jolsa@redhat.com>
 <20140423131433.GB23224@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140423131433.GB23224@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 03:14:33PM +0200, Ingo Molnar wrote:
> 
> (Just reporting two bugs I found today - unrelated to your the 
> perf/urgent pull request.)
> 
> 1)
> 
> Even when the most modern unwind library is found, the autodetection 
> is spammy:
> 
> 
>  Auto-detecting system features:
>  ...                         dwarf: [ on  ]
>  ...                         glibc: [ on  ]
>  ...                          gtk2: [ on  ]
>  ...                      libaudit: [ on  ]
>  ...                        libbfd: [ on  ]
>  ...                        libelf: [ on  ]
>  ...                       libnuma: [ on  ]
>  ...                       libperl: [ on  ]
>  ...                     libpython: [ on  ]
>  ...                      libslang: [ on  ]
>  ...                     libunwind: [ on  ]
>  ...            libdw-dwarf-unwind: [ on  ]
>  ...     DWARF post unwind library: libunwind
> 
> The 'DWARF post unwind library' line is somewhat superfluous. I 
> realize that it prints out the library selected - but that's obvious 
> from the 'libdw-dwarf-unwind' line above it already, right?

nope, the on/off output is only whats detected in system,
you've got both libunwind and libdw-dwarf-unwind detected

libunwind is default unless you use NO_LIBUNWIND=1

> 
> Furthermore, it breaks the autodetection output format.

we could move it to the 'make VF=1' output ;-) like:

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
...            libdw-dwarf-unwind: [ on  ]
...                     backtrace: [ on  ]
...                fortify-source: [ on  ]
...                  gtk2-infobar: [ on  ]
...             libelf-getphdrnum: [ on  ]
...                   libelf-mmap: [ on  ]
...             libpython-version: [ on  ]
...                       on-exit: [ on  ]
...            stackprotector-all: [ on  ]
...                       timerfd: [ on  ]
...         libunwind-debug-frame: [ OFF ]
...                        bionic: [ OFF ]

...                        prefix: /home/jolsa
...                        bindir: /home/jolsa/bin
...                        libdir: /home/jolsa/lib64
...                    sysconfdir: /home/jolsa/etc
...                 LIBUNWIND_DIR: 
...                     LIBDW_DIR: 

...     DWARF post unwind library: libunwind


jirka
