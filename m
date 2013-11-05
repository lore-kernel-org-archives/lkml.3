Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab3KEHwe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 02:52:34 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:39088 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab3KEHwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 02:52:32 -0500
Date: Tue, 5 Nov 2013 08:52:28 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Howard Cochran <hcochran@lexmark.com>, Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Xenia Ragiadakou <burzalodowa@gmail.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/29] perf/core improvements and fixes
Message-ID: <20131105075228.GA8271@gmail.com>
References: <1383587947-17419-1-git-send-email-acme@infradead.org>
 <20131104201613.GA19839@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131104201613.GA19839@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hm, probably one of these commits:

8a0c4c2843d3 perf tools: Fix libunwind build and feature detection for 32-bit build
28e962b9d79f perf tools: Fix 32-bit cross build
74af377bc25d perf tools: Fix non-debug build
9402802a416c perf tools: Fix test_on_exit for 32-bit build

broke the suppression of the auto-detection messages on repeat invocations 
of 'make', if all testcases pass.

'make' used to display this on repeat invocations:

 comet:~/tip/tools/perf> make
   BUILD:   Doing 'make -j12' parallel build
 comet:~/tip/tools/perf> make
   BUILD:   Doing 'make -j12' parallel build
 comet:~/tip/tools/perf> make
   BUILD:   Doing 'make -j12' parallel build

Now it displays the spammy auto-detection all the time:

comet:~/tip/tools/perf> make
  BUILD:   Doing 'make -j12' parallel build

Auto-detecting system features:
...                     backtrace: [ on  ]
...                         dwarf: [ on  ]
...                fortify-source: [ on  ]
...                         glibc: [ on  ]
...                          gtk2: [ on  ]
...                  gtk2-infobar: [ on  ]
...                      libaudit: [ on  ]
...                        libbfd: [ on  ]
...                        libelf: [ on  ]
...             libelf-getphdrnum: [ on  ]
...                   libelf-mmap: [ on  ]
...                       libnuma: [ on  ]
...                       libperl: [ on  ]
...                     libpython: [ on  ]
...             libpython-version: [ on  ]
...                      libslang: [ on  ]
...                     libunwind: [ on  ]
...                       on-exit: [ on  ]
...                stackprotector: [ on  ]
...            stackprotector-all: [ on  ]

maybe a new testcase fails on my box, but is not properly displayed?

Thanks,

	Ingo
