Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbaAWTGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:06:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34954 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbaAWTGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:06:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Qais Yousef <qais.yousef@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.12 15/27] crash_dump: fix compilation error (on MIPS at least)
Date: Thu, 23 Jan 2014 11:06:52 -0800
Message-Id: <20140123190650.292792208@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140123190648.720195687@linuxfoundation.org>
References: <20140123190648.720195687@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qais Yousef <qais.yousef@imgtec.com>

commit 5a610fcc7390ee60308deaf09426ada87a1eeec2 upstream.

  In file included from kernel/crash_dump.c:2:0:
  include/linux/crash_dump.h:22:27: error: unknown type name `pgprot_t'

when CONFIG_CRASH_DUMP=y

The error was traced back to commit 9cb218131de1 ("vmcore: introduce
remap_oldmem_pfn_range()")

include <asm/pgtable.h> to get the missing definition

Signed-off-by: Qais Yousef <qais.yousef@imgtec.com>
Reviewed-by: James Hogan <james.hogan@imgtec.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/crash_dump.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/crash_dump.h
+++ b/include/linux/crash_dump.h
@@ -6,6 +6,8 @@
 #include <linux/proc_fs.h>
 #include <linux/elf.h>
 
+#include <asm/pgtable.h> /* for pgprot_t */
+
 #define ELFCORE_ADDR_MAX	(-1ULL)
 #define ELFCORE_ADDR_ERR	(-2ULL)
 


