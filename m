Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab3INAv2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 20:51:28 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:58544 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755827Ab3INAtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 20:49:22 -0400
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: <linux-kernel@vger.kernel.org>
Cc: linuxppc-dev@ozlabs.org, Stephane Eranian <eranian@google.com>,
        Michael Ellerman <michaele@au1.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: [PATCH 0/8][v4] powerpc/perf: Export memory hierarchy level in Power7/8.
Date: Fri, 13 Sep 2013 17:49:07 -0700
Message-Id: <1379119755-21025-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091400-0320-0000-0000-000001011530
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Power7 and Power8 processors save the memory hierarchy level (eg: L2, L3)
from which a load or store instruction was satisfied. Export this hierarchy
information to the user via the perf_mem_data_src object.

Thanks to input from Stephane Eranian, Michael Ellerman, Michael Neuling.

Sukadev Bhattiprolu (8):
  powerpc/perf: Rename Power8 macros to start with PME
  powerpc/perf: Export Power8 generic events in sysfs
  powerpc/perf: Add PM_MRK_GRP_CMPL event to sysfs.
  powerpc/perf: Define big-endian version of perf_mem_data_src
  powerpc/perf: Export Power8 memory hierarchy info to user space.
  powerpc: Rename branch_opcode() to instr_opcode()
  power: implement is_instr_load_store().
  powerpc/perf: Export Power7 memory hierarchy info to user space.

 arch/powerpc/include/asm/code-patching.h     |    1 +
 arch/powerpc/include/asm/perf_event_server.h |    2 +
 arch/powerpc/lib/code-patching.c             |   96 ++++++++++++++++++++++-
 arch/powerpc/perf/core-book3s.c              |   11 +++
 arch/powerpc/perf/power7-pmu.c               |   94 +++++++++++++++++++++++
 arch/powerpc/perf/power8-pmu.c               |  105 +++++++++++++++++++++++---
 include/uapi/linux/perf_event.h              |   58 ++++++++++++++
 7 files changed, 352 insertions(+), 15 deletions(-)

-- 
1.7.9.5

