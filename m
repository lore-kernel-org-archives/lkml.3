Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbaAHKQE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 05:16:04 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:38801 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbaAHKQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 05:16:01 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, zheng.z.yan@intel.com, bp@alien8.de,
        vincent.weaver@maine.edu, maria.n.dimakopoulou@gmail.com
Subject: [PATCH v2 0/2] perf/x86: various RAPL improvements and fixes
Date: Wed,  8 Jan 2014 11:15:51 +0100
Message-Id: <1389176153-3128-1-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This short patch series provides the following improvements
to the RAPL support for perf_events:
 - support for RAPL PP1 energy counter
 - fix struct perf_event active_list field initialization

The PP1 counter maps to the builtin graphic card for client
processors. that is why it is called energy-gpu.

The new energy event is:
 - name: power/energy-gpu/
 - code: 0x4
 - unit: Joules
 - scaling factor: 2^-32 Joules.

In v2, we renamed energy-pp1 to energy-gpu. We dropped the Haswell
Celeron patch because it is committed already. But we add a fix for
the broken initialization of the active_entry list.

Signed-off-by: Stephane Eranian <eranian@google.com>

Stephane Eranian (2):
  perf/x86: fix active_entry initialization
  perf/x86: add RAPL PP1 energy counter support

 arch/x86/kernel/cpu/perf_event_intel_rapl.c |   31 +++++++++++++++++++++------
 include/linux/perf_event.h                  |    6 ++----
 kernel/events/core.c                        |    2 ++
 3 files changed, 28 insertions(+), 11 deletions(-)

-- 
1.7.9.5

