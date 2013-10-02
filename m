Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab3JBAPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 20:15:33 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:49997 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab3JBAPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 20:15:31 -0400
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
        Stephane Eranian <eranian@google.com>,
        Michael Ellerman <michaele@au1.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: 
Date: Tue,  1 Oct 2013 17:15:01 -0700
Message-Id: <1380672911-12812-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100200-1344-0000-0000-0000021574CE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 0/9][v5] powerpc/perf: Export memory hierarchy level in Power7/8.

Power7 and Power8 processors save the memory hierarchy level (eg: L2, L3)
from which a load or store instruction was satisfied. Export this hierarchy
information to the user via the perf_mem_data_src object.

Thanks to input from Stephane Eranian, Michael Ellerman, Michael Neuling
and Anshuman Khandual.

Sukadev Bhattiprolu (9):
  powerpc/perf: Rename Power8 macros to start with PME
  powerpc/perf: Export Power8 generic events in sysfs
  powerpc/perf: Add Power8 event PM_MRK_GRP_CMPL to sysfs.
  powerpc: Rename branch_opcode() to instr_opcode()
  powerpc: implement is_instr_load_store().
  powerpc/perf: Define big-endian version of perf_mem_data_src
  powerpc/perf: Export Power8 memory hierarchy info to user space.
  powerpc/perf: Export Power7 memory hierarchy info to user space.
  powerpc/perf: Update perf-mem man page for Power

 arch/powerpc/include/asm/code-patching.h     |    1 +
 arch/powerpc/include/asm/perf_event_server.h |    2 +
 arch/powerpc/lib/code-patching.c             |   96 ++++++++++++++++++++++-
 arch/powerpc/perf/core-book3s.c              |   11 +++
 arch/powerpc/perf/power7-pmu.c               |   94 +++++++++++++++++++++++
 arch/powerpc/perf/power8-pmu.c               |  105 +++++++++++++++++++++++---
 include/uapi/linux/perf_event.h              |   58 ++++++++++++++
 tools/perf/Documentation/perf-mem.txt        |   11 +++
 tools/perf/util/include/asm/byteorder.h      |    1 +
 9 files changed, 364 insertions(+), 15 deletions(-)

-- 
1.7.9.5

