Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932790Ab3LDP7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 10:59:55 -0500
Received: from multi.imgtec.com ([194.200.65.239]:9194 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932404Ab3LDP7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 10:59:53 -0500
From: Qais Yousef <qais.yousef@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Qais Yousef <qais.yousef@imgtec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>, <linux-mips@linux-mips.org>,
        <stable@vger.kernel.org>
Subject: [PATCH] crash_dump: fix compilation error (on MIPS at least)
Date: Wed, 4 Dec 2013 15:58:22 +0000
Message-ID: <1386172702-31266-1-git-send-email-qais.yousef@imgtec.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.154.36]
X-SEF-Processed: 7_3_0_01192__2013_12_04_15_59_50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  In file included from kernel/crash_dump.c:2:0:
  include/linux/crash_dump.h:22:27: error: unknown type name ‘pgprot_t’

when CONFIG_CRASH_DUMP=y

The error was traced back to this commit:

  9cb218131de1 vmcore: introduce remap_oldmem_pfn_range()

include <asm/pgtable.h> to get the missing definition

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: <linux-mips@linux-mips.org>
Cc: <stable@vger.kernel.org> # 3.12
Reviewed-by: James Hogan <james.hogan@imgtec.com>
Signed-off-by: Qais Yousef <qais.yousef@imgtec.com>
---
I haven't tried any other architecture except mips.
If OK this should be considered for stable 3.12 (CCed).

 include/linux/crash_dump.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/crash_dump.h b/include/linux/crash_dump.h
index fe68a5a..7032518 100644
--- a/include/linux/crash_dump.h
+++ b/include/linux/crash_dump.h
@@ -6,6 +6,8 @@
 #include <linux/proc_fs.h>
 #include <linux/elf.h>
 
+#include <asm/pgtable.h> /* for pgprot_t */
+
 #define ELFCORE_ADDR_MAX	(-1ULL)
 #define ELFCORE_ADDR_ERR	(-2ULL)
 
-- 
1.7.1


