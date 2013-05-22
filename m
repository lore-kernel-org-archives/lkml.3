Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab3EVFsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 01:48:24 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:47875 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab3EVFsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 01:48:21 -0400
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: michael@ellerman.id.au, mikey@neuling.org
Subject: [PATCH 0/2] Improvement and fixes for BHRB
Date: Wed, 22 May 2013 11:17:45 +0530
Message-Id: <1369201667-9048-1-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052205-2674-0000-0000-00000910A2B6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(1) The first patch fixes a situation like this

Before patch:-
------------

./perf record -j any -e branch-misses:k ls
Error:
The sys_perf_event_open() syscall returned with 95 (Operation not supported) for event (branch-misses:k).
/bin/dmesg may provide additional information.
No CONFIG_PERF_EVENTS=y kernel support configured?

Here 'perf record' actually copies over ':k' filter request into BHRB
privilege state filter config and our previous check in kernel would
fail that.

After patch:-
-------------

/perf record -j any -e branch-misses:k ls
perf  perf.data  perf.data.old  test-mmap-ring
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.002 MB perf.data (~102 samples) ]

(2) The second patch fixes context migration for BHRB filter configuration

Anshuman Khandual (2):
  powerpc, perf: Ignore separate BHRB privilege state filter request
  powerpc, perf: BHRB filter configuration should follow the task

 arch/powerpc/perf/core-book3s.c |  5 ++++-
 arch/powerpc/perf/power8-pmu.c  | 17 +++++++++--------
 2 files changed, 13 insertions(+), 9 deletions(-)

-- 
1.7.11.7

