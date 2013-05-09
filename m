Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab3EINey (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 09:34:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753917Ab3EINcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 09:32:53 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 0/9] perf: Adding better precise_ip field handling
Date: Thu,  9 May 2013 15:32:15 +0200
Message-Id: <1368106344-23383-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
adding sysfs attribute to specify the maximum allowed value
for perf_event_attr::precise_ip field.

Adding functionality for simple 'p' modifier and 'precise' term
to get the maximum allowed value for perf_event_attr::precise_ip
field.

Following events:
  -e 'cycles:p'
  -e 'cpu/cycles,precise/'

get maximum allowed value for perf_event_attr::precise_ip field.

Following event:
  -e 'cycles:pp'
  -e 'cpu/cycles,precise=2/'

get perf_event_attr::precise_ip == 2.

If precise is disabled completely (sysfs precise == 0), we display
warning and continue with standard non-PEBS event.

If precise attribute is not supported '1' is used as current default.

Adding automated test to test precise event could be properly created
(if sysfs precise is supported).  And customizing parsing tests with
precise modifier.

Updating Documentation/ABI with 'precise' attribute and
also forgotten 'rdpmc' attribute.


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
Cc: Stephane Eranian <eranian@google.com>

---
Andi Kleen (1):
      perf tools: Add a precise event qualifier

Jiri Olsa (8):
      perf x86: Add precise sysfs cpu pmu attribute
      perf tools: Add precise object to interface sysfs precise
      perf tests: Add precise event automated test
      perf tools: Set maximum precise value for event 'p' modifier
      perf tools: Set maximum precise value for 'precise' term
      perf tests: Add automated precise term test
      perf: Document the ABI for 'precise' sysfs attribute
      perf: Document the ABI for 'rdpmc' sysfs attribute

 Documentation/ABI/testing/sysfs-bus-event_source-devices-cpu-precise |  10 ++++
 Documentation/ABI/testing/sysfs-bus-event_source-devices-cpu-rdpmc   |   8 +++
 arch/x86/kernel/cpu/perf_event.c                                     |  34 +++++++++----
 tools/perf/Makefile                                                  |   2 +
 tools/perf/tests/builtin-test.c                                      |   4 ++
 tools/perf/tests/parse-events.c                                      | 170 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 tools/perf/tests/precise.c                                           |  49 ++++++++++++++++++
 tools/perf/tests/tests.h                                             |   1 +
 tools/perf/util/parse-events.c                                       |  69 ++++++++++++++++++++++++-
 tools/perf/util/parse-events.h                                       |   3 ++
 tools/perf/util/parse-events.l                                       |   1 +
 tools/perf/util/parse-events.y                                       |   2 +-
 tools/perf/util/precise.c                                            |  44 ++++++++++++++++
 tools/perf/util/util.h                                               |   3 ++
 14 files changed, 379 insertions(+), 21 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-event_source-devices-cpu-precise
 create mode 100644 Documentation/ABI/testing/sysfs-bus-event_source-devices-cpu-rdpmc
 create mode 100644 tools/perf/tests/precise.c
 create mode 100644 tools/perf/util/precise.c
