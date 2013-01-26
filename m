Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab3AZR2i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 12:28:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059Ab3AZR2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 12:28:21 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 0/9] perf: Adding better precise_ip field handling
Date: Sat, 26 Jan 2013 18:27:46 +0100
Message-Id: <1359221275-24254-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
adding sysfs attribute to specify the maximum allowed value
for perf_event_attr::precise_ip field.

Adding functionality for simple 'precise' term to get the
maximum allowed value for perf_event_attr::precise_ip field.

And finally adding several precise automated tests.

thanks,
jirka

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>


---
Andi Kleen (1):
      perf tools: Add a precise event qualifier

Jiri Olsa (8):
      perf x86: Add precise sysfs cpu pmu attribute
      perf tools: Add precise object to interface sysfs precise
      perf tests: Add precise event automated test
      perf tools: Read maximal precise value for 'precise' term
      perf tools: Favor 'p' modifier before 'precise' term properly
      perf tests: Add automated precise term test
      perf: Document the ABI for 'precise' sysfs attribute
      perf: Document the ABI for 'rdpmc' sysfs attribute

 Documentation/ABI/testing/sysfs-bus-event_source-cpu-precise | 10 ++++++++++
 Documentation/ABI/testing/sysfs-bus-event_source-cpu-rdpmc   |  8 ++++++++
 arch/x86/kernel/cpu/perf_event.c                             | 34 +++++++++++++++++++++++---------
 tools/perf/Makefile                                          |  2 ++
 tools/perf/tests/builtin-test.c                              |  4 ++++
 tools/perf/tests/parse-events.c                              | 75 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/precise.c                                   | 52 +++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h                                     |  1 +
 tools/perf/util/parse-events.c                               | 38 +++++++++++++++++++++++++++++++++++-
 tools/perf/util/parse-events.h                               |  3 +++
 tools/perf/util/parse-events.l                               |  1 +
 tools/perf/util/parse-events.y                               |  2 +-
 tools/perf/util/precise.c                                    | 45 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/util.h                                       |  2 ++
 14 files changed, 266 insertions(+), 11 deletions(-)
