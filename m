Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134Ab3K0Wn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 17:43:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755553Ab3K0Wn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 17:43:58 -0500
Date: Wed, 27 Nov 2013 23:43:24 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Jean Pihet <jean.pihet@linaro.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Will Deacon <will.deacon@arm.com>, linaro-kernel@lists.linaro.org,
        patches@linaro.org, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 34/34] perf tools unwinding: Use the per-feature check
 flags
Message-ID: <20131127224323.GB1350@krava.redhat.com>
References: <1385583394-3703-1-git-send-email-acme@infradead.org>
 <1385583394-3703-35-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385583394-3703-35-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 05:16:34PM -0300, Arnaldo Carvalho de Melo wrote:
> From: Jean Pihet <jean.pihet@linaro.org>
> 
> Use the per-feature check flags for the unwinding feature in order to
> correctly compile the libunwind and libunwind-debug-frame feature
> checks.
> 
> Tested on ARMv7 and ARMv8 with 'make DEBUG=1 LIBUNWIND_DIR=/usr/local -C
> tools/perf'

this one makes my build fail:

[jolsa@krava perf]$ make
  BUILD:   Doing 'make -j4' parallel build

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
...                     libunwind: [ OFF ]
...                       on-exit: [ on  ]
...                stackprotector: [ on  ]
...            stackprotector-all: [ on  ]
...                       timerfd: [ on  ]

config/Makefile:335: No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 1.1

...

  LINK     perf
/bin/ld: cannot find -lunwind
/bin/ld: cannot find -lunwind-x86_64
collect2: error: ld returned 1 exit status
make[1]: *** [perf] Error 1
make[1]: *** Waiting for unfinished jobs....
make: *** [all] Error 2


I haven't checked this one.. will do tomorrow

jirka
