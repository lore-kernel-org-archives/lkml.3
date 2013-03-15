Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab3CONoe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:44:34 -0400
Received: from multi.imgtec.com ([194.200.65.239]:34593 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754268Ab3CONod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:44:33 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Robert Richter <rric@kernel.org>, <oprofile-list@lists.sf.net>
Subject: [PATCH 0/9] metag: perf fixes and OProfile support
Date: Fri, 15 Mar 2013 13:43:39 +0000
Message-ID: <1363355028-23278-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_03_15_13_44_29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes some issues in the Meta support for perf events
(particularly perf counter interrupts), and then adds OProfile support
to the Meta architecture based on perf.

This is aimed at v3.10.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Robert Richter <rric@kernel.org>
Cc: oprofile-list@lists.sf.net

James Hogan (9):
  metag: perf: fix core internal / perf channel mux
  metag: perf: fix wrap handling in delta calculation
  metag: perf: fixes for interrupting perf counters
  metag: perf: add missing prev_count updates
  metag: perf: fix frequency sampling (dynamic period)
  metag: perf: use hard_processor_id() to get thread
  metag: perf: don't reset TXTACTCYC
  metag: perf: prepare for use by oprofile
  metag: OProfile support

 arch/metag/Kconfig                  |  4 ++
 arch/metag/Makefile                 |  2 +
 arch/metag/kernel/perf/perf_event.c | 74 +++++++++++++++++++++++++------------
 arch/metag/oprofile/Makefile        | 17 +++++++++
 arch/metag/oprofile/backtrace.c     | 63 +++++++++++++++++++++++++++++++
 arch/metag/oprofile/backtrace.h     |  6 +++
 arch/metag/oprofile/common.c        | 66 +++++++++++++++++++++++++++++++++
 7 files changed, 209 insertions(+), 23 deletions(-)
 create mode 100644 arch/metag/oprofile/Makefile
 create mode 100644 arch/metag/oprofile/backtrace.c
 create mode 100644 arch/metag/oprofile/backtrace.h
 create mode 100644 arch/metag/oprofile/common.c

-- 
1.8.1.2


