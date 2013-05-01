Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab3EAR5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 13:57:21 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:42650 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab3EAR5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 13:57:12 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 01 May 2013 23:19:50 +0530
Message-Id: <20130501174950.7229.15267.sendpatchset@srdronam.in.ibm.com>
Subject: [PATCH 0/2] Simple concepts extracted from tip/numa/core.
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050117-7014-0000-0000-000002EF8E92
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is an attempt to pick few interesting patches from tip/numa/core.
For the initial stuff, I have selected the last_nidpid (which was
last_cpupid + Make gcc to not reread the page tables patches).

Here is the performance results of running autonumabenchmark on a 8 node 64
core system.  Each of these tests were run  for 5 iterations.


KernelVersion: v3.9
                        Testcase:      Min      Max      Avg
                          numa01:  1784.16  1864.15  1800.16
             numa01_THREAD_ALLOC:   293.75   315.35   311.03
                          numa02:    32.07    32.72    32.59
                      numa02_SMT:    39.27    39.79    39.69

KernelVersion: v3.9 + last_nidpid + gcc: no reread patches
                        Testcase:      Min      Max      Avg  %Change
                          numa01:  1774.66  1870.75  1851.53   -2.77%
             numa01_THREAD_ALLOC:   275.18   279.47   276.04   12.68%
                          numa02:    32.75    34.64    33.13   -1.63%
                      numa02_SMT:    32.00    36.65    32.93   20.53%

We do see some degradation in numa01 and numa02 cases. The degradation is
mostly because of the last_nidpid patch. However the last_nidpid helps
thread_alloc and smt cases and forms the basis for few more interesting
ideas in the tip/numa/core.


 arch/x86/mm/gup.c                 |   23 ++++++++++--
 include/linux/mm.h                |   72 ++++++++++++++++++++++++-------------
 include/linux/mm_types.h          |    4 +-
 include/linux/page-flags-layout.h |   25 ++++++++-----
 mm/huge_memory.c                  |    2 +-
 mm/memory.c                       |    6 ++--
 mm/mempolicy.c                    |   20 ++++++++---
 mm/migrate.c                      |    4 +-
 mm/mm_init.c                      |   10 +++---
 mm/mmzone.c                       |   14 ++++----
 mm/page_alloc.c                   |    4 +-
 11 files changed, 120 insertions(+), 64 deletions(-)

--
Thanks and Regards
Srikar


-- 
Thanks and Regards
Srikar Dronamraju

