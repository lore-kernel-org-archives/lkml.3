Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbaDDG1c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:27:32 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:36338 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbaDDG11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:27:27 -0400
From: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org, x86@kernel.org
Cc: benh@kernel.crashing.org, paulus@samba.org,
        kirill.shutemov@linux.intel.com, rusty@rustcorp.com.au,
        akpm@linux-foundation.org, riel@redhat.com, mgorman@suse.de,
        ak@linux.intel.com, peterz@infradead.org, mingo@kernel.org,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Subject: [PATCH V2 0/2] FAULT_AROUND_ORDER patchset performance data for powerpc
Date: Fri,  4 Apr 2014 11:57:13 +0530
Message-Id: <1396592835-24767-1-git-send-email-maddy@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.10.4
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040406-8256-0000-0000-00000C4A6853
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill A. Shutemov with faultaround patchset introduced
vm_ops->map_pages() for mapping easy accessible pages around
fault address in hope to reduce number of minor page faults.

This patchset creates infrastructure to move the FAULT_AROUND_ORDER
to arch/ using Kconfig. This will enable architecture maintainers
to decide on suitable FAULT_AROUND_ORDER value based on
performance data for that architecture. First patch also adds
FAULT_AROUND_ORDER Kconfig element for X86. Second patch list
out the performance numbers for powerpc (platform pseries) and
adds FAULT_AROUND_ORDER Kconfig element for powerpc.

V2 Changes:
  Created Kconfig parameter for FAULT_AROUND_ORDER
  Added check in do_read_fault to handle FAULT_AROUND_ORDER value of 0
  Made changes in commit messages.

Madhavan Srinivasan (2):
  mm: move FAULT_AROUND_ORDER to arch/
  mm: add FAULT_AROUND_ORDER Kconfig paramater for powerpc

 arch/powerpc/platforms/pseries/Kconfig |    5 +++++
 arch/x86/Kconfig                       |    4 ++++
 include/linux/mm.h                     |    9 +++++++++
 mm/memory.c                            |   12 +++++-------
 4 files changed, 23 insertions(+), 7 deletions(-)

-- 
1.7.10.4

