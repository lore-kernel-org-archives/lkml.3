Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107AbaFSP6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 11:58:46 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:56410 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757906AbaFSP6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:58:44 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, jmario@redhat.com,
        dzickus@redhat.com, jolsa@redhat.com, acme@redhat.com
Subject: [PATCH 0/2] perf/x86: improve Intel load latency and precise store event constraints
Date: Thu, 19 Jun 2014 17:58:27 +0200
Message-Id: <1403193509-22393-1-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This short series of patches improves the event contraint
tables for Intel SNB, IVB and HSW processors.

1/ removes unnecessary constraints on the Load Latency event

   The constraint to counter 3 is not needed. The events works
   well on any PEBS-capable counter. The artificial constraint on
   counter 3, was used to simplify event scheduling because the
   event uses an extra MSR which is ahred by all the counters.
   But perf_events can managed shared regs without artificial
   counter constraints.

2/ remove unecessary constraint on precise store on HSW

    On SNB,IVB, the precise store event has to be on counter 3.
    On HSW, precise store is not implemented the same way and
    can use any counter. Thus we lift the constraint on all
    precise store events on HSW.

The advantage of this series is that it allows capturing load
latency and precise store events at the same time without
multiplexing.

Stephane Eranian (2):
  perf/x86: update Haswell PEBS event constraints
  perf/x86: fix constraint for load latency and precise store event

 arch/x86/kernel/cpu/perf_event_intel.c    |    2 --
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   22 ++++++++--------------
 2 files changed, 8 insertions(+), 16 deletions(-)

-- 
1.7.9.5

