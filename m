Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab3AaODY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 09:03:24 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:44874 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab3AaODV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 09:03:21 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH 0/2] perf: add new uncore command
Date: Thu, 31 Jan 2013 14:54:37 +0100
Message-Id: <1359640479-5289-1-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds a new command to perf: perf uncore.
It is used to measure processor socket-level metrics
on a system-wide basis and at all priv levels.

The command comes with a set of predefined key metrics
which are useful to measure multi-socket system imbalance
and various bandwidths.

The following metrics are currently defined:
  - memory bandwidth (Nehalem, Westmere, SandyBridge-EP)
  - PCIe bandwidth (SandyBridge-EP)
  - QPI bandwidth (SandyBridge-EP)
  - C-state residency (SandyBridge-EP)

Others can be added in the future.

The command provides options to modify the unit of the metrics
(default: MB/s for bandwidth).

Example on Nehalem:

 # perf uncore
 #------------------------------
 #           Socket0           |
 #------------------------------
 #        RAM Bandwidth        |
 #            Wr             Rd|
 #          MB/s           MB/s|
 #------------------------------
         4954.99       14897.29
         4953.97       14894.56
         4947.52       14874.97

To make plotting easier, the output can be augmented with a timestamp:

 # perf uncore -T
 #----------------------------------------
 #         |           Socket0           |
 #         |------------------------------
 #   Time  |        RAM Bandwidth        |
 #    in   |            Wr             Rd|
 #   secs  |          MB/s           MB/s|
 #----------------------------------------
          1        4952.50       14890.49
          2        4955.55       14900.19
          3        4949.13       14879.60
          4        4954.66       14896.26

The code is split between generic layer (builtin-uncore.c) and
an arch specific layer (arch/*/util/uncore.c). All events are
hardcoded because they don't change for a given processor and
metric computation requires combining multiple events.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

Stephane Eranian (2):
  perf tools: add cpu_map__get_socket()
  perf: add new perf uncore command

 tools/perf/Documentation/perf-uncore.txt |   88 ++++
 tools/perf/Makefile                      |    1 +
 tools/perf/arch/x86/Makefile             |    1 +
 tools/perf/arch/x86/util/uncore.c        |  539 ++++++++++++++++++++++
 tools/perf/builtin-uncore.c              |  739 ++++++++++++++++++++++++++++++
 tools/perf/builtin.h                     |    1 +
 tools/perf/command-list.txt              |    1 +
 tools/perf/perf.c                        |    1 +
 tools/perf/util/cpumap.c                 |   26 ++
 tools/perf/util/cpumap.h                 |    1 +
 tools/perf/util/uncore.h                 |   56 +++
 11 files changed, 1454 insertions(+)
 create mode 100644 tools/perf/Documentation/perf-uncore.txt
 create mode 100644 tools/perf/arch/x86/util/uncore.c
 create mode 100644 tools/perf/builtin-uncore.c
 create mode 100644 tools/perf/util/uncore.h

-- 
1.7.10.4

