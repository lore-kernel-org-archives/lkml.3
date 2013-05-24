Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862Ab3EXNIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 09:08:17 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:58072 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970Ab3EXNIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 09:08:14 -0400
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: [PATCH 0/2] kdump/mmap: Fix mmap of /proc/vmcore for s390
Date: Fri, 24 May 2013 15:08:07 +0200
Message-Id: <1369400889-11064-1-git-send-email-holzheu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.6
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052413-3548-0000-0000-0000057CA38E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek and Hatayama,

Currently the /proc/vmcore mmap patches are not working on s390. The
problem is that on s390 the kernel in not relocatable and therefore
always runs in the lower memory area. Therefore for kdump on s390 we
swap the lower memory area with the crashkernel area before starting
the kdump kernel:

[0 - OLDMEM_SIZE] is mapped to [OLDMEM_BASE - OLDMEM_BASE + OLDMEM_SIZE]

To fix /proc/vmcore mmap memory below OLDMEMSIZE needs to be mapped
with OLDMEM_BASE as offset. To achieve that, a new weak function
arch_oldmem_remap_pfn_range() is introduced.

If you agree with our approach, could you integrate the two patches
into the mmap patch series?

Best Regards,
Michael

---
Jan Willeke (2):
  kdump/mmap: Introduce arch_oldmem_remap_pfn_range()
  s390/kdump/mmap: Implement arch_oldmem_remap_pfn_range() for s390

 arch/s390/kernel/crash_dump.c | 27 +++++++++++++++++++++++++++
 fs/proc/vmcore.c              | 15 ++++++++++++++-
 include/linux/crash_dump.h    |  5 +++++
 3 files changed, 46 insertions(+), 1 deletion(-)

-- 
1.8.1.6

