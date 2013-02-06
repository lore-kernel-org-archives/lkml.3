Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab3BFOqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 09:46:20 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:53549 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772Ab3BFOqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 09:46:16 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH 0/2] perf stat: add per processor socket count aggregation
Date: Wed,  6 Feb 2013 15:46:00 +0100
Message-Id: <1360161962-9675-1-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds per-processor socket count aggregation
for system-wide mode measurements. This is a useful
mode to detect imbalance between sockets for uniform
workloads.

To enable this mode, use --aggr-socket in addition
to -a. (system-wide). This mode can be combined with
interval printing.

The output includes the socket number and the number
of online processors on that socket. This is useful
to gauge the amount of aggregation.

 # ./perf stat -I 1000 -a --aggr-socket -e cycles sleep 2
 #           time socket cpus             counts events
      1.000097680 S0        4          5,788,785 cycles
      2.000379943 S0        4         27,361,546 cycles
      2.001167808 S0        4            818,275 cycles

Signed-off-by: Stephane Eranian <eranian@google.com>

Stephane Eranian (2):
  perf tools: add cpu_map processor socket level functions
  perf stat: add per processor socket count aggregation

 tools/perf/builtin-stat.c |  126 +++++++++++++++++++++++++++++++++++++++++----
 tools/perf/util/cpumap.c  |   54 +++++++++++++++++++
 tools/perf/util/cpumap.h  |    9 ++++
 3 files changed, 178 insertions(+), 11 deletions(-)

-- 
1.7.9.5

