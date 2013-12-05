Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933574Ab3LERrm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:47:42 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55311 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933421Ab3LERrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:47:40 -0500
Date: Thu, 5 Dec 2013 14:47:25 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Pekka Enberg <penberg@kernel.org>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 0/2] perf tool: Carve out fs.* stuff
Message-ID: <20131205174725.GF10333@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386260752-16436-1-git-send-email-bp@alien8.de>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, some editing problem happened here... Now with proper subject
line.

- Arnaldo

Em Thu, Dec 05, 2013 at 05:25:50PM +0100, Borislav Petkov escreveu:
> From: Borislav Petkov <bp@suse.de>
> 
> Ok,
> 
> step one: carve out fs-related stuff into a libapikfs.a library.

Adding some more people to the CC list, but from a quick look, this
is in line with what we discussed so far, so I'm ok with it.

For those people in the CC list, Acked-by would be really, really
appreciated.

- Arnaldo
 
> Borislav Petkov (2):
>   tools/: Convert to new topic libraries
>   perf: Move fs.* to lib/api/fs/
> 
>  tools/Makefile                                     | 12 ++++----
>  tools/lib/{lk => api}/Makefile                     |  8 ++++--
>  tools/lib/{lk => api/fs}/debugfs.c                 |  0
>  tools/lib/{lk => api/fs}/debugfs.h                 |  6 ++--
>  tools/{perf/util => lib/api/fs}/fs.c               | 11 ++++++--
>  .../util/include/linux/magic.h => lib/api/fs/fs.h} | 12 ++++----
>  tools/perf/Makefile.perf                           | 33 ++++++++++------------
>  tools/perf/builtin-kvm.c                           |  2 +-
>  tools/perf/builtin-probe.c                         |  2 +-
>  tools/perf/perf.c                                  |  2 +-
>  tools/perf/tests/parse-events.c                    |  4 +--
>  tools/perf/util/cpumap.c                           |  2 +-
>  tools/perf/util/evlist.c                           |  2 +-
>  tools/perf/util/evsel.c                            |  2 +-
>  tools/perf/util/fs.h                               |  7 -----
>  tools/perf/util/parse-events.c                     |  2 +-
>  tools/perf/util/pmu.c                              |  2 +-
>  tools/perf/util/probe-event.c                      |  2 +-
>  tools/perf/util/python-ext-sources                 |  2 +-
>  tools/perf/util/record.c                           |  2 +-
>  tools/perf/util/setup.py                           |  4 +--
>  tools/perf/util/trace-event-info.c                 |  2 +-
>  tools/perf/util/util.h                             |  2 +-
>  tools/vm/Makefile                                  | 14 ++++-----
>  tools/vm/page-types.c                              |  2 +-
>  25 files changed, 67 insertions(+), 72 deletions(-)
>  rename tools/lib/{lk => api}/Makefile (85%)
>  rename tools/lib/{lk => api/fs}/debugfs.c (100%)
>  rename tools/lib/{lk => api/fs}/debugfs.h (86%)
>  rename tools/{perf/util => lib/api/fs}/fs.c (91%)
>  rename tools/{perf/util/include/linux/magic.h => lib/api/fs/fs.h} (50%)
>  delete mode 100644 tools/perf/util/fs.h
> 
> -- 
> 1.8.4
