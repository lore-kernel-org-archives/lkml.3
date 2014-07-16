Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758996AbaGPLsD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 07:48:03 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:62185 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244AbaGPLr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 07:47:59 -0400
Date: Wed, 16 Jul 2014 13:47:48 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/16] perf/cor improvements and fixes
Message-ID: <20140716114748.GA28434@gmail.com>
References: <1404846184-20075-1-git-send-email-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404846184-20075-1-git-send-email-acme@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@kernel.org> wrote:

> Hi Ingo,
> 
> 	Please consider pulling,
> 
> - Arnaldo
> 
> The following changes since commit 8b5b584daf3b92fc5cdc83919e64231817d2f5a7:
> 
>   Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf into perf/core (2014-07-05 11:29:32 +0200)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-core-for-mingo
> 
> for you to fetch changes up to 4414a3c51028aea2ae2fe06c0377490eaa6abbfd:
> 
>   perf trace: Fix build on 32-bit systems (2014-07-08 15:39:21 -0300)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes
> 
> User visible:
> 
> o Prep patches to support 'perf kvm stat' on s390 (Alexander Yarygin)
> 
> o Add pagefault statistics in 'trace' (Stanislav Fomichev)
> 
> o Add header for columns in 'top' and 'report' TUI browsers (Jiri Olsa)
> 
> o Add pagefault statistics in 'trace' (Stanislav Fomichev)
> 
> Build fixes:
> 
> Fix build on 32-bit systems (Arnaldo Carvalho de Melo)
> 
> Cleanups:
> 
> o Convert open coded equivalents to asprintf() (Andy Shevchenko)
> 
> Plumbing:
> 
> o Allow reserving a row for header purposes in the hists browser (Arnaldo Carvalho de Melo)
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Alexander Yarygin (4):
>       perf kvm: Introduce HAVE_KVM_STAT_SUPPORT flag
>       perf kvm: Simplify exit reasons tables definitions
>       perf kvm: Refactoring of cpu_isa_config()
>       perf tools: Allow to use cpuinfo on s390
> 
> Andy Shevchenko (1):
>       perf tools: Convert open coded equivalents to asprintf()
> 
> Arnaldo Carvalho de Melo (8):
>       perf ui browser: Add ->rows to disambiguate from ->height
>       perf ui browser: Allow overriding refresh_dimensions method
>       perf hists browser: Introduce gotorc method
>       perf hists browser: Override ui_browser refresh_dimensions method
>       perf hists browser: Add support for showing columns header
>       perf hists browser: Left justify column headers
>       perf tools: Suggest using -f to override perf.data file ownership message
>       perf trace: Fix build on 32-bit systems
> 
> Jiri Olsa (2):
>       perf hists browser: Display columns header text on 'H' press
>       perf hists browser: Add ui.show-headers config file option
> 
> Stanislav Fomichev (1):
>       perf trace: Add pagefault statistics
> 
>  tools/perf/arch/s390/Makefile      |   1 +
>  tools/perf/arch/s390/util/header.c |  28 ++++++++
>  tools/perf/arch/x86/Makefile       |   1 +
>  tools/perf/builtin-kvm.c           |  72 +++++++++++----------
>  tools/perf/builtin-trace.c         |  23 ++++++-
>  tools/perf/config/Makefile         |   4 ++
>  tools/perf/perf-sys.h              |   1 +
>  tools/perf/ui/browser.c            |  37 ++++++-----
>  tools/perf/ui/browser.h            |   3 +-
>  tools/perf/ui/browsers/hists.c     | 128 ++++++++++++++++++++++++++++++++-----
>  tools/perf/util/config.c           |  13 ++++
>  tools/perf/util/data.c             |   2 +-
>  tools/perf/util/sort.c             |   2 +-
>  tools/perf/util/symbol.c           |   1 +
>  tools/perf/util/symbol.h           |   3 +-
>  tools/perf/util/trace-event-info.c |  12 +---
>  tools/perf/util/util.c             |   9 +--
>  17 files changed, 249 insertions(+), 91 deletions(-)
>  create mode 100644 tools/perf/arch/s390/util/header.c

Pulled, thanks a lot Arnaldo!

	Ingo
