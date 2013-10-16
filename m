Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759069Ab3JPCHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 22:07:14 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:54714 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755699Ab3JPCHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 22:07:10 -0400
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
        Stephane Eranian <eranian@google.com>,
        Michael Ellerman <michaele@au1.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: [PATCH 00/10][v6] powerpc/perf: Export memory hierarchy level in Power7/8.
Date: Tue, 15 Oct 2013 19:06:32 -0700
Message-Id: <1381889202-16826-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101602-7182-0000-0000-000008C190B5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Power7 and Power8 processors save the memory hierarchy level (eg: L2, L3)
from which a load or store instruction was satisfied. Export this hierarchy
information to the user via the perf_mem_data_src object.

Thanks to input from Stephane Eranian, Michael Ellerman, Michael Neuling
and Anshuman Khandual.

Sukadev Bhattiprolu (10):
  powerpc: Rename branch_opcode() to instr_opcode()
  powerpc/Power7: detect load/store instructions
  tools/perf: silence compiler warnings
  tools/perf: Remove local byteorder.h.
  powerpc/perf: Remove PME_ prefix for power7 events
  powerpc/perf: Export Power8 generic events in sysfs
  powerpc/perf: Add Power8 event PM_MRK_GRP_CMPL to sysfs.
  powerpc/perf: Define big-endian version of perf_mem_data_src
  powerpc/perf: Export Power8 memory hierarchy info to user space.
  powerpc/perf: Export Power7 memory hierarchy info to user space.

 arch/powerpc/include/asm/code-patching.h     |    1 +
 arch/powerpc/include/asm/perf_event_server.h |    4 +-
 arch/powerpc/lib/code-patching.c             |   51 +++++++++++-
 arch/powerpc/perf/core-book3s.c              |   11 +++
 arch/powerpc/perf/power7-pmu.c               |  112 +++++++++++++++++++++++---
 arch/powerpc/perf/power8-events-list.h       |   21 +++++
 arch/powerpc/perf/power8-pmu.c               |   97 ++++++++++++++++++++--
 include/uapi/linux/perf_event.h              |   16 ++++
 tools/perf/Makefile                          |    1 -
 tools/perf/util/include/asm/byteorder.h      |    2 -
 tools/perf/util/include/linux/types.h        |   20 +++++
 tools/perf/util/srcline.c                    |    4 +-
 12 files changed, 316 insertions(+), 24 deletions(-)
 create mode 100644 arch/powerpc/perf/power8-events-list.h
 delete mode 100644 tools/perf/util/include/asm/byteorder.h

-- 
1.7.9.5

