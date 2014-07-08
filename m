Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbaGHWQn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:16:43 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:48854 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590AbaGHWQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:16:42 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        acme@redhat.com, namhyung@kernel.org
Subject: [PATCH v1 0/4] perf: add ability to sample interrupted machine state
Date: Wed,  9 Jul 2014 00:15:55 +0200
Message-Id: <1404857759-25105-1-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This short patch series add the ability to sample the interrupted
machine state for each hardware sample. This is useful to analyze
the state after certain events, for instance for function value
profiling after a call instruction.

The patch extends the interface with a new PERF_SAMPLE_REGS_INTR 
smaple_type flag. The register to sample can be named in the
sample_regs_intr bitmask for each event. The name and bit
position for each register is architecture dependent and
provided, just like for PERF_SAMPLE_REGS_USER by asm/perf_regs.h.

The support is similar to PERF_SAMPLE_REGS_USER.

On Intel x86, the series includes support for capturing the
PEBS state as well. When precise sampling is used, the interrupted
state is collect from the PEBS records, at least partially.
The PEBS machine state is a subset of the machine state.

The series provides access to this new feature in perf record
with the -I option. It is possible to display the sampled
register values using perf report -D.

This patch series is the fundation for a future series adding
function value profiling.

Stephane Eranian (4):
  perf: add ability to sample machine state on interrupt
  perf/x86: add support for sampling PEBS machine state registers
  perf tools: add core support for sampling intr machine state regs
  perf record: add new -I option to sample interrupted machine state

 arch/x86/kernel/cpu/perf_event_intel_ds.c |   19 +++++++++++++
 include/linux/perf_event.h                |    7 +++--
 include/uapi/linux/perf_event.h           |   14 ++++++++-
 kernel/events/core.c                      |   44 +++++++++++++++++++++++++++--
 tools/perf/builtin-record.c               |    2 ++
 tools/perf/perf.h                         |    1 +
 tools/perf/util/event.h                   |    7 +++++
 tools/perf/util/evsel.c                   |   23 ++++++++++++++-
 tools/perf/util/session.c                 |   26 +++++++++++++++++
 9 files changed, 137 insertions(+), 6 deletions(-)


-- 
1.7.9.5

