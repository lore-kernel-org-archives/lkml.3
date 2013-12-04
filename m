Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933132Ab3LDSxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 13:53:15 -0500
Received: from mail-yh0-f49.google.com ([209.85.213.49]:62858 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932971Ab3LDSxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 13:53:10 -0500
Date: Wed, 4 Dec 2013 15:53:02 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 28/28] perf tools: Add udis86 disassembler feature check
Message-ID: <20131204185302.GD14788@ghostprotocols.net>
References: <1386076182-14484-1-git-send-email-jolsa@redhat.com>
 <1386076182-14484-29-git-send-email-jolsa@redhat.com>
 <20131204185024.GC14788@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131204185024.GC14788@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Dec 04, 2013 at 03:50:24PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Tue, Dec 03, 2013 at 02:09:42PM +0100, Jiri Olsa escreveu:
> > Adding udis86 disassembler feature check which support
> > is needed for kvm:kvm_emulate_insn tracepoint.

> > +$(call feature_check,udis86)
> > +ifeq ($(feature-udis86), 1)
> > +  LIBTRACEEVENT_CFLAGS += -DHAVE_UDIS86
> > +  EXTLIBS += -ludis86
> > +else
> > +  msg := $(warning No udis86 support.);
> > +endif
 
> That is really an incomplete message, what package should I install?
> Perhaps we should add this there then:
 
> http://bit.ly/1hyrN52
 
> Wow, that was easy, but yeah, could be made easier 8-) ;-P

Jokes aside, I'm dropping this one for now, as it breaks feature
detection, now everytime I run make I get:

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
...            stackprotector-all: [ on  ]
...                       timerfd: [ on  ]

config/Makefile:421: No udis86 support.

---

Please try to fix it and resubmit. And yes, I don't have udis86-devel
installed in this test system.

- Arnaldo
