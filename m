Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967876Ab3HIN6X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 09:58:23 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:38820 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab3HIN6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 09:58:21 -0400
MIME-Version: 1.0
In-Reply-To: <5204F5D9.2070703@intel.com>
References: <1376045519-13832-1-git-send-email-adrian.hunter@intel.com>
	<CABPqkBSia0kzALAeFKVZ--zC13e=L5UZExP=oTTBuKQxXUAqkA@mail.gmail.com>
	<5204F5D9.2070703@intel.com>
Date: Fri, 9 Aug 2013 15:58:20 +0200
Message-ID: <CABPqkBRp8L=3vM0CjDLOXt0EKHKzSuDbjLQm8pWJC+vVqgbGjw@mail.gmail.com>
Subject: Re: [PATCH V10 00/13] perf tools: some fixes and tweaks
From: Stephane Eranian <eranian@google.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 9, 2013 at 3:59 PM, Adrian Hunter <adrian.hunter@intel.com> wrote:
> On 09/08/13 16:41, Stephane Eranian wrote:
>> Adrian,
>>
>> Is there a git tree where I could pull those patches from?
>
> I plonked it down here for you:
>
>         http://git.infradead.org/users/ahunter/linux-perf.git
>
fatal: http://git.infradead.org/users/ahunter/linux-perf.git/info/refs
not found: did you run git update-server-info on the server?

>> That would avoid me pulling them down from my gmail
>> inbox one by one.
>>
>> I am interested in the PERF_SAMPLE_IDENTIFIER support.
>> And I want to test it.
>>
>> Thanks.
>>
>>
>> On Fri, Aug 9, 2013 at 12:51 PM, Adrian Hunter <adrian.hunter@intel.com> wrote:
>>> Hi
>>>
>>> Here are some fixes and tweaks to perf tools (version 10).
>>>
>>> Changes in V10:
>>>         Re-based on:
>>>                 perf/core branch of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git
>>>                 commit 207353be1574027c151609a31167ac5919a056c8: perf tools: Remove filter parameter of thread__find_addr_map()
>>>
>>>         perf tools: add debug prints
>>>                 Changed to use macros
>>>         perf tools: add pid to struct thread
>>>                 Added David's Ack
>>>         perf tools: change machine__findnew_thread() to set thread pid
>>>                 Added David's Ack
>>>         perf tools: remove references to struct ip_event
>>>                 Also remove from hists_link.c
>>>         perf tools: move struct ip_event
>>>                 Dropped since it is covered by "perf tools: remove references to struct ip_event"
>>>         perf tools: add a sample parsing test
>>>                 Fix missing sample comparison for PERF_SAMPLE_READ
>>>
>>> Changes in V9:
>>>         perf: Update perf_event_type documentation
>>>                 Dropped since its been applied
>>>         perf tools: tidy up sample parsing overflow checking
>>>                 Changed to use a single overflow function
>>>                 Updated for PERF_SAMPLE_READ
>>>         perf: make events stream always parsable
>>>                 Added more about sample parsing to the commit message
>>>         perf tools: add support for PERF_SAMPLE_IDENTFIER
>>>                 When selecting PERF_SAMPLE_IDENTFIER, ensure PERF_SAMPLE_ID
>>>                 is deselected
>>>         perf tools: expand perf_event__synthesize_sample()
>>>                 Updated for PERF_SAMPLE_READ
>>>         perf tools: add a function to calculate sample event size
>>>                 Updated for PERF_SAMPLE_READ
>>>         perf tools: add a sample parsing test
>>>                 Updated for PERF_SAMPLE_READ
>>>
>>> Changes in V8:
>>>         perf tools: add debug prints
>>>                 Fixed Python link errors
>>>         perf tools: move perf_evlist__config() to a new source file
>>>                 New Patch to avoid Python link errors
>>>         perf tools: add support for PERF_SAMPLE_IDENTFIER
>>>                 Adjustments due to patch above
>>>
>>> Changes in V7:
>>>         perf: Update perf_event_type documentation
>>>                 Proposed new patch from Peter Zijlstra
>>>         perf: make events stream always parsable
>>>                 Adjustments due to patch above
>>>         perf tools: tidy up sample parsing overflow checking
>>>                 Change to a single overflow function
>>>                 Amend comment
>>>         perf tools: add a function to calculate sample event size
>>>                 New patch
>>>         perf tools: add a sample parsing test
>>>                 Amended to use sample event size calculation
>>>
>>> Changes in V6:
>>>         Some checkpatch fixes
>>>
>>>         perf: make events stream always parsable
>>>                 Add sample format comments
>>>
>>> Changes in V5:
>>>         Re-based to Arnaldo's tree and dropped already applied patches:
>>>                 perf tools: remove unused parameter
>>>                 perf tools: fix missing tool parameter
>>>                 perf tools: fix missing 'finished_round'
>>>                 perf tools: fix parse_events_terms() segfault on error path
>>>                 perf tools: fix new_term() missing free on error path
>>>                 perf tools: add const specifier to perf_pmu__find name parameter
>>>                 perf tools: tidy duplicated munmap code
>>>                 perf tools: validate perf event header size
>>>
>>>         perf tools: add debug prints
>>>                 Changed to perf_event_attr__fprintf()
>>>         perf tools: add pid to struct thread
>>>                 Always set the pid, even if a pid is already set
>>>         perf tools: change machine__findnew_thread() to set thread pid
>>>                 Replaces: perf tools: change "machine" functions to set thread pid
>>>         perf tools: add support for PERF_SAMPLE_IDENTFIER
>>>                 Only use PERF_SAMPLE_IDENTFIER if sample types are different
>>>         perf tools: expand perf_event__synthesize_sample()
>>>                 New patch in preparation of a sample parsing test
>>>         perf tools: add a sample parsing test
>>>                 New patch
>>>
>>> Changes in V4:
>>>         I added kernel support for matching sample types via
>>>         PERF_SAMPLE_IDENTIFIER.  perf tools support for that required
>>>         first fixing some other things.
>>>
>>>         perf tools: fix parse_events_terms() freeing local variable on error path
>>>                 Dropped - covered by David Ahern
>>>         perf tools: struct thread has a tid not a pid
>>>                 Added ack by David Ahern
>>>         perf tools: add pid to struct thread
>>>                 Remove unused function
>>>         perf tools: fix missing increment in sample parsing
>>>                 New patch
>>>         perf tools: tidy up sample parsing overflow checking
>>>                 New patch
>>>         perf tools: remove unnecessary callchain validation
>>>                 New patch
>>>         perf tools: remove references to struct ip_event
>>>                 New patch
>>>         perf tools: move struct ip_event
>>>                 New patch
>>>         perf: make events stream always parsable
>>>                 New patch
>>>         perf tools: add support for PERF_SAMPLE_IDENTFIER
>>>                 New patch
>>>
>>> Changes in V3:
>>>         perf tools: add pid to struct thread
>>>                 Split into 2 patches
>>>         perf tools: fix ppid in thread__fork()
>>>                 Dropped for now
>>>
>>> Changes in V2:
>>>         perf tools: fix missing tool parameter
>>>                 Fixed one extra occurrence
>>>         perf tools: fix parse_events_terms() freeing local variable on error path
>>>                 Made "freeing" code into a new function
>>>         perf tools: validate perf event header size
>>>                 Corrected byte-swapping
>>>         perf tools: allow non-matching sample types
>>>                 Added comments
>>>                 Fixed id_pos calculation
>>>                 id_pos/is_pos updated whenever sample_type changes
>>>                 Removed perf_evlist__sample_type()
>>>                 Added __perf_evlist__combined_sample_type()
>>>                 Added perf_evlist__combined_sample_type()
>>>                 Added perf_evlist__make_sample_types_compatible()
>>>         Added ack's to patches acked by Jiri Olsa
>>>
>>>
>>> Adrian Hunter (13):
>>>       perf tools: add debug prints
>>>       perf tools: allow non-matching sample types
>>>       perf tools: add pid to struct thread
>>>       perf tools: change machine__findnew_thread() to set thread pid
>>>       perf tools: tidy up sample parsing overflow checking
>>>       perf tools: remove unnecessary callchain validation
>>>       perf tools: remove references to struct ip_event
>>>       perf: make events stream always parsable
>>>       perf tools: move perf_evlist__config() to a new source file
>>>       perf tools: add support for PERF_SAMPLE_IDENTFIER
>>>       perf tools: expand perf_event__synthesize_sample()
>>>       perf tools: add a function to calculate sample event size
>>>       perf tools: add a sample parsing test
>>>
>>>  include/uapi/linux/perf_event.h   |  27 ++-
>>>  kernel/events/core.c              |  11 +-
>>>  tools/perf/Makefile               |   2 +
>>>  tools/perf/builtin-inject.c       |   8 +-
>>>  tools/perf/builtin-kmem.c         |   3 +-
>>>  tools/perf/builtin-kvm.c          |   2 +-
>>>  tools/perf/builtin-lock.c         |   3 +-
>>>  tools/perf/builtin-mem.c          |   2 +-
>>>  tools/perf/builtin-report.c       |   2 +-
>>>  tools/perf/builtin-sched.c        |  20 +-
>>>  tools/perf/builtin-script.c       |   3 +-
>>>  tools/perf/builtin-top.c          |  11 +-
>>>  tools/perf/builtin-trace.c        |  12 +-
>>>  tools/perf/tests/builtin-test.c   |   4 +
>>>  tools/perf/tests/code-reading.c   |   4 +-
>>>  tools/perf/tests/hists_link.c     |  23 +-
>>>  tools/perf/tests/mmap-basic.c     |   2 +-
>>>  tools/perf/tests/sample-parsing.c | 313 +++++++++++++++++++++++++
>>>  tools/perf/tests/tests.h          |   1 +
>>>  tools/perf/util/build-id.c        |  11 +-
>>>  tools/perf/util/callchain.c       |   8 -
>>>  tools/perf/util/callchain.h       |   5 -
>>>  tools/perf/util/event.c           |   5 +-
>>>  tools/perf/util/event.h           |  33 ++-
>>>  tools/perf/util/evlist.c          | 146 ++++++++++--
>>>  tools/perf/util/evlist.h          |  10 +-
>>>  tools/perf/util/evsel.c           | 471 ++++++++++++++++++++++++++++++++++----
>>>  tools/perf/util/evsel.h           |  13 +-
>>>  tools/perf/util/machine.c         |  37 ++-
>>>  tools/perf/util/machine.h         |   3 +-
>>>  tools/perf/util/python.c          |  20 ++
>>>  tools/perf/util/record.c          | 111 +++++++++
>>>  tools/perf/util/session.c         |  32 +--
>>>  tools/perf/util/thread.c          |   3 +-
>>>  tools/perf/util/thread.h          |   3 +-
>>>  35 files changed, 1174 insertions(+), 190 deletions(-)
>>>  create mode 100644 tools/perf/tests/sample-parsing.c
>>>  create mode 100644 tools/perf/util/record.c
>>>
>>>
>>> Regards
>>> Adrian
>>
>>
>
