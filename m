Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbaHKT0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 15:26:33 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:49331 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660AbaHKT0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 15:26:32 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com
Subject: [PATCH v2 0/4] perf/x86: simplify PEBS event constraint management
Date: Mon, 11 Aug 2014 21:27:09 +0200
Message-Id: <1407785233-32193-1-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchkit revamps the PEBS tables on most Intel CPUs, both simplifying
and fixing a couple of problems on Haswell processors:
 - All PEBS event supported
 - data address and data source is now reported correctly for all events

We simplify the tables by using the fact that non-PEBS event when used
in PEBS mode do not generate any PEBS records , thus they are safe to use.
This helps simplify the PEBS event constraints because they do not need
to list all suported PEBS events anymore. They only need to list
the special PEBS events, such as precise store and load latency.
This avoid some issues where the kernel is missing some PEBS events.

In V2, we cleanup some more the precise_datala() for store events.

Andi Kleen (2):
  perf/x86: Revamp PEBS event selection
  perf/x86: Don't mark DataLA addresses as store

Stephane Eranian (2):
  perf/x86: fix data source encoding issues for load latency/precise
    store
  perf/x86: code cleanups for __intel_pmu_pebs_event()

 arch/x86/include/asm/perf_event.h         |    8 ++
 arch/x86/kernel/cpu/perf_event.h          |   48 +++++++-
 arch/x86/kernel/cpu/perf_event_intel_ds.c |  183 +++++++++++------------------
 include/linux/perf_event.h                |    9 +-
 4 files changed, 129 insertions(+), 119 deletions(-)

-- 
1.7.9.5

