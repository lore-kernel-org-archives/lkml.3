Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbaF0Nsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 09:48:31 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:42057 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739AbaF0Ns3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 09:48:29 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, jmario@redhat.com,
        dzickus@redhat.com, jolsa@redhat.com, acme@redhat.com
Subject: [PATCH v2 0/2] perf/x86: simplify PEBS constraints
Date: Fri, 27 Jun 2014 15:48:01 +0200
Message-Id: <1403876883-3059-1-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This short series of patches greatly simplifies event
constraints for PEBS events on Intel NHM/WSM,SNB/IVB/,HSW.

The first patch removes all non counter specific or special
constraint for PEBS event. It is based on the fact that
enabling precise (PEBS) on a event that does not support
PEBS is harmless. No samples is captured. Thus no need
to specify PEBS events in pebs constraint tables. The
first patch is based on PeterZ initial patch proposal
posted on LKML (https://lkml.org/lkml/2014/6/19/343).

The second patch simplifies the constraint for the
Load Latency event. It was hardcoded to counter 3
when in fact, it can run perfectly well on any PEBS
counter. The constraint was there to help simplify
scheduling of the event which requires an extra
MSR shared with all other counters on the PMU.
But in Linux, we have an infrastructure to handle
shared regs like this. The advantage is that
we can now combine load latency and precise
store sampling in a single run without multiplexing.


Stephane Eranian (2):
  perf/x86: simplify PEBS constraints
  perf/x86: load latency event supports all PEBS counters

 arch/x86/kernel/cpu/perf_event.h          |    4 ++
 arch/x86/kernel/cpu/perf_event_intel.c    |   12 +++-
 arch/x86/kernel/cpu/perf_event_intel_ds.c |  109 +++--------------------------
 3 files changed, 25 insertions(+), 100 deletions(-)

-- 
1.7.9.5

