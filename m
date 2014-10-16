Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751130AbaJPFSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 01:18:16 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:46663 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaJPFSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 01:18:14 -0400
Date: Thu, 16 Oct 2014 07:18:07 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Arun Sharma <asharma@fb.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cody P Schafer <dev@codyps.com>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Haren Myneni <hbabu@us.ibm.com>, Jean Pihet <jean.pihet@linaro.org>,
        Jiri Olsa <jolsa@redhat.com>, Kan Liang <kan.liang@intel.com>,
        linuxppc-dev@lists.ozlabs.org, Masanari Iida <standby24x7@gmail.com>,
        Michael Ellerman <michaele@au1.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Taeung Song <treeze.taeung@gmail.com>,
        Yasser Shalabi <yassershalabi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/15] perf/core improvements and fixes
Message-ID: <20141016051807.GA14796@gmail.com>
References: <1413406368-26245-1-git-send-email-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413406368-26245-1-git-send-email-acme@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@kernel.org> wrote:

> Hi Ingo,
> 
> 	Please consider pulling, I guess the changes are minor of affect just some
> non-core feature, so it is you call if you prefer to pull it into perf/urgent instead.
> 
> Best Regards,
> 
> - Arnaldo
> 
> The following changes since commit ec4212d88a77eb6caec10777ddd629b702a5ebbd:
> 
>   Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent (2014-10-15 11:54:14 +0200)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-core-for-mingo
> 
> for you to fetch changes up to 673d659f5c5918b7ddbafebf1f129c9eb82973b4:
> 
>   perf kvm stat live: Enable events copying (2014-10-15 17:39:03 -0300)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes:
> 
> User visible:
> 
> * Add a visual cue for toggle zeroing of samples in 'perf top' (Taeung Song)
> 
> * Fix for double free in 'perf stat' when using some specific invalid
>   command line combo (Yasser Shalabi)
> 
> Infrastructure:
> 
> * Add option to copy events when queuing for sorting across cpu buffers
>   and enable it for 'perf kvm stat live', to avoid having events left
>   in the queue pointing to the ring buffer be rewritten in high volume
>   sessions.  (Alexander Yarygin, improving work done by David Ahern):
> 
> * Document sysfs events/ interfaces (Cody P Schafer)
> 
> * Add support to new style format of kernel PMU event. (Kan Liang)
> 
> * Fix typos in perf/Documentation (Masanari Iida)
> 
> * Improve callchains when using libunwind (Namhyung Kim)
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
>   Lines starting with '#' will be ignored.
> 
> ----------------------------------------------------------------
> Alexander Yarygin (2):
>       perf session: Add option to copy events when queueing
>       perf kvm stat live: Enable events copying
> 
> Cody P Schafer (2):
>       perf Documentation: sysfs events/ interfaces
>       perf Documentation: Remove Ruplicated docs for powerpc cpu specific events
> 
> Kan Liang (4):
>       Revert "perf tools: Default to cpu// for events v5"
>       perf tools: Parse the pmu event prefix and suffix
>       perf tools: Add support to new style format of kernel PMU event
>       perf test: Add test case for pmu event new style format
> 
> Masanari Iida (1):
>       perf Documentation: Fix typos in perf/Documentation
> 
> Namhyung Kim (4):
>       perf report: Set callchain_param.record_mode for future use
>       perf callchain: Create an address space per thread
>       perf kvm: Use thread_{,_set}_priv helpers
>       perf trace: Use thread_{,_set}_priv helpers
> 
> Taeung Song (1):
>       perf top: Add a visual cue for toggle zeroing of samples
> 
> Yasser Shalabi (1):
>       perf evlist: Fix for double free in tools/perf stat
> 
>  .../testing/sysfs-bus-event_source-devices-events  | 611 ++-------------------
>  tools/perf/Documentation/perf-diff.txt             |   6 +-
>  tools/perf/Documentation/perf-kvm.txt              |   4 +-
>  tools/perf/Documentation/perf-list.txt             |   2 +-
>  tools/perf/Documentation/perf-record.txt           |   2 +-
>  tools/perf/Documentation/perf-script-perl.txt      |   4 +-
>  tools/perf/Documentation/perf-script-python.txt    |   6 +-
>  tools/perf/Documentation/perf-script.txt           |   2 +-
>  tools/perf/Documentation/perf-test.txt             |   2 +-
>  tools/perf/Documentation/perf-trace.txt            |   2 +-
>  tools/perf/builtin-kvm.c                           |   7 +-
>  tools/perf/builtin-report.c                        |   7 +
>  tools/perf/builtin-trace.c                         |  16 +-
>  tools/perf/tests/dwarf-unwind.c                    |   3 +
>  tools/perf/tests/parse-events.c                    |  36 ++
>  tools/perf/ui/browsers/hists.c                     |  32 +-
>  tools/perf/util/evlist.c                           |   1 +
>  tools/perf/util/include/linux/string.h             |   1 -
>  tools/perf/util/ordered-events.c                   |  49 +-
>  tools/perf/util/ordered-events.h                   |  10 +-
>  tools/perf/util/parse-events.c                     | 133 ++++-
>  tools/perf/util/parse-events.h                     |  14 +
>  tools/perf/util/parse-events.l                     |  30 +-
>  tools/perf/util/parse-events.y                     |  40 ++
>  tools/perf/util/pmu.c                              |  10 -
>  tools/perf/util/pmu.h                              |  10 +
>  tools/perf/util/session.c                          |   5 +-
>  tools/perf/util/string.c                           |  24 -
>  tools/perf/util/thread.c                           |   6 +
>  tools/perf/util/unwind-libunwind.c                 |  37 +-
>  tools/perf/util/unwind.h                           |  17 +
>  31 files changed, 460 insertions(+), 669 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
