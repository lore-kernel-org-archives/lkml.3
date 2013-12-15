Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab3LOEcZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 23:32:25 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:8650 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903Ab3LOEcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 23:32:22 -0500
From: Davidlohr Bueso <davidlohr@hp.com>
To: linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@redhat.com, dvhart@linux.intel.com,
        peterz@infradead.org, tglx@linutronix.de, jason.low2@hp.com,
        Waiman.Long@hp.com, scott.norton@hp.com, aswin@hp.com,
        davidlohr@hp.com
Subject: [PATCH 0/3] perf-bench: introduce futex microbenchmarks
Date: Sat, 14 Dec 2013 20:31:54 -0800
Message-Id: <1387081917-9102-1-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds three programs that stress and measure different futex
operations: (i) uaddr hashing, (ii) wakeups and (iii) requeuing/waiting.

More details and usage examples in each individual patch, along with parameter
descriptions in the code.

While the previous effort (https://lkml.org/lkml/2012/5/17/207) to add futex 
benchmarks to perf-bench failed, I strongly believe that perf is an ideal place 
for these kinds of programs. This patchset is different from Hitoshi's because
it does not try to take over Darren's futextest suite, and only deals with 
finer grained aspects of the kernel's implementation, and thus mostly useful
for kernel hacking. Furthermore, by being part of the kernel tree, it can get
more attention and naturally evolve with time.

Thanks!

Davidlohr Bueso (3):
  perf-bench: add futex-hash microbenchmark
  perf-bench: add futex-wake microbenchmark
  perf-bench: add futex-requeue microbenchmark

 tools/perf/Makefile.perf         |   3 +
 tools/perf/bench/bench.h         |   3 +
 tools/perf/bench/futex-hash.c    | 212 +++++++++++++++++++++++++++++++++++++++
 tools/perf/bench/futex-requeue.c | 211 ++++++++++++++++++++++++++++++++++++++
 tools/perf/bench/futex-wake.c    | 201 +++++++++++++++++++++++++++++++++++++
 tools/perf/bench/futex.h         |  71 +++++++++++++
 tools/perf/builtin-bench.c       |  12 ++-
 tools/perf/perf.h                |   6 ++
 8 files changed, 718 insertions(+), 1 deletion(-)
 create mode 100644 tools/perf/bench/futex-hash.c
 create mode 100644 tools/perf/bench/futex-requeue.c
 create mode 100644 tools/perf/bench/futex-wake.c
 create mode 100644 tools/perf/bench/futex.h

-- 
1.8.1.4

