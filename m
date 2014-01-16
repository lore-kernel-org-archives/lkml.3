Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436AbaAPXyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 18:54:10 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:60133 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbaAPXyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 18:54:05 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux PPC <linuxppc-dev@lists.ozlabs.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 0/8] Add support for PowerPC Hypervisor supplied performance counters
Date: Thu, 16 Jan 2014 15:53:46 -0800
Message-Id: <1389916434-2288-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.2
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011623-1542-0000-0000-0000054CECC7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add basic pmus for 2 powerpc hypervisor interfaces to obtain
performance counters: gpci ("get performance counter info") and 24x7.

The counters supplied by these interfaces are continually counting and never
need to be (and cannot be) disabled or enabled. They additionally do not
generate any interrupts. This makes them in some regards similar to software
counters, and as a result their implimentation shares some common code (which
an initial patch exposes) with the sw counters.

There is ongoing work to support transactions for each of these pmus.

Cody P Schafer (8):
  perf: add PMU_RANGE_ATTR() helper for use by sw-like pmus
  perf core: export swevent hrtimer helpers
  powerpc: add hvcalls for 24x7 and gpci (get performance counter info)
  powerpc: add hv_gpci interface header
  powerpc: add 24x7 interface header
  powerpc/perf: add support for the hv gpci (get performance counter
    info) interface
  powerpc/perf: add support for the hv 24x7 interface
  powerpc/perf: add kconfig option for hypervisor provided counters

 arch/powerpc/include/asm/hv_24x7.h     | 239 ++++++++++++++++
 arch/powerpc/include/asm/hv_gpci.h     | 490 +++++++++++++++++++++++++++++++++
 arch/powerpc/include/asm/hvcall.h      |   6 +-
 arch/powerpc/perf/Makefile             |   2 +
 arch/powerpc/perf/hv-24x7.c            | 354 ++++++++++++++++++++++++
 arch/powerpc/perf/hv-gpci.c            | 235 ++++++++++++++++
 arch/powerpc/platforms/Kconfig.cputype |   6 +
 include/linux/perf_event.h             |  22 +-
 kernel/events/core.c                   |   8 +-
 9 files changed, 1356 insertions(+), 6 deletions(-)
 create mode 100644 arch/powerpc/include/asm/hv_24x7.h
 create mode 100644 arch/powerpc/include/asm/hv_gpci.h
 create mode 100644 arch/powerpc/perf/hv-24x7.c
 create mode 100644 arch/powerpc/perf/hv-gpci.c

-- 
1.8.5.2

